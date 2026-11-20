pub use crate::alu::{
    AluFlags, AluInput,
    AluOp::{self, *},
    AluOutput,
};
pub use crate::control_unit::{State::*};
pub use crate::decode_unit::*;
pub use crate::cpu::*;
pub use crate::memory::*;
pub use crate::register::*;
pub use crate::register_file::Reg::{self, *};
pub use crate::register_file::RegFile;
pub use rhdl::prelude::*;
pub use rhdl_fpga::core::dff::DFF;
pub use crate::cpu::cpu_test::*;
pub use crate::io_unit::IOSignals;
pub fn miette_report(err: RHDLError) -> String {
    let handler =
        miette::GraphicalReportHandler::new_themed(miette::GraphicalTheme::unicode_nocolor());
    let mut msg = String::new();
    handler.render_report(&mut msg, &err).unwrap();
    msg
}

pub fn step<S: Synchronous + SynchronousIO>(s: &S, input: S::I, state: &mut S::S) -> S::O {
    s.sim(
        ClockReset {
            clock: clock(true),
            reset: reset(false),
        },
        input,
        state,
    );
    s.sim(
        ClockReset {
            clock: clock(false),
            reset: reset(false),
        },
        input,
        state,
    )
}

pub fn reset_step<S: Synchronous + SynchronousIO>(s: &S, state: &mut S::S) {
    s.sim(
        ClockReset {
            clock: clock(false),
            reset: reset(true),
        },
        S::I::dont_care(),
        state,
    );
    s.sim(
        ClockReset {
            clock: clock(false),
            reset: reset(true),
        },
        S::I::dont_care(),
        state,
    );
}
