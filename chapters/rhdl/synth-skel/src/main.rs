
use std::os::unix::ffi::OsStrExt;

use camino::Utf8PathBuf;
use nexys_a7::{drivers::{input, output}, tcl::FlashBitstream};
use rhdl::{core::circuit::async_func::AsyncFunc, prelude::*};
use rhdl_bsp::{bga_pin, builders::vivado::tcl::{GenerateBitstream, UpdateCompileOrder}};

#[kernel]
fn ssg(i: Signal<Bits<U4>, Red>) -> Signal<Bits<U7>, Red> {
    signal(match i.val().raw() {
        0 => bits(0b0000000),
        1 => bits(0b0000001),
        2 => bits(0b0000010),
        3 => bits(0b0000011),
        4 => bits(0b0000100),
        5 => bits(0b0000101),
        _ => bits(0)
    })
}


fn main() -> Result<(), RHDLError>{
    let ssg_fix = AsyncFunc::new::<ssg>()?;
    let mut fixture = Fixture::new("ssg", ssg_fix);
    fixture.add_driver(input::build("sw",
    &path!(.val()),
    &input::Options {
        io_standard: rhdl_bsp::constraints::IOStandard::LowVoltageCMOS_3v3,
        pins: vec![
            bga_pin!(J,15),
            bga_pin!(L,16),
            bga_pin!(M,13),
            bga_pin!(R,15),
        ]
    }
    )?);
    fixture.add_driver(output::build("led",
    &path!(.val()),
    &output::Options {
        io_standard: rhdl_bsp::constraints::IOStandard::LowVoltageCMOS_3v3,
        pins: vec![
            bga_pin!(H,17),
            bga_pin!(K,15),
            bga_pin!(J,13),
            bga_pin!(N,14),
            bga_pin!(R,18),
            bga_pin!(V,17),
            bga_pin!(U,17),
        ]
    }
    )?);
    let root = std::env::current_dir().unwrap();
    let root = root.as_os_str().to_str().unwrap();
    let path = Utf8PathBuf::from(root);
    let path = path.join("xc7a100t").join("counter");
    let builder = rhdl_bsp::builders::vivado::builder::Builder::new(
        path.as_str(),
        "ssg",
        "xc7a100t-1csg324",
    )?;
    let builder = builder.add_fixture(fixture)?;
    let builder = builder.step(UpdateCompileOrder).step(GenerateBitstream {
        compressed_bitstream: true,
        bit_file: path.join("ssg.bit"),
    })
    .step(FlashBitstream {
        bit_file: path.join("ssg.bit"),
    });
    builder.build().unwrap();
    Ok(())
}
