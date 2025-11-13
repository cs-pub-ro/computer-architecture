use rhdl::prelude::*;
use rhdl_fpga::core::ram::synchronous::*;

use crate::doc::write_svg;
// ram
#[derive(Digital, PartialEq, Eq)]
pub struct RamImput {
    pub oe: Bits<U1>,
    pub we: Bits<U1>,
    pub data_in: Bits<U16>,
    pub address: Bits<U10>,
}

#[derive(Synchronous, SynchronousDQ, Clone, Debug)]
pub struct Ram {
    pub memory: SyncBRAM<Bits<U16>, U10>,
}

impl Default for Ram {
    fn default() -> Self {
        Self {
            memory: SyncBRAM::default(),
        }
    }
}

impl SynchronousIO for Ram {
    type I = RamImput;
    type O = Bits<U16>;
    type Kernel = ram_kernel;
}

#[kernel]
pub fn ram_kernel(_cr: ClockReset, _i: RamImput, mut _q: Q) -> (Bits<U16>, D) {
    let mut d = D::dont_care();
    
    (bits(0), d)
}

pub fn sim_ram() -> Result<(), RHDLError> {
    let ram = Ram::default();

    let input = vec![
        RamImput {
            oe: bits(0),
            we: bits(1),
            data_in: bits(5),
            address: bits(0),
        },
        RamImput {
            oe: bits(1),
            we: bits(0),
            data_in: bits(7),
            address: bits(0),
        },
        // TODO stud: add more test data
        RamImput {
            oe: bits(0),
            we: bits(0),
            data_in: bits(0),
            address: bits(0),
        },
    ];

    let input_data = input.into_iter().with_reset(1).clock_pos_edge(100);
    let vcd = ram.run(input_data)?.collect::<Vcd>();

    let _ = write_svg(vcd, "ram.svg");
    // vcd.dump_to_file("ram.vcd")?;

    Ok(())
}
