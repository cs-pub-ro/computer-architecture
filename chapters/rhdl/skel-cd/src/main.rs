use crate::{memory::sim_ram, prelude::*};
mod alu;
mod control_unit;
mod cpu;
mod decode_unit;
mod memory;
mod prelude;
mod register;
mod register_file;

fn main() {
    // let reg = RegFile::<U16>::default();
    // let mut s = reg.init();
    // println!("{}",s.0.binary_string());
    // let _ = reg.sim(ClockReset { clock: clock(true), reset: reset(false) }, (RegInput::<U16> { data_in: Bits::from(69), oe: false, we: true }, RA), &mut s);
    // println!("{}",s.0.binary_string());

    // let _ = reg.sim(ClockReset { clock: clock(false), reset: reset(false) }, (RegInput::<U16> { data_in: Bits::from(69), oe: false, we: true }, RA), &mut s);
    // let _ = reg.sim(ClockReset { clock: clock(true), reset: reset(false) }, (RegInput::<U16> { data_in: Bits::from(69), oe: false, we: false }, RA), &mut s);
    // println!("{}",s.0.);
    // let x: Vec<(RegInput<U16>,Reg)> = Vec::new();
    // let x = x.with_reset(1).clock_pos_edge(100);
    if let Err(e) = sim_top() {
        println!("{}", miette_report(e));
    }
}
