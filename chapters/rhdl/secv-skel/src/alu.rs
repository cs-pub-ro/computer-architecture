use rhdl::prelude::*;

#[derive(Digital, PartialEq, Eq)]
pub struct AluInput<U: Unsigned + BitWidth + Eq + Copy> {
    pub op1: Bits<U>,
    pub op2: Bits<U>,
    pub select: Bits<U4>,
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
fn param_alu<U: Unsigned> (_cr: ClockReset, _i: AluInput<U>) -> AluOutput<U>
where
    U: Unsigned + BitWidth + Eq + Copy, {
    //    TODO: implement ALU logic

        AluOutput::<U>{
            rez: bits(0),
            zero_flag: bits(0),
            sign_flag: bits(0),
            transport_flag: bits(0),
            parity_flag: bits(0),
            overflow_flag: bits(0),
        }
    }

type ALU<U> = Func<AluInput<U>, AluOutput<U>>;

pub fn new<U>() -> Result<ALU<U>, RHDLError> 
where
    U: Unsigned + BitWidth + Eq + Copy, {
        Func::try_new::<param_alu<U>>()
}

pub fn sim_alu() -> Result<(), RHDLError> {
    let alu2 = new::<U2>()?;

    let test_data = vec![
        (0,  AluInput::<U2> { op1: Bits::<U2>::from(0), op2: Bits::<U2>::from(0), select: Bits::<U4>::from(1), carry_in: Bits::<U1>::from(0), enable: Bits::<U1>::from(1) }),
        (10, AluInput::<U2> { op1: Bits::<U2>::from(1), op2: Bits::<U2>::from(1), select: Bits::<U4>::from(1), carry_in: Bits::<U1>::from(0), enable: Bits::<U1>::from(1) }),
        (20, AluInput::<U2> { op1: Bits::<U2>::from(2), op2: Bits::<U2>::from(3), select: Bits::<U4>::from(1), carry_in: Bits::<U1>::from(0), enable: Bits::<U1>::from(1) }),
        (30, AluInput::<U2> { op1: Bits::<U2>::from(3), op2: Bits::<U2>::from(0), select: Bits::<U4>::from(1), carry_in: Bits::<U1>::from(0), enable: Bits::<U1>::from(1) }),
        (40, AluInput::<U2> {op1: Bits::<U2>::default(), op2: Bits::<U2>::default(), select: Bits::<U4>::default(), carry_in: Bits::<U1>::default(), enable: Bits::<U1>::default() }),
    ];

    let input = test_data.into_iter().map(|(time, val)| TimedSample {
        time,
        value: (ClockReset::default(), val),
    });

    let vcd = alu2.run(input)?.collect::<Vcd>();
    vcd.dump_to_file("alu2.vcd")?;

    Ok(())
}