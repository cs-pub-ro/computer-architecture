
use nexys_a7::{drivers::{input, output}, options::{LEDS, SWITCHES, lvcmos33_in, lvcmos33_out}};
use rhdl::prelude::*;

use crate::util::synth_flash;

#[derive(Debug, Synchronous, Clone, PartialEq)]
pub struct Ssg {}

impl SynchronousIO for Ssg {
    type I = Bits<U4>;
    type O = Bits<U7>;
    type Kernel = ssg;
}

impl SynchronousDQ for Ssg {
    type D = ();
    type Q = ();
}

impl Default for Ssg {
    fn default() -> Self {
        Self {  }
    }
}

#[kernel]
pub fn ssg(_cr: ClockReset, i: Bits<U4>, _q: ()) -> (Bits<U7>, ()) {
    (match i.raw() {
        // TODO
        _ => bits(0b1111111)
    }, ())
}





pub fn ssg_synth_main() -> Result<(), RHDLError>{
    type T = Adapter<Ssg, Red>;
    let ssg_fix:T = Adapter::new(Ssg::default());
    let mut fixture = Fixture::new("ssg", ssg_fix);
    fixture.add_driver(input::build("sw",
    &path!(.input.val()),
    &lvcmos33_in(&SWITCHES, 0..4)
    )?);
    fixture.add_driver(output::build("led",
    &path!(.val()),
    &lvcmos33_out(&LEDS, 0..8)
    )?);
    fixture.constant_input(ClockReset::default(), &path!(.clock_reset.val()))?;
    synth_flash("ssg", fixture, false)
}
