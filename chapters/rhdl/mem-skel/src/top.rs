use rhdl::prelude::*;
use rhdl_fpga::core::dff::DFF;

use crate::{
    alu::{Alu, AluInput},
    control_unit::{ControlSignals, ControlUnit, Flags},
    doc::write_svg,
    ram::{Ram, RamImput},
    register::{Register, RegisterInput},
    register_file::{RegisterFile, RegisterFileInput},
};

#[derive(Synchronous, SynchronousDQ, Clone, Debug)]

pub struct Top {
    regs: RegisterFile,
    T1: Register,
    T2: Register,
    MA: Register,
    Cu: ControlUnit,
    RAM: Ram,
    alu: Alu,
}

impl Default for Top {
    fn default() -> Self {
        Self {
            T1: Register {
                memory: DFF::new(Bits::<U16>::from(5)),
            },
            T2: Register::default(),
            MA: Register::default(),
            Cu: ControlUnit::default(),
            regs: RegisterFile::default(),
            RAM: Ram::default(),
            alu: Alu {},
        }
    }
}

impl SynchronousIO for Top {
    type I = ();
    type O = Bits<U16>;
    type Kernel = top_kernel;
}

#[kernel]
pub fn top_kernel(_cr: ClockReset, _i: (), _q: Q) -> (Bits<U16>, D) {
    let _bus = _q.regs | _q.RAM | _q.alu.rez;
    let mut _d = D::dont_care();
    let ControlSignals {
        t1_oe,
        t1_we,
        t2_oe,
        t2_we,
        ma_oe,
        ma_we,
        ram_we,
        ram_oe,
        alu_carry,
        alu_sel,
        alu_oe,
        rf_sel,
        rf_oe,
        rf_we,
    } = _q.Cu;
    _d.T1 = RegisterInput {
        oe: t1_oe,
        we: t1_we,
        data_in: _bus,
    };
    _d.T2 = RegisterInput {
        oe: t2_oe,
        we: t2_we,
        data_in: _bus,
    };
    _d.MA = RegisterInput {
        oe: ma_oe,
        we: ma_we,
        data_in: _bus,
    };
    _d.RAM = RamImput {
        oe: ram_oe,
        we: ram_we,
        data_in: _bus,
        address: _q.MA.resize(),
    };
    _d.alu = AluInput {
        carry_in: alu_carry,
        select: alu_sel,
        enable: alu_oe,
        op1: _q.T1,
        op2: _q.T2,
    };
    _d.Cu = Flags {
        transport_flag: _q.alu.transport_flag,
        zero_flag: _q.alu.zero_flag,
    };
    _d.regs = RegisterFileInput {
        oe: rf_oe,
        we: rf_we,
        data_in: _bus,
        sel: rf_sel,
    };
    (_bus, _d)
}

pub fn sim_top() -> Result<(), RHDLError> {
    let top = Top::default();
    let input = vec![(), (), ()];
    let input_data = input.with_reset(1).clock_pos_edge(100);
    let vcd = top.run(input_data)?.collect::<Vcd>();
    let _ = write_svg(vcd, "top.svg");
    Ok(())
}
