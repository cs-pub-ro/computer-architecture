use rhdl::prelude::*;
use rhdl_fpga::core::dff::*;

//  register
#[derive(Digital, PartialEq, Eq)]
pub struct RegisterInput {
    pub oe: Bits<U1>,
    pub we: Bits<U1>,
    pub data_in: Bits<U16>,
}

#[derive(Synchronous, SynchronousDQ, Clone, Debug)]
pub struct Register {
    pub memory: DFF<Bits<U16>>,
}

impl Default for Register {
    fn default() -> Self {
        Self {
            memory: DFF::new(Bits::<U16>::default()),
        }
    }
}

impl SynchronousIO for Register {
    type I = RegisterInput;
    type O = Bits<U16>;
    type Kernel = register_kernel;
}

#[kernel]
pub fn register_kernel(_cr: ClockReset, _i: RegisterInput, _q: Q) -> (Bits<U16>, D) {
    (bits(0), D { memory: bits(0)})

}

use crate::doc::write_svg;

pub fn sim_reg() -> Result<(), RHDLError> {
    let reg = Register::default();

    let input = vec![
        RegisterInput {
            oe: bits(0),
            we: bits(1),
            data_in: bits(15),
        },
        RegisterInput {
            oe: bits(1),
            we: bits(0),
            data_in: bits(15),
        },
        RegisterInput {
            oe: bits(0),
            we: bits(0),
            data_in: bits(15),
        },
    ];

    let input_data = input.into_iter().with_reset(1).clock_pos_edge(100);
    let vcd = reg.run(input_data)?.collect::<Vcd>();

    let _ = write_svg(vcd, "reg.svg");
    // vcd.dump_to_file("ram.vcd")?;

    Ok(())
}
