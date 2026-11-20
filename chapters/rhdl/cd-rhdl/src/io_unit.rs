//! Generic io sram module.
//! WIP
use crate::prelude::*;

#[derive(Digital, PartialEq, Eq)]
pub struct IOSignals {
    pub ioa_we: bool,
    pub ioa_oe: bool,
    pub io_oe: bool,
    pub io_we: bool,
}

