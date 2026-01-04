use crate::{control_unit::ControlSignals, decode_unit::Decoded, prelude::*};

#[derive(Digital, PartialEq, Debug, Default)]
pub enum GradedState {
    #[default]
    Reset,
    Fetch,
    Decode,
    Load,
    Execute,
    Store,
    IncPC,
    Hlt,
}

#[kernel]
pub fn decoded_control_unit(
    _d: Decoded,
    _f: AluFlags,
    s: GradedState,
) -> (GradedState, ControlSignals) {
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
        ioa_we: false,
        ioa_oe: false,
        io_we: false,
        io_oe: false,
        fetch_done: false,
        instr_done: false,
        exec_done: false,
        load_done: false,
        store_done: false,
    };
    let next_state = match s {
        GradedState::Reset => GradedState::Fetch,
        GradedState::Fetch => GradedState::Decode,
        GradedState::Decode => GradedState::Load,
        GradedState::Load => GradedState::Execute,
        GradedState::Execute => GradedState::Store,
        GradedState::Store => GradedState::IncPC,
        GradedState::IncPC => GradedState::Fetch,
        GradedState::Hlt => GradedState::Hlt,
    };
    (next_state, cs)
}
