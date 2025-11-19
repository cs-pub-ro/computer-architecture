//! # Arithmetic Logic Unit
//!
//! ## Purpose
//!
//! The [alu] makes possible within the didactic computer
//! to perform arithmetic/logic/shifting operations. It
//! is the only way to make arbitrary operations. A [ControlUnit]
//! **shall** not make any arithmetic operations by itself in order
//! to (almost) fully isolate itself from having information about
//! the memories of the didactic computer. However, it should still
//! have some particular information about its data in order to
//! make decisions, and the [alu] will have this as its second responsibility,
//! notifying the [ControlUnit] through [AluFlags]
//!
//! ## Tricks
//!
//! ### Put T1/T2 on BUS
//! As seen in the diagram above, T1/T2's output is linked only to the [alu],
//! so it is not possible to have a direct path from its output to BUS. A hack
//! to make this possible though consists in enabling only one register, and
//! selecting the [OR] operation. For example, if we do t1_oe=1, alu_opsel=OR,
//!  alu_enable=1, we are doing the operation T1|0, resulting in T1, and puts
//! it on the bus
//!
//! ### Incrementing/Decrementing
//! Enabling the output of only one register, carry_in = 1 and opsel = [ADC]
//! will result in T+0+1. Same can be done with [SBB1]/[SBB2]
//!
//! ### Adding numbers larger than N bit together
//!
// use rhdl::prelude::*;
use crate::prelude::*;

/// Operation perfomred by [alu]. Every operation will output some flags, it is up to the control unit
/// if they will be stored in the ``FR`` or not
#[allow(non_camel_case_types)]
#[derive(Digital, Debug, PartialEq, Default)]
pub enum AluOp {
    #[default]
    /// ADd with Carry. Does not care about signedness. The extra bit resulting from this operation
    /// is stored in carry
    /// ## Result
    /// (T1 + T2 + c)\[N-1..0]
    /// ## Flags
    /// C = (T1 + T2 + c)\[N]
    ///
    /// O = (T1\[N-1] == T2\[N-1]) && (T1\[N-1] != result\[N-1])
    ADC,
    /// SuBtract with Borrow from operand 1. The resulting carry represents if a borrow happened
    /// ## result
    /// (T1 + ~(T2 + c) + 1)\[N-1..0]
    /// ## Flags
    /// C = (T1 + ~(T2 + c) + 1)\[N]
    ///
    /// O = (T1\[N-1] != T2\[N-1]) && (T1\[N-1] != result\[N-1])
    SBB1,
    /// SuBtract with Borrow from operand 2. The resulting carry represents if a borrow happened
    /// ## result
    /// (T2 + ~(T1 + c) + 1)\[N-1..0]
    /// ## Flags
    /// C = (T2 + ~(T1 + c) + 1)\[N]
    ///
    /// O = (T2\[N-1] != T1\[N-1]) && (T2\[N-1] != result\[N-1])
    SBB2,
    /// bitwise NOT. Carry/overflow is irrelevant. Since this is a single operand instruction,
    /// a bitwise or is made between the 2 operands. This assumes only one operand has oe=1
    /// ##result
    /// (T1 | T2)
    /// ## Flags
    /// C = 0
    ///
    /// O = 0
    NOT,
    /// bitwise AND. Carry/overflow is irrelevant
    /// ## result
    /// T1 & T2
    /// ## Flags
    /// C = 0
    ///
    /// O = 0
    ///
    AND,
    /// bitwise OR. Carry/overflow is irrelevant
    /// ## result
    /// T1 | T2
    /// ## Flags
    /// C = 0
    ///
    /// O = 0
    OR,
    /// bitwise XOR. Carry/overflow is irrelevant
    /// ## result
    /// T1 ^ T2
    /// ## Flags
    /// C = 0
    ///
    /// O = 0
    XOR,
    /// SHift Left by 1 bit. Overflow is irrelevant. Carry is the MSB from the original operand.
    /// Since this is a single operand instruction,
    /// a bitwise or is made between the 2 operands. This assumes only one operand has oe=1
    /// ## result
    /// ((T1|T2)\[N-2..0], 0)
    /// ## Flags
    /// C = (T1|T2)\[N-1]
    ///
    /// O = 0
    SHL,
    /// SHift Right by 1 bit. Overflow is irrelevant. Carry is the LSB from the original operand.
    /// Since this is a single operand instruction,
    /// a bitwise or is made between the 2 operands. This assumes only one operand has oe=1
    /// ## result
    /// (0, (T1|T2)\[N-1..1])
    /// ## Flags
    /// C = (T1|T2)\[0]
    ///
    /// O = 0
    SHR,
    /// Shift Arithmetic Right by 1 bit. Overflow is irrelevant. Carry is the LSB from the original operand.
    /// Since this is a single operand instruction,
    /// a bitwise or is made between the 2 operands. This assumes only one operand has oe=1
    /// ## result
    /// ((T1|T2)\[N-1], (T1|T2)\[N-1..1])
    /// ## Flags
    /// C = (T1|T2)\[0]
    ///
    /// O = 0
    SAR,
}

use AluOp::*;
use bitops_rhdl::bitops;

#[derive(Debug, Digital, PartialEq)]
pub struct AluInput<N: BitWidth> {
    pub t1: Bits<N>,
    pub t2: Bits<N>,
    pub carry_in: bool,
    pub opsel: AluOp,
}

#[derive(Debug, Digital, PartialEq)]
pub struct AluFlags {
    pub c: bool,
    pub z: bool,
    pub s: bool,
    pub o: bool,
    pub p: bool,
}

#[bitops]
#[kernel]
pub fn flags(f: Bits<U16>) -> AluFlags {
    AluFlags {
        c: f[0].any(),
        z: f[1].any(),
        s: f[2].any(),
        o: f[3].any(),
        p: f[4].any(),
    }
}

#[kernel]
pub fn fr(f: AluFlags) -> Bits<U16> {
    let c = btb(f.c).resize();
    let z = btb(f.z).resize();
    let s = btb(f.s).resize();
    let o = btb(f.o).resize();
    let p = btb(f.p).resize();
    c | (z << 1) | (s << 2) | (o << 3) | (p << 4)
}

#[derive(Debug, Digital, PartialEq)]
pub struct AluOutput<N: BitWidth> {
    pub res: Bits<N>,
    pub flags: AluFlags,
}

#[kernel]
pub fn btb(o: bool) -> Bits<U1> {
    if o { bits(1) } else { bits(0) }
}

/// Combinational circuit that performs a selected operation between 2 N-bit operands
/// and a potential carry_in. Will provide a result of the operation if enabled, or 0
/// if disabled.
/// Will also provide the status of the operation through [AluFlags]

#[kernel]
pub fn alu<N: BitWidth>(i: AluInput<N>) -> AluOutput<N> {
    let mut out = AluOutput::<N>::dont_care();
    let t1 = i.t1;
    let t2 = i.t2;
    let s1 = t1.as_signed() >= signed(0);
    let s2 = t2.as_signed() >= signed(0);

    let c = btb(i.carry_in).dyn_bits();
    out.flags.c = true; // Defaults to 0 for operations that do not use it
    let sop = t1 | t2; // Used for operations with a single operand

    out.res = match i.opsel {
        ADC => {
            let res = t1.dyn_bits().xadd(t2.dyn_bits()).xadd(c); // N + 2
            out.flags.c = res.xshr::<N>().any();
            res.resize::<N>().as_bits()
        }
        NOT => !sop,
        AND => t1 & t2,
        OR => sop,
        XOR => t1 ^ t2,
        SHR => {
            let sop = sop.dyn_bits().xshl::<U1>() >> 1; // we obtain [(t1|t2) 0] >> 1 == [0, (t1|t2)]
            out.flags.c = sop.resize::<U1>().any();
            (sop >> 1).resize::<N>().as_bits()
        }
        SHL => {
            let sop = sop.dyn_bits().xshl::<U1>();
            out.flags.c = sop.xshr::<N>().any();
            sop.resize::<N>().as_bits()
        }
        SAR => {
            out.flags.c = sop.resize::<U1>().any();
            let sop = sop.dyn_bits().xshl::<U1>(); // we obtain [(t1|t2) 0] >> 1 == [0, (t1|t2)]
            (sop.as_signed() >> 1).as_unsigned().resize::<N>().as_bits()
        }
        SBB1 => {
            let op1 = t1.dyn_bits().xext::<U1>().as_signed();
            let op2 = t2.dyn_bits().xadd(c).as_signed();
            out.flags.c = op1 > op2;
            (op1 - op2).as_unsigned().resize::<N>().as_bits()
        }
        SBB2 => {
            let op1 = t2.dyn_bits().xext::<U1>().as_signed();
            let op2 = t1.dyn_bits().xadd(c).as_signed();
            out.flags.c = op1 > op2;
            (op1 - op2).as_unsigned().resize::<N>().as_bits()
        }
    };
    out.flags.z = !out.res.any();
    out.flags.s = out.res.as_signed() < signed(0);
    out.flags.p = !out.res.xor();
    out.flags.o = match i.opsel {
        ADC => s1 == s2 && s1 != out.flags.s,
        SBB1 => s1 != s2 && s1 != out.flags.s,
        SBB2 => s2 != s1 && s2 != out.flags.s,
        _ => false,
    };

    out
}

// mod tests {
//     use crate::prelude::*;
//     #[doc(hidden)]
//     #[kernel]
//     /// A wrapper over alu kernel to make it simulatable into a testbench using a Func
//     fn alu_uut<N: BitWidth>(_cr: ClockReset, i: AluInput<N>) -> AluOutput<N> {
//         alu::<N>(i)
//     }

//     type AluUut<N: BitWidth> = Func<AluInput<N>, AluOutput<N>>;

//     fn new<N: BitWidth>() -> Result<AluUut<N>, RHDLError> {
//         Func::try_new::<alu_uut<N>>()
//     }

// }
