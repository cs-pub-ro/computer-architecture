use crate::{
    alu::{alu, flags, fr},
    control_unit::{ControlSignals, ControlUnit},
    decode_unit::decode,
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
        t1: q.T1,
        t2: q.T2,
        carry_in: alu_carry,
        opsel: alu_sel,
    });
    // let alu_res  = AluOutput::<U16> { res: bits(0), flags: AluFlags { c: false, z: false, s: false, o: false, p: false } };
    let bus = if fr_oe { q.FR } else { bits(0) }
        | if ir_oe { q.IR[15..8].resize() } else { bits(0) }
        | q.PC
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
        address: q.MA.resize(),
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
        if fr_sel_bus { bus } else { fr(alu_res.flags) }
    } else {
        q.FR
    };

    d.regs.0 = RegisterInput::<U16> {
        oe: rf_oe,
        we: rf_we,
        data_in: bus,
    };
    d.regs.1 = rf_sel;
    (bus, d)
}

// ADD TESTBENCHES
mod tests {
    use crate::{
        control_unit::{self, ControlSignals},
        prelude::*,
    };
    type S = <Cpu as Synchronous>::S;

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
    fn run_till_next_instr(cpu: &Cpu, s: &mut S) {
        loop {
            step(cpu, (), s);
            if cu_state(&s) == Fetch {
                return;
            }
        };
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
    #[test]
    fn sim_cpu() {
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
        for i in 0..10 {
            run_till_next_instr(&cpu,&mut s);
            println!("{:?}, {}", cu_state(&s), pc(&s));
        }
    }
}
pub fn sim_top() -> Result<(), RHDLError> {
    let top = Cpu::default();
    let ins = vec![(), (), ()].with_reset(1).clock_pos_edge(100);
    top.run(ins)?;

    Ok(())
}
