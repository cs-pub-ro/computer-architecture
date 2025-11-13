use rhdl::prelude::*;
use rhdl_fpga::core::dff::DFF;

use crate::{alu::AluOpcode, register_file::Sel};

#[derive(Digital, PartialEq, Eq, Debug)]
pub struct Flags {
    pub transport_flag: Bits<U1>,
    pub zero_flag: Bits<U1>,
}

#[derive(Digital, PartialEq, Eq, Debug)]
pub struct ControlSignals {
    pub rf_sel: Sel,
    pub rf_oe: Bits<U1>,
    pub rf_we: Bits<U1>,
    pub t1_oe: Bits<U1>,
    pub t1_we: Bits<U1>,
    pub t2_oe: Bits<U1>,
    pub t2_we: Bits<U1>,
    pub ma_oe: Bits<U1>,
    pub ma_we: Bits<U1>,
    pub ram_oe: Bits<U1>,
    pub ram_we: Bits<U1>,
    pub alu_carry: Bits<U1>,
    pub alu_oe: Bits<U1>,
    pub alu_sel: AluOpcode,
}

#[derive(Synchronous, SynchronousDQ, Clone, Debug)]
pub struct ControlUnit {
    state: DFF<Bits<U2>>,
}

impl Default for ControlUnit {
    fn default() -> Self {
        Self {
            state: DFF::new(Bits::<U2>::default()),
        }
    }
}

impl SynchronousIO for ControlUnit {
    // type I = Flags;
    type I = Flags;
    type O = ControlSignals;
    type Kernel = cu_kernel;
}

#[kernel]
pub fn cu_kernel(_cr: ClockReset, _i: Flags, q: Q) -> (ControlSignals, D) {
    let mut cs = ControlSignals {
        t1_oe: bits(0),
        t1_we: bits(0),
        t2_oe: bits(0),
        t2_we: bits(0),
        ma_oe: bits(0),
        ma_we: bits(0),
        ram_oe: bits(0),
        ram_we: bits(0),
        alu_carry: bits(0),
        alu_oe: bits(0),
        alu_sel: AluOpcode::Adc,
        rf_oe: bits(0),
        rf_sel: Sel::RA,
        rf_we: bits(1),
    };

    // TODO modify in such a way to solve the exercises
    match q.state.raw() {
        0 => {
            cs.t1_oe = bits(1);
            cs.t2_we = bits(1);
        }
        1 => {
            cs.ma_oe = bits(1);
            cs.t1_we = bits(1);
        }
        2 => {
            cs.t1_we = bits(1);
            cs.t2_oe = bits(1);
        }
        3 => {
            cs.t2_we = bits(1);
            cs.ma_oe = bits(1);
        }
        _ => {}
    };
    (
        cs,
        D {
            state: q.state + bits(1),
        },
    )
}
