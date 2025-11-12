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
    let (bits, _) = bit_range(<T::I as Timed>::static_kind(), path)?;
    let mut driver = Driver::default();
    driver.input_port(name, bits.len());
    let output = driver.write_to_inner_input(path)?;
    let drive_range: vlog::BitRange = (0..options.pins.len()).into();
    let name_ident = format_ident!("{name}");

    driver.hdl = parse_quote_miette! {
        assign #output = #name_ident;
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