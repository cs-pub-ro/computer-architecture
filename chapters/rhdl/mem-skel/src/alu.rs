use rhdl::prelude::*;
use rhdl_fpga::core::dff::*;

#[derive(Debug, Digital, PartialEq, Eq, Default)]
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
    Sar,
}

// alu
#[derive(Digital, PartialEq, Eq)]
pub struct AluInput {
    pub op1: Bits<U16>,
    pub op2: Bits<U16>,
    pub select: AluOpcode,
    pub carry_in: Bits<U1>,
    pub enable: Bits<U1>,
}

#[derive(Digital, PartialEq, Eq)]
pub struct AluOutput {
    pub rez: Bits<U16>,
    pub zero_flag: Bits<U1>,
    pub transport_flag: Bits<U1>,
}
#[derive(Synchronous, Clone, Debug)]
pub struct Alu {}
impl SynchronousDQ for Alu {
    type D = ();
    type Q = ();
}

impl SynchronousIO for Alu {
    type I = AluInput;

    type O = AluOutput;

    type Kernel = alu;
}

#[kernel]
pub fn alu(_cr: ClockReset, _i: AluInput, _q: ()) -> (AluOutput, ()) {
    //    TODO: implement ALU logic

    (
        AluOutput {
            rez: if _i.enable == bits(1) {
                _i.op1 + _i.op2
            } else {
                bits(0)
            },
            transport_flag: bits(0),
            zero_flag: bits(0),
        },
        (),
    )
}
