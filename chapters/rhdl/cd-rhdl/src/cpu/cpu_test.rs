use crate::prelude::*;
use crate::cpu::CpuDefault;
type S = <Cpu as Synchronous>::S;
type O = <Cpu as SynchronousIO>::O;
use crate::control_unit::*;
use anyhow::anyhow;
use crate::{
    alu::alu, control_unit::ControlSignals, decode_unit::decode
};
use super::*;
use std::sync::atomic::{AtomicBool, Ordering};

static FIRST_TIME: AtomicBool = AtomicBool::new(true);

fn first_time() -> bool {
    FIRST_TIME.swap(false, Ordering::SeqCst)
}
pub fn start_cpu_test(
    asm_source: &str,
    def_values: CpuDefault
) -> Result<(Cpu, S), RHDLError> {
    std::fs::write("test.asm", asm_source)?;
    let out = std::process::Command::new("didasm")
        .arg("test.asm")
        .arg("cram.data")
        .arg("--quiet")
        .output()
        .map_err(|e| anyhow!("Didasm not available (cargo install didasm --path <computer-architecture-path>/didasm). Fallback is not available in unit tests"))?;
    if !out.status.success() {
        return Err(anyhow!("Assembler failed: {}", String::from_utf8(out.stderr).unwrap()).into());
    }
    let cpu = Cpu::new(def_values);

    // Validate if cpu kernel is valid rhdl (COMPILES ONCE PER TEST, NOT ONCE ACROSS ALL TESTS!!)
    if first_time() {
        let ins = vec![Bits::<U16>::from(0)].with_reset(1).clock_pos_edge(100);
        println!("Validating RHDL code...");
        cpu.run(ins)?;
    }

    // Initialize a state with the values provided in def_values (we need to reset in order for us to get the defaults)
    let mut s: S = cpu.init();
    reset_step(&cpu, &mut s);
    Ok((cpu, s))
}


pub fn rg(s: &S, i: usize) -> u128 {
    s.1.1[i].current.raw()
}
pub fn t1(s: &S) -> u128 {
    s.1.0;
    s.2.1.current.raw()
}
pub fn t2(s: &S) -> u128 {
    s.3.1.current.raw()
}
pub fn ma(s: &S) -> u128 {
    s.4.1.current.raw()
}
pub fn pc(s: &S) -> u128 {
    s.5.1.current.raw()
}
pub fn ir(s: &S) -> u128 {
    s.6.current.raw()
}
pub fn fr(s: &S) -> u128 {
    s.7.current.raw()
}
pub fn cu_state(s: &S) -> State {
    s.8.1.current
}

pub fn control_signals(s: &S) -> ControlSignals {
    s.0.Cu
}

pub fn ram(s: &S) -> Vec<u128> {
    get_ram_vec(&s.9)
}
pub fn bus(o: &O) -> u128 {
    o.0.raw()
}
pub fn run_till_next_instr(cpu: &Cpu, s: &mut S) -> O {
    let mut steps = 0;
    loop {
        if steps > 10000 {
            panic!("Instruction took too many clock cycles!");
        }
        let o = step(cpu, bits(0x0), s);

        if cu_state(&s) == Decode {
            return o;
        }
        steps = steps + 1;
    }
}
pub fn run_till_load_done(cpu: &Cpu, s: &mut S) -> O{
    let mut steps = 0;
    loop {
        if steps > 10000 {
            panic!("Instruction took too many clock cycles!");
        }
        let o = step(cpu, bits(0x0), s);
        if cu_state(&s) == Decode {
            panic!("No load was detected!");
        }
        let cs = control_signals(&s);
        if cs.load_done {
            return o;
        }
        steps = steps + 1;
    }
}
pub fn hex(i: u128) -> String {
    format!("{:04X}", i)
}
pub fn alu_rez(s: &S) -> (u128, u128) {
    let sig = control_signals(s);
    let t1 = if sig.t1_oe {t1(s)} else {0};
    let t2 = if sig.t2_oe {t2(s)} else {0};
    let AluOutput { res, flags } = alu(AluInput::<U16> { t1: Bits::from(t1), t2: Bits::from(t2), carry_in: sig.alu_carry, opsel: sig.alu_sel });
    (res.raw(), crate::alu::fr(flags).raw())
}


pub fn print_cd(s: &S, o: &O, ram_addr: u128) -> String {
    let bus = bus(o);
    let regs: Vec<_> = (0..8).into_iter().map(|i| rg(s, i)).collect();
    let t1 = t1(s);
    let t2 = t2(s);
    let ma = ma(s);
    let pc = pc(s);
    let fr = fr(s);
    let ir = ir(s);
    let dec = decode(Bits::from(ir));
    let ram = ram(s)[(ram_addr as usize) & 0x3FF];
    let state = cu_state(s);
    let signals = control_signals(s);
    let (res, flags) = alu_rez(s);
    let mut template = include_str!("../../cd.txt").to_string()
        .replace("t1w$", if signals.t1_we {"   ↓"} else {"    "})
        .replace("t1o$", if signals.t1_oe {"   ↓"} else {"    "})
        .replace("t2w$", if signals.t2_we {"   ↓"} else {"    "})
        .replace("t2o$", if signals.t2_oe {"   ↓"} else {"    "})
        .replace("maw$", if signals.ma_we {"   ↓"} else {"    "})
        .replace("raw$", if signals.ram_we {"   ↓"} else {"    "})
        .replace("$adr ", if signals.ma_oe {"$adr→"} else {"$adr "})
        .replace(&format!(" {} ", signals.rf_sel), &format!("{}{} ",if signals.rf_we || signals.rf_oe {"→"} else {" "}, signals.rf_sel))
        .replace("rgo$", if signals.rf_oe {"   ↓"} else {"    "})
        .replace("$rgw", if signals.rf_we {"↑   "} else {"    "})
        .replace("$rao", if signals.ram_oe {"↑   "} else {"    "})
        .replace("$pcw", if signals.pc_we {"↑   "} else {"    "})
        .replace("pco$", if signals.pc_oe {"   ↓"} else {"    "})
        .replace("irw$", if signals.ir_we {"   ↓"} else {"    "})
        .replace("$ri", if signals.ir_oe {"↑  "} else {"   "})
        .replace("$fra", if !signals.fr_sel_bus && signals.fr_we {"↓   "} else {"    "})
        .replace("fro$", if signals.fr_oe {"   ↓"} else {"    "})
        .replace("$frb", if signals.fr_sel_bus && signals.fr_we {"↑   "} else {"    "})
        .replace("ao$", if signals.alu_oe {"  ↓"} else {"   "})
        // Value replacements
        .replace("$OP               ", &format!("{:^18}",format!("{:?}({}, {}, {})", signals.alu_sel, if signals.t1_oe {"T1"} else {"0"}, if signals.t2_oe {"T2"} else {"0"}, if signals.alu_carry {1} else {0})))
        .replace("$res              ", &format!("{:^18}", format!("{:04X}",res)))
        .replace("$flag", &format!("{:05b}",flags))
        .replace("$fr  ", &format!("{:05b}",fr))
        .replace("$state                    ", &format!("{:^26}", format!("{:?}",state)))
        .replace("$decoded                                                                           ", &format!("{:^83}", format!("{:?}",dec)))
        .replace("$pc ", &hex(pc))
        .replace("$t1 ", &hex(t1))
        .replace("$t2 ", &hex(t2))
        .replace("$ir ", &hex(ir))
        .replace("$adr", &hex(ma))
        .replace("$val", &hex(ram))
        .replace("$bus", &hex(bus));
    for (i, v) in regs.iter().enumerate() {
        let st = crate::register_file::reg(bits(i as u128)).to_string().to_ascii_lowercase();
        template = template.replace(&format!("${} ", st), &hex(*v));
    }
    template.push('\n');
    template.replace("\n", "\r\n")
}