use quote::{format_ident, quote};
use rhdl::prelude::*;

use rhdl_bsp::constraints::{IOStandard, Location};

#[derive(Clone, Debug)]
pub struct Options {
    pub io_standard: IOStandard,
    pub pins: Vec<Location>,
}

pub fn build<T: CircuitIO>(
    name: &str,
    path: &Path,
    options: &Options,
) -> Result<Driver<T>, RHDLError> {
    let (bits, _) = bit_range(<T::O as Timed>::static_kind(), path)?;
    let mut driver = Driver::default();
    driver.output_port(name, bits.len());
    let output = driver.read_from_inner_output(path)?;
    let drive_range: vlog::BitRange = (0..options.pins.len()).into();
    let name_ident = format_ident!("{name}");

    driver.hdl = parse_quote_miette! {
        assign #name_ident = #output;
    }?;
    driver.constraints = options
        .pins
        .iter()
        .enumerate()
        .map(|(index, location)| {
            let pin = location.to_string();
            format!(
                r#"set_property -dict {{ PACKAGE_PIN {}     IOSTANDARD {} }} [get_ports {{ {}[{}] }}]
"#,
                pin, options.io_standard, name, index,
            )
        })
        .collect();
    Ok(driver)
}