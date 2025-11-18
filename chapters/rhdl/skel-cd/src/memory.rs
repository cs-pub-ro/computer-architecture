use std::collections::BTreeMap;

use crate::prelude::*;
use rhdl_fpga::core::{dff::DFF, ram::synchronous::*};

// ram
#[derive(Digital, PartialEq, Eq)]
pub struct RamInput {
    pub oe: bool,
    pub we: bool,
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

impl Ram {
    pub fn from_hex_file(filename: &str) -> std::io::Result<Self> {
        let file = std::fs::read_to_string(filename)?;
        let mut bram = SyncBRAM::new(
            file.lines()
                .map(|x| x.split_once("//").map(|x| x.0).unwrap_or(x))
                .flat_map(|x| x.split(" "))
                .filter_map(|x| u128::from_str_radix(x.trim(), 16).ok())
                .enumerate()
                .map(|(i, v)| (Bits::from(i as u128), Bits::from(v))),
        );
        Ok(Self { memory: bram })
    }
}

impl SynchronousIO for Ram {
    type I = RamInput;
    type O = Bits<U16>;
    type Kernel = ram_kernel;
}

#[kernel]
pub fn ram_kernel(_cr: ClockReset, _i: RamInput, mut _q: Q) -> (Bits<U16>, D) {
    let mut d = D::dont_care();
    d.memory.read_addr = _i.address;
    d.memory.write = Write::<Bits<U16>, U10> {
        addr: _i.address,
        value: _i.data_in,
        enable: _i.we,
    };
    (if _i.oe && !_i.we { _q.memory } else { bits(0) }, d)
}

pub fn get_ram_vec(s: &<Ram as Synchronous>::S) -> Vec<u128> {
    let contents = s.1.borrow().clone().contents;
    let mut state = [0; 1024];
    for x in contents.into_iter() {
        state[x.0.raw() as usize] = x.1.raw();
    }
    state.to_vec()
}

pub fn sim_ram() -> Result<(), RHDLError> {
    let ram = Ram::from_hex_file("cram.data").unwrap();
    let mut s = ram.init();
    let vals = get_ram_vec(&s);
    // println!("{}", vals[69]);
    let x = step(
        &ram,
        RamInput {
            oe: true,
            we: false,
            data_in: b16(32),
            address: b10(0),
        },
        &mut s,
    );
    println!("{}", x.raw());
    let x = step(
        &ram,
        RamInput {
            oe: false,
            we: false,
            data_in: b16(32),
            address: b10(1),
        },
        &mut s,
    );
    println!("{}", x.raw());
    let x = step(
        &ram,
        RamInput {
            oe: false,
            we: true,
            data_in: b16(32),
            address: b10(0),
        },
        &mut s,
    );
    println!("{}", x.raw());
    let x = step(
        &ram,
        RamInput {
            oe: true,
            we: false,
            data_in: b16(32),
            address: b10(0),
        },
        &mut s,
    );
    let vals = get_ram_vec(&s);

    println!("{} {}", x.raw(), vals[0]);
    let x = step(
        &ram,
        RamInput {
            oe: true,
            we: false,
            data_in: b16(32),
            address: b10(0),
        },
        &mut s,
    );
    println!("{}", x.raw());

    Ok(())
}
