use camino::Utf8PathBuf;
use nexys_a7::tcl::FlashBitstream;
use rhdl::prelude::*;
use rhdl_bsp::builders::vivado::tcl::{GenerateBitstream, UpdateCompileOrder};



pub fn synth_flash<T: Circuit>(name: &str, fixture: Fixture<T>, flash: bool) -> Result<(), RHDLError> {
    let path = Utf8PathBuf::from_os_string(std::env::current_dir().unwrap().as_os_str().into()).unwrap();
    // let path = Utf8PathBuf::from("."); // Use this if using a separate dockerfile for vivado
    let path = path.join("xc7a100t").join(name);
    let builder = rhdl_bsp::builders::vivado::builder::Builder::new(
        path.as_str(),
        name,
        "xc7a100t-1csg324",
    )?;
    let builder = builder.add_fixture(fixture)?;
    let builder = builder.step(UpdateCompileOrder).step(GenerateBitstream {
        compressed_bitstream: true,
        bit_file: path.join(&format!("{}.bit", name)),
    });
    let builder = if flash {
        builder.step(FlashBitstream {
            bit_file: path.join(&format!("{}.bit", name)),
        })
    } else {builder};
    builder.build().unwrap();
    Ok(())
}
