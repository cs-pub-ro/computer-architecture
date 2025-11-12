//! ######################################################
//! ##                   Nexys A7 XDC                   ##
//! ##                 xc7a100t-1csg324                 ##
//! ######################################################

use std::ops::Range;

use rhdl_bsp::{bga_pin, constraints::Location};

pub const SWITCHES: [Location; 16] = [
    bga_pin!(J,15),
    // TODO
];

pub const LEDS: [Location; 16] = [
    bga_pin!(H,17),
    // TODO
];

pub const SSG_DIGITS: [Location; 8] = [
    bga_pin!(T,10), // #IO_L24N_T3_A00_D16_14 Sch=ca
    bga_pin!(R,10), // #IO_25_14 Sch=cb
    bga_pin!(K,16), // #IO_25_15 Sch=cc
    bga_pin!(K,13), // #IO_L17P_T2_A26_15 Sch=cd
    bga_pin!(P,15), // #IO_L13P_T2_MRCC_14 Sch=ce
    bga_pin!(T,11), // #IO_L19P_T3_A10_D26_14 Sch=cf
    bga_pin!(L,18), // #IO_L4P_T0_D04_14 Sch=cg
    bga_pin!(H,15), // #IO_L19N_T3_A21_VREF_15 Sch=dp
];

pub const SSG_SELECT: [Location; 8] = [
    bga_pin!(J,17), // #IO_L23P_T3_FOE_B_15 Sch=an[0]
    bga_pin!(J,18), // #IO_L23N_T3_FWE_B_15 Sch=an[1]
    bga_pin!(T,9),  // #IO_L24P_T3_A01_D17_14 Sch=an[2]
    bga_pin!(J,14), // #IO_L19P_T3_A22_15 Sch=an[3]
    bga_pin!(P,14), // #IO_L8N_T1_D12_14 Sch=an[4]
    bga_pin!(T,14), // #IO_L14P_T2_SRCC_14 Sch=an[5]
    bga_pin!(K,2),  // #IO_L23P_T3_35 Sch=an[6]
    bga_pin!(U,13), // #IO_L23N_T3_A02_D18_14 Sch=an[7]
];

pub fn lvcmos33_in(row: &[Location], r: Range<usize>) -> crate::drivers::input::Options {
    if r.end >= row.len() {
        panic!("Range {:?} has end bigger than {:?}", r, row.len());
    }

    crate::drivers::input::Options {
        io_standard: rhdl_bsp::constraints::IOStandard::LowVoltageCMOS_3v3,
        pins: row[r].to_vec()
    }
}

pub fn lvcmos33_out(row: &[Location], r: Range<usize>) -> crate::drivers::output::Options {
    if r.end >= row.len() {
        panic!("Range {:?} has end bigger than {:?}", r, row.len());
    }

    crate::drivers::output::Options {
        io_standard: rhdl_bsp::constraints::IOStandard::LowVoltageCMOS_3v3,
        pins: row[r].to_vec()
    }
}
