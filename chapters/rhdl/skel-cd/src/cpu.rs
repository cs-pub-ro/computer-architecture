use crate::{
    alu::{alu, flags, fr},
    control_unit::{ControlSignals, ControlUnit},
    decode_unit::{Decoded, decode},
    memory::{Ram, RamInput},
    prelude::*,
};
use bitops_rhdl::bitops;
use rhdl::typenum::Diff;
use rhdl_fpga::core::dff::DFF;

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
        | if ir_oe { q.IR[15..8].resize() } else { bits(0) }
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
use termion::{
    event::Key,
    input::TermRead,
    raw::{IntoRawMode, RawTerminal},
    screen::{IntoAlternateScreen, ToAlternateScreen, ToMainScreen}
};
    use crate::{
        alu::alu, control_unit::{self, ControlSignals}, decode_unit::{Decoded, decode}, prelude::*
    };
    type S = <Cpu as Synchronous>::S;
    type O = <Cpu as SynchronousIO>::O;
    use colored::Colorize;

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
    fn run_till_next_instr(cpu: &Cpu, s: &mut S) {
        loop {
            let o = step(cpu, (), s);
            print_cd(&s, &o);

            if cu_state(&s) == Fetch {
                return;
            }
        };
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
    fn print_cd(s: &S, o: &O) -> String {
        let bus = bus(o);
        let regs: Vec<_> = (0..8).into_iter().map(|i| rg(s, i)).collect();
        let t1 = t1(s);
        let t2 = t2(s);
        let ma = ma(s);
        let pc = pc(s);
        let fr = fr(s);
        let ir = ir(s);
        let dec = decode(Bits::from(ir));
        let ram = ram(s)[ma as usize];
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
            .replace("$state          ", &format!("{:^16}", format!("{:?}",state)))
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
        std::process::Command::new("didasm")
            .arg("test.asm")
            .arg("cram.data")
            .arg("--quiet")
            .output()
            .unwrap();
    }
    // #[test]

    // run in an interactive way
    pub fn sim_cpu() -> Result<(), RHDLError> {
        didasm(r#"

hlt
test ra,[bb+xa+]

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
"#);
        let cpu = Cpu::default();
        let mut s: S = cpu.init();
        let mut v = vec![];
        let mut i:usize = 0;
        let ins = vec![(), (), ()].with_reset(1).clock_pos_edge(100);
        cpu.run(ins)?;
        let mut screen = stdout()
        .into_raw_mode()
        .unwrap()
        .into_alternate_screen()
        .unwrap();
        write!(screen, "{}", termion::clear::All)?;
        write!(screen, "{}", termion::cursor::Goto(1, 1))?;
        screen.flush()?;

        write!(screen, "Press ← → or q (step {})\r\n", i)?;
        if i == v.len() {
            let o = step(&cpu, (), &mut s);
            v.push((o,s.clone()));
        }
        let (o,state) = &v[i];
        let myst = print_cd(state, o);
        write!(screen, "{}",myst);
        i = i + 1;

        // print_cd(&s, &o);
        let stdin = std::io::stdin();
        for key in stdin.keys() {
            write!(screen, "{}", termion::clear::All)?;
            write!(screen, "{}", termion::cursor::Goto(1, 1))?;
            write!(screen, "Press ← → or q (step {})\r\n", i)?;
            screen.flush()?;
            match key.unwrap() {
                Key::Left => {
                    i = i.saturating_sub(1);
                    let (o,state) = &v[i];
                    let myst = print_cd(state, o);
                    write!(screen, "{}",myst);
                }
                Key::Right => {
                    if i == v.len() {
                        let o = step(&cpu, (), &mut s);
                        v.push((o,s.clone()));
                    }
                    let (o,state) = &v[i];
                    let myst = print_cd(state, o);
                    write!(screen, "{}",myst);
                    i = i + 1
                }
                Key::Char('q') => break,
                _ => {}
            }
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
