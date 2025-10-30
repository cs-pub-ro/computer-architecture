use std::ops::{Add, Sub};

use rhdl::{prelude::*, typenum::Diff};
use std::path::PathBuf;

#[doc(hidden)]
/// Useful for testing, but otherwise, probably not for end users
pub fn write_svg_as_markdown(vcd: Vcd, name: &str, options: SvgOptions) -> anyhow::Result<()> {
    let path = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let path = path.join("doc");
    std::fs::create_dir_all(&path)?;
    let path = path.join(name);
    std::fs::write(path, format!("\n\n<p>\n{}\n</p>", vcd.dump_svg(&options)))?;
    Ok(())
}
// use rhdl_fpga::
#[derive(Debug,Digital,PartialEq, Eq,Default)]
pub enum AluOpcode {
    #[default]
    Adc,
    Sbb1,
    Sbb2,
    Not,
    And,
    Or,
    Xor,
    Shl,
    Shr,
    Sar
}


#[derive(Digital, PartialEq, Eq)]
pub struct AluInput<U: Unsigned + BitWidth + Eq + Copy> {
    pub op1: Bits<U>,
    pub op2: Bits<U>,
    pub select: AluOpcode,
    pub carry_in: Bits<U1>,
    pub enable: Bits<U1>,
}

#[derive(Digital, PartialEq, Eq)]
pub struct AluOutput<U: Unsigned+ BitWidth + Eq + Copy> {
    pub rez: Bits<U>,
    pub zero_flag: Bits<U1>,
    pub sign_flag: Bits<U1>,
    pub transport_flag: Bits<U1>,
    pub parity_flag: Bits<U1>,
    pub overflow_flag: Bits<U1>
}

#[kernel]
fn param_alu<U: Unsigned> (_cr: ClockReset, i: AluInput<U>) -> AluOutput<U>
where
    // Why are all of these necessary?
    // We need to do U-(U-1) when extracting last bit, which requires U: Sub<U1> + Sub<Diff<U,U1>>
    // We need U: Add<U1> to use U+1, also (U+1): Sub<U> to do (U+1)-U for the carry bit instruction
    // ALL newly calculated operands must also have BitWidth
    U: Unsigned + BitWidth + Eq + Copy + Add<U1> + Sub<U1> + Sub<Diff<U,U1>>,
    Add1<U>: Unsigned + BitWidth + Eq + Copy + Sub<U>,
    Diff<Add1<U>,U>: Unsigned + BitWidth + Eq + Copy,
    Diff<U,U1>: Unsigned + BitWidth + Eq + Copy,
    Diff<U, Diff<U,U1>>: Unsigned + BitWidth + Eq + Copy {

    // Final bit extraction method 1
    let s_op1 = i.op1.xshr::<Diff<U,U1>>().resize::<U1>();
    let s_op2 = i.op2.xshr::<Diff<U,U1>>().resize::<U1>();

    let (transport_flag, rez) = match i.select {
        AluOpcode::Adc => {
            let full_bits: Bits<Add1<U>> = i.op1.resize() + i.op2.resize() + i.carry_in.resize();
            // let full_bits: Bits<Add1<U>> = bits(full_rez);
            let c = full_bits.xshr::<U>().resize();
            let rez = full_bits.resize::<U>();
            (c,rez)
        },
        // "For logic operations carry is set to 0"
        AluOpcode::Not => {
            (bits(0),!i.op1)
        },
        AluOpcode::And => {
            (bits(0),i.op1 & i.op2)
        },
        AluOpcode::Or => {
            (bits(0), i.op1 & i.op2)
        },
        AluOpcode::Xor => {
            (bits(0), i.op1 ^ i.op2)
        },
        AluOpcode::Shr => {
            (i.op1.resize(),i.op1 >> 1)
        },
        AluOpcode::Sar => {
            // Final bit extraction method 2
            // 01111...11
            let m = Bits::<U>::MASK >> 1;
            // 10000...00
            let m = !m;
            if (i.op1 & m).any() {
                (i.op1.resize(), m | (i.op1 >> 1))
            } else {
                (i.op1.resize(), i.op1 >> 1)
            }
        },
        AluOpcode::Shl => {
            let m = Bits::<U>::MASK >> 1;
            let m = !m;
            (if (i.op1 & m).any() {bits(1)} else {bits(0)}, i.op1 << 1)
        },
        AluOpcode::Sbb1 => {
            // op1 + two's_complement(op2+c_in)
            let full_bits: Bits<Add1<U>> = i.op1.resize() + (!(i.op2.resize()+i.carry_in.resize()) + bits(1));
            let c = full_bits.xshr::<U>().resize();
            let rez = full_bits.resize::<U>();
            (c,rez)
        },
        AluOpcode::Sbb2 => {
            // op2 + two's_complement(op1+c_in)
            let full_bits: Bits<Add1<U>> = i.op2.resize() + (!(i.op1.resize()+i.carry_in.resize()) + bits(1));
            let c = full_bits.xshr::<U>().resize();
            let rez = full_bits.resize::<U>();
            (c,rez)
        }
    };

    let sign_flag = rez.xshr::<Diff<U,U1>>().resize::<U1>();
    
    AluOutput::<U>{
        rez,
        zero_flag: if rez == 0 {bits(1)} else {bits(0)},
        sign_flag,
        transport_flag,
        parity_flag: if rez.xor() {bits(0)} else {bits(1)},
        overflow_flag: match i.select {
            AluOpcode::Adc => if s_op1 == s_op2 && s_op1 != sign_flag {bits(1)} else {bits(0)},
            AluOpcode::Sbb1 => if s_op1 != s_op2 && s_op2 == sign_flag {bits(1)} else {bits(0)},
            AluOpcode::Sbb2 => if s_op1 != s_op2 && s_op1 == sign_flag {bits(1)} else {bits(0)},
            // "For logic operations overflow is set to 0"
            AluOpcode::Not => bits(0),
            AluOpcode::And => bits(0),
            AluOpcode::Or => bits(0),
            AluOpcode::Xor => bits(0),
            // "If sign bit changes, overflow is set to 1"
            AluOpcode::Shr => if s_op1 != sign_flag {bits(1)} else {bits(0)},
            AluOpcode::Sar => bits(0),
            AluOpcode::Shl => if s_op1 != sign_flag {bits(1)} else {bits(0)},
        },
    }
}

type ALU<U> = Func<AluInput<U>, AluOutput<U>>;

pub fn new<U>() -> Result<ALU<U>, RHDLError> 
where
    U: Unsigned + BitWidth + Eq + Copy + Add<U1> + Sub<U1> + Sub<Diff<U,U1>>,
    Add1<U>: Unsigned + BitWidth + Eq + Copy + Sub<U>,
    Diff<Add1<U>,U>: Unsigned + BitWidth + Eq + Copy,
    Diff<U,U1>: Unsigned + BitWidth + Eq + Copy,
    Diff<U, Diff<U,U1>>: Unsigned + BitWidth + Eq + Copy {
        Func::try_new::<param_alu<U>>()
}

pub fn sim_alu() -> Result<(), RHDLError>{
    let alu2 = match new::<U5>() {
        Ok(x) => x,
        Err(RHDLError::RHDLTypeCheckError(x)) => {println!("{}", &x.src.source.first_key_value().unwrap().1.source[x.cause_span.offset()..x.cause_span.offset()+x.cause_span.len()]); return Ok(())},
        Err(RHDLError::RHDLTypeError(x)) => {println!("{}", &x.src.source.first_key_value().unwrap().1.source[x.err_span.offset()..x.err_span.offset()+x.err_span.len()]); return Ok(())},
        Err(E) => {return Err(E)}
    };

    let test_data = vec![
        (0,  AluInput::<U5> { op1: Bits::<U5>::from(0), op2: Bits::<U5>::from(0), select: AluOpcode::Sbb1, carry_in: Bits::<U1>::from(0), enable: Bits::<U1>::from(1) }),
        (10, AluInput::<U5> { op1: Bits::<U5>::from(1), op2: Bits::<U5>::from(1), select: AluOpcode::Sbb1, carry_in: Bits::<U1>::from(0), enable: Bits::<U1>::from(1) }),
        (20, AluInput::<U5> { op1: Bits::<U5>::from(2), op2: Bits::<U5>::from(3), select: AluOpcode::Sbb1, carry_in: Bits::<U1>::from(0), enable: Bits::<U1>::from(1) }),
        (30, AluInput::<U5> { op1: Bits::<U5>::from(3), op2: Bits::<U5>::from(0), select: AluOpcode::Sbb1, carry_in: Bits::<U1>::from(1), enable: Bits::<U1>::from(1) }),
        (40, AluInput::<U5> {op1: Bits::<U5>::default(), op2: Bits::<U5>::default(), select: AluOpcode::default(), carry_in: Bits::<U1>::default(), enable: Bits::<U1>::default() }),
    ];

    let input = test_data.into_iter().map(|(time, val)| TimedSample {
        time,
        value: (ClockReset::default(), val),
    });

    let vcd = alu2.run(input)?.collect::<Vcd>();
    // let mut options = SvgOptions::default();
    // options.pixels_per_time_unit = 40.0;
    // Gives a vcd without needing gtkwave
    // write_svg_as_markdown(vcd, "dff.md", options)?;
    vcd.dump_to_file("alu2.vcd")?;

    Ok(())
}
