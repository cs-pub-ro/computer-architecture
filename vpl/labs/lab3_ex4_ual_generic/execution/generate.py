import sys, random, re

if len(sys.argv) < 2:
    print("Error: variation hash required", file=sys.stderr)
    sys.exit(1)
H = sys.argv[1]

def rng(salt):
    return random.Random(H + ":" + salt)

def vectors(widths, limit_bits=10, n_random=200, seed=1):
    total = sum(widths)
    if total <= limit_bits:
        vals = range(2 ** total)
    else:
        rnd = random.Random(seed)
        s = {0, 2 ** total - 1} | {1 << i for i in range(total)}
        while len(s) < n_random + total + 2: s.add(rnd.getrandbits(total))
        vals = sorted(s)
    out = []
    for v in vals:                  # split the packed value into per-port values (first port = MSB)
        parts, shift = [], total
        for w in widths:
            shift -= w
            parts.append((v >> shift) & (2 ** w - 1))
        out.append(parts)
    return out

def gen_top(modules):
    L = ["module top;"]
    for k, m in enumerate(modules):
        for n, w in m["inputs"]:  L.append(f"    reg  [{w-1}:0] m{k}_{n};")
        for n, w in m["outputs"]: L.append(f"    wire [{w-1}:0] m{k}_{n};")
        ports = ", ".join(f".{n}(m{k}_{n})" for n, _ in m["outputs"] + m["inputs"])
        par = ("#(" + ", ".join(f".{p}({v})" for p, v in m["params"].items()) + ") ") if m.get("params") else ""
        L.append(f"    {m['name']} {par}dut{k}({ports});")
    L.append("    initial begin")
    for k, m in enumerate(modules):
        ins, outs = m["inputs"], m["outputs"]
        fmt = f"\\n[CHECKER]{m.get('label', m['name'])}|" + " ".join(f"{n}=%b" for n, _ in ins) + "|" + " ".join(f"{n}=%b" for n, _ in outs)
        args = ", ".join([f"m{k}_{n}" for n, _ in ins] + [f"m{k}_{n}" for n, _ in outs])
        for vec in (m["vectors"] if m.get("vectors") else vectors([w for _, w in ins])):
            assign = " ".join(f"m{k}_{n} = {w}'b{v:0{w}b};" for (n, w), v in zip(ins, vec))
            L.append(f"        {assign} #1; $display(\"{fmt}\", {args});")
    L += ["        $finish;", "    end", "endmodule", ""]
    return "\n".join(L)

def gen_top_seq(spec):
    """Cycle-exact checker for clocked modules. spec: name, clk, inputs[(n,w)], outputs[(n,w)], cycles[{input: value}].
    Each cycle: apply inputs, sample outputs BEFORE the rising edge (shows Mealy/combinational paths),
    pulse the clock, sample again AFTER the edge."""
    name, clk = spec["name"], spec.get("clk", "clk")
    ins, outs = spec["inputs"], spec["outputs"]
    L = ["module top;", f"    reg {clk};"]
    for n, w in ins:  L.append(f"    reg  [{w-1}:0] {n};")
    for n, w in outs: L.append(f"    wire [{w-1}:0] {n};")
    ports = ", ".join([f".{clk}({clk})"] + [f".{n}({n})" for n, _ in ins + outs])
    L.append(f"    {name} dut({ports});")
    infmt = "".join(f" {n}=%b" for n, _ in ins)
    outfmt = " ".join(f"{n}=%b" for n, _ in outs)
    args = ", ".join([n for n, _ in ins + outs])
    L += ["    initial begin", f"        {clk} = 0; #1;"]
    rst, prev = spec.get("reset"), None          # reset = (input name, active level)
    for k, vals in enumerate(spec["cycles"]):
        assign = " ".join(f"{n} = {w}'b{vals[n]:0{w}b};" for n, w in ins)
        L.append(f"        {assign} #2;")
        skip_pre = bool(rst) and vals[rst[0]] == rst[1] and prev != rst[1]
        prev = vals[rst[0]] if rst else None
        if not skip_pre:
            L.append(f'        $display("\\n[CHECKER]{name}|cycle={k} pre{infmt}|{outfmt}", {args});')
        L.append(f"        {clk} = 1; #2;")
        L.append(f'        $display("\\n[CHECKER]{name}|cycle={k} post{infmt}|{outfmt}", {args});')
        L.append(f"        #2; {clk} = 0; #2;")
    L += ["        $finish;", "    end", "endmodule", ""]
    return "\n".join(L)

def write(path, text):
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write(text)

def sample_vectors(widths, n=16, extra=(), salt="tb"):
    """A few input vectors for the student-visible testbench (all of them when the space is small)."""
    total = sum(widths)
    if 2 ** total <= n:
        return vectors(widths, limit_bits=total)
    r = rng("tb:" + salt)
    vs, seen = [], set()
    for v in [list(v) for v in extra] + [[0] * len(widths), [2 ** w - 1 for w in widths]]:
        if tuple(v) not in seen:
            seen.add(tuple(v)); vs.append(v)
    while len(vs) < n:
        v = [r.randrange(2 ** w) for w in widths]
        if tuple(v) not in seen:
            seen.add(tuple(v)); vs.append(v)
    return vs

def gen_tb(m, vecs, signed=()):
    """Student-visible testbench: applies the vectors and prints inputs and outputs in decimal."""
    ins, outs = m["inputs"], m["outputs"]
    par = ("#(" + ", ".join(f".{p}({v})" for p, v in m["params"].items()) + ") ") if m.get("params") else ""
    L = ["module vpl_tb;"]
    for n, w in ins:  L.append(f"    reg  [{w-1}:0] {n};")
    for n, w in outs: L.append(f"    wire [{w-1}:0] {n};")
    L.append(f"    {m['name']} {par}dut(" + ", ".join(f".{n}({n})" for n, _ in outs + ins) + ");")
    show = lambda n: f"$signed({n})" if n in signed else n
    fmt = " ".join(f"{n}=%0d" for n, _ in ins) + " | " + " ".join(f"{n}=%0d" for n, _ in outs)
    args = ", ".join(show(n) for n, _ in ins + outs)
    L.append("    initial begin")
    for vec in vecs:
        L.append("        " + " ".join(f"{n} = {w}'b{v:0{w}b};" for (n, w), v in zip(ins, vec)) + f' #1; $display("{fmt}", {args});')
    L += ["        $finish;", "    end", "endmodule", ""]
    return "\n".join(L)


OPS = [
    ("add", "adunare: `a + b`", "AE + BE"),
    ("mul", "înmulțire: `a * b`", "AE * BE"),
    ("sub", "scădere: `a - b`, calculată pe @W@ biți (modulo 2^@W@), cu operanzii extinși cu zero", "AE - BE"),
    ("and", "ȘI pe biți: `a & b`", "AE & BE"),
    ("or",  "SAU pe biți: `a | b`", "AE | BE"),
    ("xor", "SAU exclusiv pe biți: `a ^ b`", "AE ^ BE"),
    ("max", "maximul dintre `a` și `b`", "(AE > BE) ? AE : BE"),
    ("min", "minimul dintre `a` și `b`", "(AE < BE) ? AE : BE"),
]

def pair_for(salt):
    return tuple(rng(salt).sample(range(len(OPS)), 2))

def desc(i, bits):
    return OPS[i][1].replace("@W@", str(bits))

PAIR3 = pair_for("l3e3")                 # perechea de la exercițiul 3 (același SECRET => aceeași pereche)
PAIR = pair_for("l3e4")
_k = 0
while PAIR == PAIR3:
    _k += 1
    PAIR = pair_for(f"l3e4#{_k}")
W = rng("l3e4w").choice([3, 4, 5, 6, 8])
PARAMS = {"width": W, "sel0": OPS[PAIR[0]][0], "sel1": OPS[PAIR[1]][0]}
INST = [dict(name="ual", label="ual#implicit", inputs=[("a", W), ("b", W), ("sel", 1)], outputs=[("ual_out", 2 * W)])]
INST += [dict(name="ual", label=f"ual#{w}", params={"width": w}, inputs=[("a", w), ("b", w), ("sel", 1)], outputs=[("ual_out", 2 * w)])
         for w in (3, 5, 7, 8) if w != W]

def top():
    return gen_top(INST)

def sols():
    e0, e1 = OPS[PAIR[0]][2], OPS[PAIR[1]][2]
    return {"ual_sol.v": (f"module ual #(parameter width = {W})(output [2*width-1:0] ual_out, input [width-1:0] a, b, input sel);\n"
                          "    wire [2*width-1:0] AE = a;\n    wire [2*width-1:0] BE = b;\n"
                          f"    assign ual_out = sel ? ({e1}) : ({e0});\nendmodule\n")}

def tb():
    return gen_tb(INST[0], sample_vectors([W, W, 1], 16, extra=[[3, 5, 0], [3, 5, 1]]))


if __name__ == "__main__":
    mode = sys.argv[2] if len(sys.argv) > 2 else ""
    if mode == "eval":                     # hidden checker + reference solution(s) for this student
        write("top.v", top())
        for name, text in sols().items():
            write(name, text)
    elif mode == "run":                    # student-visible testbench for Run
        write("vpl_tb.v", tb())
    elif mode == "dump":                   # (for the teacher) show this student's values
        print(PARAMS)
