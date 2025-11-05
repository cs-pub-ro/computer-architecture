use rhdl::prelude::*;
mod alu;
mod control_unit;
mod doc;
mod ram;
mod register;
mod register_file;
mod top;

use crate::{ram::sim_ram, register::sim_reg, register_file::sim_reg_file, top::sim_top};

fn main() -> Result<(), RHDLError> {
    sim_ram()?;
    sim_reg_file()?;
    sim_reg()?;
    sim_top()?;
    Ok(())
}
