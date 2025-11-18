use crate::{decode_unit::Decoded, prelude::*};

#[derive(Digital, PartialEq, Debug)]
pub struct ControlSignals {
    pub rf_sel: Reg,
    pub rf_oe: bool,
    pub rf_we: bool,
    pub t1_oe: bool,
    pub t1_we: bool,
    pub t2_oe: bool,
    pub t2_we: bool,
    pub ma_oe: bool,
    pub ma_we: bool,
    pub ram_oe: bool,
    pub ram_we: bool,
    pub alu_carry: bool,
    pub alu_oe: bool,
    pub alu_sel: AluOp,
    pub pc_we: bool,
    pub pc_oe: bool,
    pub ir_we: bool,
    pub ir_oe: bool,
    pub fr_we: bool,
    pub fr_oe: bool,
    pub fr_sel_bus: bool,
}

#[derive(Digital, PartialEq, Debug, Default)]
pub enum State {
    #[default]
    Reset,
    Fetch,
    Fetch1,
    Fecth2,
    Decode,

    IncPC,
    IncPC1,
    Hlt,
}

#[derive(Synchronous, SynchronousDQ, Clone, Debug)]
pub struct ControlUnit {
    state: DFF<State>,
}

impl Default for ControlUnit {
    fn default() -> Self {
        Self {
            state: DFF::new(State::default()),
        }
    }
}

impl SynchronousIO for ControlUnit {
    type I = (Decoded, AluFlags);
    type O = ControlSignals;
    type Kernel = cu_kernel;
}

#[kernel]
pub fn cu_kernel(_cr: ClockReset, _i: (Decoded, AluFlags), q: Q) -> (ControlSignals, D) {
    let mut cs = ControlSignals {
        rf_sel: RA,
        rf_oe: false,
        rf_we: false,
        t1_oe: false,
        t1_we: false,
        t2_oe: false,
        t2_we: false,
        ma_oe: false,
        ma_we: false,
        ram_oe: false,
        ram_we: false,
        alu_carry: false,
        alu_oe: false,
        alu_sel: ADC,
        pc_we: false,
        pc_oe: false,
        ir_we: false,
        ir_oe: false,
        fr_we: false,
        fr_oe: false,
        fr_sel_bus: false,
    };
    let next_state = match q.state {
        State::Reset => Fetch,
        Fetch => Fetch1,
        Fetch1 => Fecth2,
        Fecth2 => Decode,
        Decode => {
            IncPC
        },
        IncPC => {
            cs.pc_oe = true;
            cs.t1_we = true;
            IncPC1
        },
        IncPC1 => {
            cs.alu_carry = true;
            cs.alu_oe = true;
            cs.alu_sel = ADC;
            cs.t1_oe = true;
            cs.pc_we = true;
            Fetch
        }
        Hlt => Hlt,
    };
    (cs, D { state: next_state })
}
