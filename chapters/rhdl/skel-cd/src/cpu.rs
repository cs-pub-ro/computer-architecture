use crate::{
    alu::{alu, flags, fr},
    control_unit::{ControlSignals, ControlUnit, State},
    decode_unit::{Decoded, decode},
    memory::{Ram, RamInput},
    prelude::*,
};
use bitops_rhdl::bitops;
use rhdl::typenum::Diff;
use rhdl_fpga::core::dff::DFF;

#[derive(Clone, Debug, Default)]
pub struct CpuDefault {
    pub regs: [u128; 8],
    pub T1: u128,
    pub T2: u128,
    pub MA: u128,
    pub IR: u128,
    pub PC: u128,
    pub FR: u128,
    pub state: State,
}
#[derive(Synchronous, SynchronousDQ, Clone, Debug)]

pub struct Cpu {
    pub regs: RegFile<U16>,
    pub T1: Register<U16>,
    pub T2: Register<U16>,
    pub MA: Register<U16>,
    pub PC: Register<U16>,
    // Special register that is always readable by the ControlUnit, not always readable by bus
    pub IR: DFF<Bits<U16>>,
    // Flags register, alyaws visible to ControlUnit
    pub FR: DFF<Bits<U16>>,
    pub Cu: ControlUnit,
    pub RAM: Ram,
    // IO coming soon...
}

impl Default for Cpu {
    fn default() -> Self {
        Self {
            T1: Register {
                memory: DFF::new(Bits::<U16>::from(5)),
            },
            T2: Register::default(),
            MA: Register::default(),
            Cu: ControlUnit::default(),
            regs: RegFile::default(),
            RAM: Ram::from_hex_file("cram.data").unwrap_or_default(),
            IR: DFF::default(),
            PC: Register::default(),
            FR: DFF::default(),
        }
    }
}

impl Cpu {
    pub fn new(init: CpuDefault) -> Self {
        Self {
            T1: Register::new(init.T1),
            T2: Register::new(init.T2),
            MA: Register::new(init.MA),
            Cu: ControlUnit::new(init.state),
            regs: RegFile::new(init.regs),
            RAM: Ram::from_hex_file("cram.data").unwrap_or_default(),
            IR: DFF::new(Bits::from(init.IR)),
            PC: Register::new(init.PC),
            FR: DFF::new(Bits::from(init.FR)),
        }
    }
}

impl SynchronousIO for Cpu {
    type I = ();
    type O = Bits<U16>;
    type Kernel = top_kernel;
}

#[bitops]
#[kernel]
pub fn top_kernel(_cr: ClockReset, _i: (), q: Q) -> (Bits<U16>, D) {
    let mut d = D::dont_care();
    let ControlSignals {
        rf_sel,
        rf_oe,
        rf_we,
        t1_oe,
        t1_we,
        t2_oe,
        t2_we,
        ma_oe,
        ma_we,
        ram_oe,
        ram_we,
        alu_carry,
        alu_oe,
        alu_sel,
        pc_we,
        pc_oe,
        ir_we,
        ir_oe,
        fr_oe,
        fr_we,
        fr_sel_bus,
        ..
    } = q.Cu;
    let alu_res = alu::<U16>(AluInput::<U16> {
        t1: q.T1.1, // Not a bus output
        t2: q.T2.1, // Not a bus output
        carry_in: alu_carry,
        opsel: alu_sel,
    });
    // let alu_res  = AluOutput::<U16> { res: bits(0), flags: AluFlags { c: false, z: false, s: false, o: false, p: false } };
    let bus = if fr_oe { q.FR } else { bits(0) }
        | if ir_oe { (q.IR[8], q.IR[8], q.IR[8], q.IR[8], q.IR[8], q.IR[8], q.IR[8], q.IR[8], q.IR[8], q.IR[9], q.IR[10], q.IR[11], q.IR[12], q.IR[13], q.IR[14], q.IR[15]) } else { bits(0) }
        | q.PC.0 // Bus output
        | q.regs
        | q.RAM
        | if alu_oe { alu_res.res } else { bits(0) };
    d.T1 = RegisterInput::<U16> {
        oe: t1_oe,
        we: t1_we,
        data_in: bus,
    };
    d.T2 = RegisterInput::<U16> {
        oe: t2_oe,
        we: t2_we,
        data_in: bus,
    };
    d.MA = RegisterInput::<U16> {
        oe: ma_oe,
        we: ma_we,
        data_in: bus,
    };
    d.RAM = RamInput {
        oe: ram_oe,
        we: ram_we,
        data_in: bus,
        address: q.MA.1.resize(), // Not a bus output
    };
    d.PC = RegisterInput::<U16> {
        data_in: bus,
        oe: pc_oe,
        we: pc_we,
    };

    // These registers are permanently visible to Control unit
    d.Cu.0 = decode(q.IR);
    d.Cu.1 = flags(q.FR);

    d.IR = if ir_we { bus } else { q.IR };
    d.FR = if fr_we {
        // If from bus ignore anything outside the flag range
        if fr_sel_bus { bus[4..0].resize() } else { fr(alu_res.flags) }
    } else {
        q.FR
    };

    d.regs.0 = RegisterInput::<U16> {
        oe: rf_oe,
        we: rf_we,
        data_in: bus,
    };
    d.regs.1 = rf_sel;
    ((bus), d)
}

// ADD TESTBENCHES
pub mod tests {
    use std::io::{Stdout, Write, stdout};
    use std::fs::File;
    use rand::rng;
    use termion::{
        event::Key,
        input::TermRead,
        raw::{IntoRawMode, RawTerminal},
        screen::{IntoAlternateScreen, ToAlternateScreen, ToMainScreen}
    };
    use anyhow::anyhow;
    use crate::{
        alu::alu, control_unit::{self, ControlSignals}, decode_unit::{Decoded, decode}, prelude::*
    };
    type S = <Cpu as Synchronous>::S;
    type O = <Cpu as SynchronousIO>::O;
    use colored::Colorize;
    use crate::control_unit::*;

    fn rg(s: &S, i: usize) -> u128 {
        s.1.1[i].current.raw()
    }
    fn t1(s: &S) -> u128 {
        s.1.0;
        s.2.1.current.raw()
    }
    fn t2(s: &S) -> u128 {
        s.3.1.current.raw()
    }
    fn ma(s: &S) -> u128 {
        s.4.1.current.raw()
    }
    fn pc(s: &S) -> u128 {
        s.5.1.current.raw()
    }
    fn ir(s: &S) -> u128 {
        s.6.current.raw()
    }
    fn fr(s: &S) -> u128 {
        s.7.current.raw()
    }
    fn cu_state(s: &S) -> control_unit::State {
        s.8.1.current
    }
    fn control_signals(s: &S) -> ControlSignals {
        s.0.Cu
    }
    fn ram(s: &S) -> Vec<u128> {
        get_ram_vec(&s.9)
    }
    fn bus(o: &O) -> u128 {
        o.raw()
    }
    fn run_till_next_instr(cpu: &Cpu, s: &mut S) -> O {
        let mut steps = 0;
        loop {
            if steps > 10000 {
                panic!("Instruction took too many clock cycles!");
            }
            let o = step(cpu, (), s);

            if cu_state(&s) == Decode {
                return o;
            }
            steps = steps + 1;
        }
    }
    fn run_till_load_done(cpu: &Cpu, s: &mut S) -> O{
        let mut steps = 0;
        loop {
            if steps > 10000 {
                panic!("Instruction took too many clock cycles!");
            }
            let o = step(cpu, (), s);
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
    fn hex(i: u128) -> String {
        format!("{:04X}", i)
    }
    fn alu_rez(s: &S) -> (u128, u128) {
        let sig = control_signals(s);
        let t1 = if sig.t1_oe {t1(s)} else {0};
        let t2 = if sig.t2_oe {t2(s)} else {0};
        let AluOutput { res, flags } = alu(AluInput::<U16> { t1: Bits::from(t1), t2: Bits::from(t2), carry_in: sig.alu_carry, opsel: sig.alu_sel });
        (res.raw(), crate::alu::fr(flags).raw())
    }
    //↑ ↓
    fn print_cd(s: &S, o: &O, ram_addr: u128) -> String {
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
        let mut template = include_str!("../cd.txt").to_string()
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
            .replace("$fra", if !signals.fr_sel_bus && signals.fr_we {"   ↓"} else {"    "})
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

    fn didasm(asm_source: &str){
        std::fs::write("test.asm", asm_source);
        if let Err(_) = std::process::Command::new("didasm")
            .arg("test.asm")
            .arg("cram.data")
            .arg("--quiet")
            .output() {
            eprintln!("Didasm not available (cargo install didasm --path <computer-architecture-path>/didasm), falling back to existing cram.data...")
        }
    }
    // #[test]
    // use 
    use super::CpuDefault;
    /// Start a cpu test by providing its current state directly
    fn start_cpu_test(
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

        // Validate if cpu kernel is valid rhdl
        let ins = vec![()].with_reset(1).clock_pos_edge(100);
        cpu.run(ins)?;

        // Initialize a state with the values provided in def_values
        let mut s: S = cpu.init();
        reset_step(&cpu, &mut s);
        Ok((cpu, s))
    }

    // Test just the fetch
    #[test]
    fn test_fetch() {
        let (cpu, mut s) = start_cpu_test(
            r#"
            hlt1
            "#,
            CpuDefault::default()
        ).unwrap();

        step(&cpu, (), &mut s);
        step(&cpu, (), &mut s);
        let state = cu_state(&s);
        assert_eq!(state, State::Fetch(FetchStage::PcToMA));

        step(&cpu, (), &mut s);
        let state = cu_state(&s);
        assert_eq!(state, State::Fetch(FetchStage::MaToMem));
        let MA = ma(&s);
        // TODO change cpu state
        assert_eq!(MA, 0);

        let o = step(&cpu, (), &mut s);
        let state = cu_state(&s);
        assert_eq!(state, State::Fetch(FetchStage::MemToIr));
        let BUS = bus(&o);
        assert_eq!(BUS, 0x0031);
        step(&cpu, (), &mut s);
        let state = cu_state(&s);
        assert_eq!(state, State::Decode);
        let IR = ir(&s);
        assert_eq!(IR, 0x0031);


    }

    #[test]
    fn test_cpu_default_values() {
        let mut init = CpuDefault::default();
        init.regs[4] = 0x69;
        let (cpu, mut s) = start_cpu_test(
            r#"
            hlt
            "#,
            init
        ).unwrap();
        let o = step(&cpu, (), &mut s);
        assert_eq!(rg(&s, 4), 0x69);
    }

    #[test]
    fn test_load_1() {
        let mut init = CpuDefault::default();
        for i in 0..8 {
            init.regs[i] = i as u128 + 1;
        }
        let (cpu, mut s) = start_cpu_test(
            r#"
            sub [ba+43], 42
            50: 0x69
            "#,
            init
        ).unwrap();
        run_till_next_instr(&cpu, &mut s);
        let o = run_till_load_done(&cpu, &mut s);
        assert_eq!(0x69, t1(&s));
        assert_eq!(42, t2(&s));
        assert_eq!(50, ma(&s));
        assert_eq!(2, pc(&s));
    }

    #[test]
    fn test_load_2() {
        let mut init = CpuDefault::default();
        for i in 0..8 {
            init.regs[i] = i as u128 + 1;
        }
        let (cpu, mut s) = start_cpu_test(
            r#"
            mov [ba+43], 42
            50: 0x69
            "#,
            init
        ).unwrap();
        run_till_next_instr(&cpu, &mut s);
        let o = run_till_load_done(&cpu, &mut s);
        assert_ne!(0x69, t1(&s), "You don't have to load the *value* of the memory at effective address for MOV instructions if destination");
        assert_eq!(42, t2(&s));
        assert_eq!(50, ma(&s));
        assert_eq!(2, pc(&s));
    }

    #[test]
    fn test_load_5() {
        let mut init = CpuDefault::default();
        for i in 0..8 {
            init.regs[i] = i as u128 + 1;
        }
        let (cpu, mut s) = start_cpu_test(
            r#"
            add ra, [ba+xb+]
            13: 0x2
            "#,
            init
        ).unwrap();
        run_till_next_instr(&cpu, &mut s);
        let o = run_till_load_done(&cpu, &mut s);
        assert_eq!(true, control_signals(&s).load_done);
        assert_eq!(1, t1(&s));
        assert_eq!(2, t2(&s));
        assert_eq!(13, ma(&s));
        assert_eq!(7, rg(&s, 5));
        assert_eq!(0, pc(&s));
    }

    #[test]
    fn test_load_6() {
        let mut init = CpuDefault::default();
        for i in 0..8 {
            init.regs[i] = i as u128 + 1;
        }
        let (cpu, mut s) = start_cpu_test(
            r#"
            cmp [bb+xa+5], 7
            18: 0x7
            "#,
            init
        ).unwrap();
        run_till_next_instr(&cpu, &mut s);
        let o = run_till_load_done(&cpu, &mut s);
        assert_eq!(7, t1(&s));
        assert_eq!(7, t2(&s));
        assert_eq!(18, ma(&s));
        assert_eq!(2, pc(&s));
    }

    #[test]
    fn test_load_reg_dyn() {
        use rand::prelude::*;
        let mut rng = rand::rng();
        let mut init = CpuDefault::default();
        let mapping = [
            "ra",
            "rb",
            "rc",
            "sp",
            "xa",
            "xb",
            "ba",
            "bb",
        ];

        for i in 0..8 {
            init.regs[i] = rng.random_range(0..u16::MAX) as u128;
        }

        let destination = rng.random_range(0..8) as usize;
        let source = rng.random_range(0..8) as usize;

        let destination_value = init.regs[destination];
        let source_value = init.regs[source];

        let asm_code = format!(
            "add {dst}, {src}",
            dst = mapping[destination],
            src = mapping[source]
        );

        println!("{}", &asm_code);
        let (cpu, mut s) = start_cpu_test(
            &asm_code,
            init
        ).unwrap();

        run_till_next_instr(&cpu, &mut s);
        let o = run_till_load_done(&cpu, &mut s);

        assert_eq!(0, pc(&s));
        assert_eq!(destination_value, t1(&s));
        assert_eq!(source_value, t2(&s));
    }

    // run in an interactive way
    pub fn sim_cpu() -> Result<(), RHDLError> {
        let mut init = CpuDefault::default();
        for i in 0..8 {
            init.regs[i] = i as u128 + 1;
        }
        init.PC = 1;
        let (cpu, mut s) = start_cpu_test(
            r#"
hlt
mov ra, [0x42]
test ra,[bb+xa]
jc -3

sub [ba+43], 42

inc ra
inc [bb]
inc [43]
inc [[12]]
inc [xa+23]
inc [ba+42]
inc [bb+1]
inc [bb+xb]
inc [ba+xa]
inc [bb+xa]
inc [ba+xb+]
inc [bb+xa-]
inc [ba+xb+2]
0x0308: 0x69
            "#,
            init
        ).unwrap();
        let mut v = vec![];
        let mut i:usize = 0;
        let mut screen = stdout()
        .into_raw_mode()
        .unwrap()
        .into_alternate_screen()
        .unwrap();

        // print_cd(&s, &o);
        let stdin = std::io::stdin();
        let mut peek = 0;
        let mut peek_buf = peek;
        let mut wait_for_peek = false;
        let o = step(&cpu, (), &mut s);
        v.push((o,s.clone()));
        write!(screen, "{}", termion::clear::All)?;
        write!(screen, "{}", termion::cursor::Goto(1, 1))?;
        screen.flush()?;
        let help_str = "Press ← → for single clock cycle step, p n for instruction step, d for mem.dump or q; Press /<addr(HEX)><enter> for a peek in ram ";
        write!(screen, "{}(step {}, lookup MA)\r\n", help_str, i);
        let (o,state) = &v[if i >= v.len() {v.len() - 1} else {i}];
        let myst = print_cd(state, o, peek);
        write!(screen, "{}",myst);
        for key in stdin.keys() {
            write!(screen, "{}", termion::clear::All)?;
            write!(screen, "{}", termion::cursor::Goto(1, 1))?;
            screen.flush()?;
            match key.unwrap() {
                Key::Left => {
                    i = i.saturating_sub(1);
                    let (o,state) = &v[i];
                    peek = ma(&state);
                    peek_buf = peek & 0x3FF;
                    wait_for_peek = false;
                    // let myst = print_cd(state, o, peek);
                    // write!(screen, "{}",myst);
                }
                Key::Right => {
                    if i == v.len() {
                        let o = step(&cpu, (), &mut s);
                        v.push((o,s.clone()));
                    }
                    let (o,state) = &v[i];
                    peek = ma(&state);
                    peek_buf = peek & 0x3FF;
                    wait_for_peek = false;
                    // let myst = print_cd(state, o, peek);
                    // write!(screen, "{}",myst);
                    i = i + 1
                }
                Key::Char('q') => break,
                Key::Char('/') => {
                    wait_for_peek=true;
                    peek_buf = 0;
                }
                Key::Char('n') => {
                    let mut steps = 0;
                    wait_for_peek = false;
                    if i != v.len() {
                        i = i + 1;
                    }
                    loop {
                        if steps >= 10000  {
                            break;
                        }
                        if i == v.len() {
                            let o = step(&cpu, (), &mut s);
                            v.push((o,s.clone()));
                        }
                        let (o,state) = &v[i];
                        peek = ma(&state);
                        if matches!(cu_state(&state), Decode|Reset|Hlt) {
                            break;
                        }
                        i = i + 1;
                        steps = steps + 1;
                    };
                }
                Key::Char('p') => {
                    wait_for_peek = false;
                    let mut steps = 0;
                    i = i.saturating_sub(1);
                    loop {
                        if steps >= 10000 {
                            break;
                        }
                        let (o,state) = &v[i];
                        peek = ma(&state);
                        if matches!(cu_state(&state), Decode|Reset|Hlt) {
                            break;
                        }
                        i = i.saturating_sub(1);
                        steps = steps + 1;
                    }
                }
                Key::Char(c @ ('0'..='9' | 'a'..='f')) if wait_for_peek => {
                    let x = c.to_digit(16).map(|d| d as u128).unwrap();
                    peek_buf = (peek_buf << 4 | x) & 0x3FF;
                }
                Key::Char('d') => {
                    let mut file = File::create("mem.dump")?;
                    let (o,state) = &v[i];
                    let ram = ram(&state);
                    for i in ram.into_iter() {
                        writeln!(&mut file, "{:04X}", i)?;
                    }
                }
                Key::Char('\n') => {
                    wait_for_peek=false;
                    peek = peek_buf;

                }
                _ => {}
            }
            
            let (o,state) = &v[if i >= v.len() {v.len() - 1} else {i}];
            let peek_str = format!("{:03X}", peek);
            write!(screen, "{}(step {}, lookup {}{})\r\n", help_str, i, if peek == ma(&state) {
                "MA"
            } else {
                &peek_str
            }, if wait_for_peek {
                format!("; next lookup {:03X}, press enter to commit, accepts [0-3FF]", peek_buf)
            } else {
                "".to_string()
            })?;
            let myst = print_cd(state, o, peek);
            write!(screen, "{}",myst);
        }

        Ok(())
    }
}
pub fn sim_top() -> Result<(), RHDLError> {
    let top = Cpu::default();
    let ins = vec![(), (), ()].with_reset(1).clock_pos_edge(100);
    top.run(ins)?;

    Ok(())
}