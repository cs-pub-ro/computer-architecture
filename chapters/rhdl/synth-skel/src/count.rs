
use nexys_a7::{drivers::{input, output, sys_clk}, options::{LEDS, SSG_DIGITS, SSG_SELECT, SWITCHES, lvcmos33_in, lvcmos33_out}};
use rhdl::{core::circuit::async_func::AsyncFunc, prelude::*};
use rhdl_fpga::core::{counter::Counter, dff::DFF};

use crate::{ssg::Ssg, util::synth_flash};

#[derive(Debug, Synchronous, SynchronousDQ, Clone, PartialEq)]
struct Count {
    // TODO
}

#[derive(Debug, Digital, PartialEq)]
struct SSGControl {
    digit: Bits<U7>,
    sel: Bits<U4>,
}

impl SynchronousIO for Count {
    type I = ();
    type O = SSGControl;
    type Kernel = counter;
}


impl Default for Count {
    fn default() -> Self {
        Self { // TODO }
    }
}

#[kernel]
fn counter(_cr: ClockReset, _i: (), q: Q) -> (SSGControl, D) {
    let mut d = D::dont_care();
    let mut o = SSGControl::dont_care();

    (o, d)
}





pub fn count_synth_main() -> Result<(), RHDLError>{
    type T = Adapter<Count, Red>;
    let ssg_fix:T = Adapter::new(Count::default());
    let mut fixture = Fixture::new("counter_ssg", ssg_fix);
    fixture.add_driver(output::build("dig",
    &path!(.val().digit),
    &lvcmos33_out(&SSG_DIGITS, 0..7)
    )?);
    fixture.add_driver(output::build("sel",
    &path!(.val().sel),
    &lvcmos33_out(&SSG_SELECT, 0..4)
    )?);
    fixture.add_driver(sys_clk::sys_clock(&path!(.clock_reset.val().clock))?);
    fixture.constant_input(false, &path!(.clock_reset.val().reset))?;
    synth_flash("counter_ssg", fixture, true)
}
