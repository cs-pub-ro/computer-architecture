use std::fmt::Display;

use crate::{
    decode_unit::{Decoded, Jcond, decode},
    prelude::*,
};
#[allow(non_camel_case_types)]
#[derive(Debug, Digital, Default, PartialEq)]
pub enum Reg {
    #[default]
    RA,
    RB,
    RC,
    SP,
    XA,
    XB,
    BA,
    BB,
}

impl Display for Reg {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", match self {
            RA => "RA",
            RB => "RB",
            RC => "RC",
            SP => "SP",
            XA => "XA",
            XB => "XB",
            BA => "BA",
            BB => "BB",
        })
    }
}

#[kernel]
pub fn reg(i: Bits<U3>) -> Reg {
    match i.raw() {
        0 => RA,
        1 => RB,
        2 => RC,
        3 => SP,
        4 => XA,
        5 => XB,
        6 => BA,
        7 => BB,
        _ => RA, // Never reached
    }
}

#[kernel]
pub fn rtb(i: Reg) -> Bits<U3> {
    bits(match i {
        RA => 0,
        RB => 1,
        RC => 2,
        SP => 3,
        XA => 4,
        XB => 5,
        BA => 6,
        BB => 7,
    })
}

#[derive(Debug, Synchronous, SynchronousDQ, Clone)]
pub struct RegFile<N: BitWidth + Unsigned> {
    rg: [DFF<Bits<N>>; 8],
}

impl<N: BitWidth + Unsigned> Default for RegFile<N> {
    fn default() -> Self {
        Self {
            rg: core::array::from_fn(|_| DFF::new(Bits::default())),
        }
    }
}

impl<N: BitWidth + Unsigned> SynchronousIO for RegFile<N> {
    type I = (RegisterInput<N>, Reg);
    type O = Bits<N>;
    type Kernel = reg_file<N>;
}

#[kernel]
pub fn reg_file<N: BitWidth + Unsigned>(
    _cr: ClockReset,
    i: (RegisterInput<N>, Reg),
    q: Q<N>,
) -> (Bits<N>, D<N>) {
    let mut d = D::<N>::dont_care();
    d.rg = q.rg;
    // IndexMut is implemented for arrays only when Bits<N> is wrapped in a signal
    // let index: Signal<Bits<U3>, Red> = signal(rtb(i.1)); // Works but generates combinatorial loop
    // if i.0.we {
    //     d.rg[index] = i.0.data_in;
    // };
    // (
    //     if i.0.oe && !i.0.we {
    //         d.rg[index]
    //     } else {
    //         bits(0)
    //     },
    //     d,
    // )
    let out = if i.0.oe && !i.0.we {
        match i.1 {
            RA => q.rg[0],
            RB => q.rg[1],
            RC => q.rg[2],
            SP => q.rg[3],
            XA => q.rg[4],
            XB => q.rg[5],
            BA => q.rg[6],
            BB => q.rg[7]
        }
    } else {bits(0)};

    if i.0.we {
        match i.1 {
            RA => {
                d.rg[0] = i.0.data_in;
            }
            RB => {
                d.rg[1] = i.0.data_in;
            }
            RC => {
                d.rg[2] = i.0.data_in;
            }
            SP => {
                d.rg[3] = i.0.data_in;
            }
            XA => {
                d.rg[4] = i.0.data_in;
            }
            XB => {
                d.rg[5] = i.0.data_in;
            }
            BA => {
                d.rg[6] = i.0.data_in;
            }
            BB => {
                d.rg[7] = i.0.data_in;
            }
        }
    };
    (out, d)
}
