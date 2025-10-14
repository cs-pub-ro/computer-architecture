use rhdl::prelude::*;
use crate::helper::{and_gate, xor_gate, or_gate};

#[derive(Digital, Debug, PartialEq, Eq)]
pub struct HAInput {
    a: Bits<U1>,
    b: Bits<U1>
}

#[derive(Digital, Debug, PartialEq, Eq)]
pub struct AOutput {
    o: Bits<U1>,
    c_o: Bits<U1>
}


#[kernel]
pub fn half_adder(_cr: ClockReset, i: HAInput) -> AOutput {
    AOutput { o: xor_gate(_cr, (i.a, i.b)), c_o: and_gate(_cr, (i.a, i.b)) }
}

#[derive(Digital, Debug, PartialEq, Eq)]
pub struct FAInput {
    a: Bits<U1>,
    b: Bits<U1>,
    c_i: Bits<U1>
}

#[kernel]
pub fn full_adder(_cr: ClockReset, _i: FAInput) -> AOutput {
    // TODO make a full adder
    AOutput { o: bits(0), c_o: bits(0) }
}

fn num_to_bits_tup4(x: u128) -> (Bits<U1>, Bits<U1>, Bits<U1>, Bits<U1>) {
    (
        Bits::<U1>::from(x & 1),
        Bits::<U1>::from((x >> 1) & 1),
        Bits::<U1>::from((x >> 2) & 1),
        Bits::<U1>::from((x >> 3) & 1),
    )
}

#[kernel]
pub fn adder_4bit(_cr: ClockReset, i: (
    (Bits<U1>,Bits<U1>,Bits<U1>,Bits<U1>),
    (Bits<U1>,Bits<U1>,Bits<U1>,Bits<U1>)
)) -> (Bits<U1>,Bits<U1>,Bits<U1>,Bits<U1>,Bits<U1>) {
    // TODO Ripple carry
    (bits(0),bits(0),bits(0),bits(0),bits(0))
}

type Adder4 = Func<(
    (Bits<U1>,Bits<U1>,Bits<U1>,Bits<U1>),
    (Bits<U1>,Bits<U1>,Bits<U1>,Bits<U1>)
), (Bits<U1>,Bits<U1>,Bits<U1>,Bits<U1>, Bits<U1>)>;

pub fn new() -> Result<Adder4, RHDLError> {
    Func::try_new::<adder_4bit>()
}
pub fn sim_adder_4bit() -> Result<(), RHDLError> {
    let adder4 = new()?;
    let test_data = vec![
        (0,  (num_to_bits_tup4(0),  num_to_bits_tup4(0))),
        (10, (num_to_bits_tup4(1),  num_to_bits_tup4(15))), 
        (20, (num_to_bits_tup4(7),  num_to_bits_tup4(8))),   
        (30, (num_to_bits_tup4(9),  num_to_bits_tup4(7))),   
        (40, (num_to_bits_tup4(15), num_to_bits_tup4(15))),  
        (50, (num_to_bits_tup4(10), num_to_bits_tup4(5))),   
    ];

     let input = test_data.into_iter()
        .map(|(time, (a, b))| TimedSample {
            time,
            value: (ClockReset::default(), (a, b)), 
        });
    let vcd = adder4.run(input)?.collect::<Vcd>();
    vcd.dump_to_file("adder4.vcd")?;
    Ok(())
}
