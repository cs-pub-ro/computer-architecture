use rhdl::prelude::*;

#[kernel]
pub fn not_gate(_cr: ClockReset, i: Bits<U1>) -> Bits<U1> {
    !i
}

#[kernel]
pub fn or_gate(_cr: ClockReset, i: (Bits<U1>, Bits<U1>)) -> Bits<U1> {
    i.1 | i.0
}

#[kernel]
pub fn and_gate(_cr: ClockReset, _i: (Bits<U1>, Bits<U1>)) -> Bits<U1> {
    Bits::<U1>::default() // TODO add an and gate
}

#[kernel]
pub fn xor_gate(_cr: ClockReset, _i: (Bits<U1>, Bits<U1>)) -> Bits<U1> {
    Bits::<U1>::default() // TODO add an xor gate
}


