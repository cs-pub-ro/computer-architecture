// Simple LED counter for an Nexys A7....

// The counter itself is a simple synchronous counter
// with a bit selecting output.

use camino::Utf8PathBuf;
use nexys_a7::tcl::FlashBitstream;
use rhdl::prelude::*;
use rhdl_bsp::builders::vivado::tcl::{GenerateBitstream, UpdateCompileOrder};
use rhdl_bsp::{bga_pin, constraints::IOStandard};
use nexys_a7::options::*;

mod blinker {
    use super::*;

    #[derive(Clone, Synchronous, SynchronousDQ, Default)]
    pub struct U {
        // We need a 32 bit counter.
        counter: rhdl_fpga::core::counter::Counter<U32>,
    }

    impl SynchronousIO for U {
        type I = ();
        type O = b8; // Needed to drive all 8 LEDs
        type Kernel = blinker;
    }

    #[kernel]
    pub fn blinker(_cr: ClockReset, _i: (), q: Q) -> (b8, D) {
        let mut d = D::dont_care();
        // The counter is always enabled.
        d.counter = true;
        let output_bit = (q.counter >> 28) & 1 != 0;
        let o = if output_bit { bits(0xaa) } else { bits(0x55) };
        (o, d)
    }
}

#[test]
fn test_blinker_fixture() -> Result<(), RHDLError> {
    type T = Adapter<blinker::U, Red>;
    let blinker: T = Adapter::new(blinker::U::default());
    //    let inp: <T as CircuitIO>::I;
    //inp.clock_reset.val().clock
    let mut fixture = Fixture::new("top", blinker);
    fixture.add_driver(nexys_a7::drivers::sys_clk::sys_clock(
        &path!(.clock_reset.val().clock),
    )?);
    fixture.constant_input(reset(false), &path!(.clock_reset.val().reset))?;
    fixture.add_driver(nexys_a7::drivers::output::build(
        "rst",
        &path!(.val()),
        &lvcmos33_out(&LEDS, 0..8)
    )?);
    let root = env!("CARGO_TARGET_TMPDIR").rsplit_once("/").unwrap().1;
    let path = Utf8PathBuf::from(root);
    let path = path.join("ok").join("xc7a100t").join("counter");
    let builder = rhdl_bsp::builders::vivado::builder::Builder::new(
        path.as_str(),
        "counter",
        "xc7a100t-1csg324",
    )?;
    let builder = builder.add_fixture(fixture)?;
    let builder = builder.step(UpdateCompileOrder).step(GenerateBitstream {
        compressed_bitstream: true,
        bit_file: path.join("counter.bit"),
    })
    .step(FlashBitstream {
        bit_file: path.join("counter.bit"),
    });
    builder.build().unwrap();
    Ok(())
}
