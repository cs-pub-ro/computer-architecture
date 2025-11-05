use rhdl::prelude::*;
use rhdl_fpga::core::dff::*;

//  register file
#[derive(Debug, PartialEq, Eq, Digital, Default)]
#[allow(unused)]
pub enum Sel {
    #[default]
    RA,
    RB,
    RC,
    IS,
    XA,
    XB,
    BA,
    BB,
}

#[derive(Digital, PartialEq, Eq)]
pub struct RegisterFileInput {
    pub oe: Bits<U1>,
    pub we: Bits<U1>,
    pub data_in: Bits<U16>,
    pub sel: Sel,
}

#[derive(Synchronous, SynchronousDQ, Clone, Debug)]
pub struct RegisterFile {
    pub registers: [DFF<Bits<U16>>; 8],
}

impl Default for RegisterFile {
    fn default() -> Self {
        Self {
            registers: core::array::from_fn(|_| DFF::new(Bits::<U16>::default())),
        }
    }
}

impl SynchronousIO for RegisterFile {
    type I = RegisterFileInput;
    type O = Bits<U16>;
    type Kernel = register_file_kernel;
}
use Sel::*;

use crate::doc::write_svg;

#[kernel]
pub fn register_file_kernel(_cr: ClockReset, i: RegisterFileInput, _q: Q) -> (Bits<U16>, D) {
    match i.sel {
        _ => ()
    }

    (bits(0), D { registers: [bits(0); 8]})
}

pub fn sim_reg_file() -> Result<(), RHDLError> {
    let reg_file = RegisterFile::default();

    let input = vec![
        RegisterFileInput {
            oe: bits(0),
            we: bits(1),
            data_in: bits(15),
            sel: RA,
        },
        RegisterFileInput {
            oe: bits(1),
            we: bits(0),
            data_in: bits(15),
            sel: RA,
        },
        RegisterFileInput {
            oe: bits(0),
            we: bits(0),
            data_in: bits(0),
            sel: RA,
        },
    ];

    let input_data = input.into_iter().with_reset(1).clock_pos_edge(100);
    let vcd = reg_file.run(input_data)?.collect::<Vcd>();

    let _ = write_svg(vcd, "reg_file.svg");
    // vcd.dump_to_file("ram.vcd")?;

    Ok(())
}
