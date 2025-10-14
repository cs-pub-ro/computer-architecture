use rhdl::prelude::*;

use crate::{adders::sim_adder_4bit};
mod helper;
mod adders;
mod seven_segment;
mod comparator;
pub fn main() -> Result<(), RHDLError> {
    sim_adder_4bit()?;
    Ok(())
}