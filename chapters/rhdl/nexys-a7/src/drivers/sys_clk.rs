use crate::drivers::input;
use rhdl_bsp::{bga_pin, drivers::get_clock_input, constraints::IOStandard};
use rhdl::prelude::*;
// Create a driver that provides the sys clock (100 MHz)
// You must connect it to an input that expects a Signal<Clock, D> input
pub fn sys_clock<T: CircuitIO>(path: &Path) -> Result<Driver<T>, RHDLError> {
    let _ = get_clock_input::<T>(path)?;
    let mut driver = input::build::<T>(
        "sysclk",
        path,
        &input::Options {
            io_standard: IOStandard::LowVoltageCMOS_3v3,
            pins: vec![bga_pin!(E,3)]
        },
    )?;
    driver.constraints += "create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports sysclk]\n";
    Ok(driver)
}