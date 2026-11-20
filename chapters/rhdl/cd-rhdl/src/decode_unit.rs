#![allow(unused)]

use bitops_rhdl::bitops;
use rhdl::typenum::Diff;

use crate::{prelude::*, register_file::reg};

#[derive(Debug, Digital, PartialEq)]
pub enum Operand {
    MaybeDst(DstOperand),
    Imm,
}

#[derive(Debug, Digital, PartialEq)]
pub enum DstOperand {
    DirectAddress, // Lpc Ipc DispA DispL EaDone
    IndirectAddress, // Lpc Ipc DispA DispL DdispA DdispL EaDone
    RegisterAddress(AddrRegister), // Ldi/Ldb EaDone
    RegSum(BaseRegister, IndexRegister), // Ldb Ldi Sum2 EaDone
    RegSumIncr(BaseRegister, IndexRegister), // Ldb Ldi Pipd Sum2 EaDone
    RegSumDecr(BaseRegister), // Ldb Ldi Pipd Sum2 EaDone
    BasedAddr(BaseRegister), // Lpc Ipc DispA DispL Ldb Sum2 EaDone
    IndexedAddr(IndexRegister), // Lpc Ipc DispA DispL Ldi Sum2 EaDone
    BasedIndexedAddr(BaseRegister, IndexRegister), // Lpc Ipc DispA DispL Ldb Sum1 Ldi Sum2 EaDone
    Reg(Reg),
}

#[derive(Debug, Digital, PartialEq)]
pub enum AddrRegister {
    Base(BaseRegister),
    Index(IndexRegister),
}

impl Default for AddrRegister {
    fn default() -> Self {
        Self::Base(BaseRegister::default())
    }
}

#[derive(Debug, Digital, PartialEq, Default)]
pub enum BaseRegister {
    #[default]
    BA,
    BB,
}

#[derive(Debug, Digital, PartialEq, Default)]
pub enum IndexRegister {
    #[default]
    XA,
    XB,
}

#[kernel]
pub fn btr(i: BaseRegister) -> Reg {
    match i {
        BaseRegister::BA => BA,
        BaseRegister::BB => BB,
    }
}
#[kernel]
pub fn itr(i: IndexRegister) -> Reg {
    match i {
        IndexRegister::XA => XA,
        IndexRegister::XB => XB,
    }
}

#[kernel]
pub fn artr(i: AddrRegister) -> Reg {
    match i {
        AddrRegister::Base(b) => btr(b),
        AddrRegister::Index(i) => itr(i),
    }
}

impl Default for Operand {
    fn default() -> Self {
        Self::Imm
    }
}

impl Default for DstOperand {
    fn default() -> Self {
        Self::Reg(Reg::default())
    }
}

#[derive(Debug, Digital, Default, PartialEq)]
pub enum TwoOp {
    #[default]
    Add,
    Adc,
    Sub,
    Sbb,
    And,
    Or,
    Xor,
    Cmp,
    Test,
    Mov,
}

#[bitops]
#[kernel]
fn twop(i: Bits<U3>) -> Option<TwoOp> {
    match i.raw() {
        0b000 => Some(TwoOp::Add),
        0b100 => Some(TwoOp::Adc),
        0b010 => Some(TwoOp::Sub),
        0b110 => Some(TwoOp::Sbb),
        0b001 => Some(TwoOp::And),
        0b101 => Some(TwoOp::Or),
        0b011 => Some(TwoOp::Xor),
        _ => None,
    }
}

#[derive(Debug, Digital, Default, PartialEq)]
pub enum OneOp {
    #[default]
    MovI,
    Push,
    Pop,
    Call,
    Jmp,
    Inc,
    Dec,
    Neg,
    Not,
    Shl,
    Shr,
    Sar,
}

#[bitops]
#[kernel]
fn eacfg(i: Bits<U3>) -> Option<OneOp> {
    match i.raw() {
        0b010 => Some(OneOp::Push),
        0b110 => Some(OneOp::Pop),
        0b001 => Some(OneOp::Call),
        0b101 => Some(OneOp::Jmp),
        _ => None,
    }
}

#[bitops]
#[kernel]
fn oop(i: Bits<U3>) -> Option<OneOp> {
    match i.raw() {
        0b000 => Some(OneOp::Inc),
        0b100 => Some(OneOp::Dec),
        0b010 => Some(OneOp::Neg),
        0b110 => Some(OneOp::Not),
        0b001 => Some(OneOp::Shl),
        0b101 => Some(OneOp::Shr),
        0b011 => Some(OneOp::Sar),
        _ => None,
    }
}

#[derive(Debug, Digital, Default, PartialEq)]
/// Control flow instructions with no effective address
///
/// Keep in mind that io port addresses are placed on the bus directly,
/// no need to pass them to control unit
pub enum CfNea {
    In,
    Out,
    Pushf,
    Popf,
    Ret,
    Iret,
    #[default]
    Hlt,
}

#[bitops]
#[kernel]
fn neacf(i: Bits<U3>) -> Option<CfNea> {
    match i.raw() {
        0b000 => Some(CfNea::In),
        0b100 => Some(CfNea::Out),
        0b010 => Some(CfNea::Pushf),
        0b110 => Some(CfNea::Popf),
        0b001 => Some(CfNea::Ret),
        0b101 => Some(CfNea::Iret),
        0b011 => Some(CfNea::Hlt),
        _ => None,
    }
}

#[derive(Debug, Digital, Default, PartialEq)]
/// Conditional Jumps relative to Program Counter
///
/// Keep in mind that offsets are placed on the bus directly,
/// no need to pass them to control unit
pub enum Jcond {
    #[default]
    Jbe,
    /// Also JC
    Jb,
    Jle,
    Jl,
    /// Also JZ
    Je,
    Jo,
    Js,
    Jpe,
    Ja,
    /// Also JNC
    Jae,
    Jg,
    Jge,
    /// Also JNZ
    Jne,
    Jno,
    Jns,
    Jpo,
}

#[bitops]
#[kernel]
fn jcond(i: Bits<U4>) -> Jcond {
    match i.raw() {
        0b0000 => Jcond::Jbe,
        0b1000 => Jcond::Jb,
        0b0100 => Jcond::Jle,
        0b1100 => Jcond::Jl,
        0b0010 => Jcond::Je,
        0b1010 => Jcond::Jo,
        0b0110 => Jcond::Js,
        0b1110 => Jcond::Jpe,
        0b0001 => Jcond::Ja,
        0b1001 => Jcond::Jae,
        0b0101 => Jcond::Jg,
        0b1101 => Jcond::Jge,
        0b0011 => Jcond::Jne,
        0b1011 => Jcond::Jno,
        0b0111 => Jcond::Jns,
        0b1111 => Jcond::Jpo,
        _ => Jcond::dont_care(),
    }
}

#[derive(Debug, Digital, Default, PartialEq)]
pub enum Decoded {
    TwoOp {
        op: TwoOp,
        src: Operand,
        dst: DstOperand,
    },
    OneOp {
        op: OneOp,
        dst: DstOperand,
    },
    CfNea(CfNea),
    Jcond(Jcond),
    #[default]
    Invalid,
}

#[kernel]
fn irx(i: Bits<U1>) -> IndexRegister {
    if i == bits(1) {
        IndexRegister::XB
    } else {
        IndexRegister::XA
    }
}

#[kernel]
fn brx(i: Bits<U1>) -> BaseRegister {
    if i == bits(1) {
        BaseRegister::BB
    } else {
        BaseRegister::BA
    }
}

#[bitops]
#[kernel]
/// Decodes the mod and rm parts in one go
fn mod_rm(i: Bits<U16>) -> DstOperand {
    let rm = i[15].resize() |
            i[14].resize() << 1 |
            i[13].resize() << 2;
    let m = i[9..8];
    match m.raw() {
        0b11 => DstOperand::Reg(reg(rm)),
        0b01 => {
            if rm < bits(0b100) {
                DstOperand::BasedIndexedAddr(brx(rm[1]), irx(rm[0]))
            } else if rm < bits(0b110) {
                DstOperand::IndexedAddr(irx(rm[0]))
            } else {
                DstOperand::BasedAddr(brx(rm[0]))
            }
        }
        0b10 => {
            if rm < bits(0b100) {
                DstOperand::RegSumIncr(brx(rm[1]), irx(rm[0]))
            } else if rm < bits(0b110) {
                DstOperand::RegSumDecr(brx(rm[0]))
            } else if rm < bits(0b111) {
                DstOperand::DirectAddress
            } else {
                DstOperand::IndirectAddress
            }
        }
        0b00 => {
            if rm < bits(0b100) {
                DstOperand::RegSum(brx(rm[1]), irx(rm[0]))
            } else if rm < bits(0b110) {
                DstOperand::RegisterAddress(AddrRegister::Index(irx(rm[0])))
            } else {
                DstOperand::RegisterAddress(AddrRegister::Base(brx(rm[0])))
            }
        }
        _ => DstOperand::dont_care(),
    }
}

#[bitops]
#[kernel]
pub fn decode(i: Bits<U16>) -> Decoded {
    let rm = mod_rm(i);
    let rg_raw = i[12].resize() |
        i[11].resize() << 1 |
        i[10].resize() << 2;
    let rg = DstOperand::Reg(reg(rg_raw));
    let (src, dst) = if i[7] == bits(1) {
        (Operand::MaybeDst(rm), rg)
    } else {
        (Operand::MaybeDst(rg), rm)
    };
    // R3..R2..R1..R0
    match i[3..0].raw() {
        // EA + One op + no imm + control flow
        0b0000 => {
            if let Some(x) = eacfg(i[6..4]) {
                return Decoded::OneOp { op: x, dst: rm };
            } else if i[6..4] == bits(0) {
                return Decoded::TwoOp { op: TwoOp::Mov, src, dst };
            }
        }
        // EA + One op + no imm + operation
        0b1000 => {
            if let Some(x) = oop(i[6..4]) {
                return Decoded::OneOp { op: x, dst: rm };
            }
        }
        0b0100 => {
            if i[6..4] == bits(0b000) {
                return Decoded::OneOp {
                    op: OneOp::MovI,
                    dst: rm,
                };
            }
        }
        // EA, TwoOp, no imm no save
        0b0010 => {
            if let Some(x) = twop(i[6..4]) {
                match x {
                    TwoOp::Sub => {
                        return Decoded::TwoOp {
                            op: TwoOp::Cmp,
                            src,
                            dst,
                        };
                    }
                    TwoOp::And => {
                        return Decoded::TwoOp {
                            op: TwoOp::Test,
                            src,
                            dst,
                        };
                    }
                    _ => {}
                }
            }
        }
        0b1010 => {
            if let Some(x) = twop(i[6..4]) {
                return Decoded::TwoOp { op: x, src, dst };
            }
        }
        0b0110 => {
            if let Some(x) = twop(i[6..4]) {
                match x {
                    TwoOp::Sub => {
                        return Decoded::TwoOp {
                            op: TwoOp::Cmp,
                            src: Operand::Imm,
                            dst: rm,
                        };
                    }
                    TwoOp::And => {
                        return Decoded::TwoOp {
                            op: TwoOp::Test,
                            src: Operand::Imm,
                            dst: rm,
                        };
                    }
                    _ => {}
                }
            }
        }
        0b1110 => {
            if let Some(x) = twop(i[6..4]) {
                return Decoded::TwoOp {
                    op: x,
                    src: Operand::Imm,
                    dst: rm,
                };
            }
        }
        // NEA CF
        0b0001 => {
            if let Some(x) = neacf(i[6..4]) {
                return Decoded::CfNea(x);
            }
        }
        0b1001 => {
            return Decoded::Jcond(jcond(i[7..4]));
        }
        _ => {}
    };
    Decoded::Invalid
}

mod tests {
    use super::*;
    #[kernel]
    fn decode_uut(_cr: ClockReset, i: Bits<U16>) -> Decoded {
        decode(i)
    }

    type Decoder = Func<Bits<U16>, Decoded>;

    fn assert_in_ref(i: Vec<u16>, r: Vec<Decoded>) {
        assert!(i.len() == r.len());
        let uut: Decoder = Func::try_new::<decode_uut>().expect("RHDL error");
        let mut s = uut.init();
        for (i, x) in i.iter().zip(r) {
            let d = uut.sim(ClockReset::default(), Bits::from(*i as u128), &mut s);

            assert_eq!(d, x);
        }
    }
    // use DstOperand::*;
    // use OneOp::*;
    // use Operand::*;
    // use TwoOp::*;
    // use CfNea::*;
    // use Jcond::*;
    // use rhdl::core::rhif::spec::Index;

    #[test]
    fn inc_all_ea_types_op() {
        let inputs = vec![
            0x0308, 0xE008, 0x6208, 0xE208, 0x2108, 0x6108, 0xE108, 0xC008, 0x0008, 0x4008, 0x8208,
            0xA208, 0x8108,
        ];
        let expect = vec![
            Decoded::OneOp {
                op: Inc,
                dst: Reg(RA),
            },
            Decoded::OneOp {
                op: Inc,
                dst: RegisterAddress(AddrRegister::Base(BaseRegister::BB)),
            },
            Decoded::OneOp {
                op: Inc,
                dst: DirectAddress,
            },
            Decoded::OneOp {
                op: Inc,
                dst: IndirectAddress,
            },
            Decoded::OneOp {
                op: Inc,
                dst: IndexedAddr(IndexRegister::XA),
            },
            Decoded::OneOp {
                op: Inc,
                dst: BasedAddr(BaseRegister::BA),
            },
            Decoded::OneOp {
                op: Inc,
                dst: BasedAddr(BaseRegister::BB),
            },
            Decoded::OneOp {
                op: Inc,
                dst: RegSum(BaseRegister::BB, IndexRegister::XB),
            },
            Decoded::OneOp {
                op: Inc,
                dst: RegSum(BaseRegister::BA, IndexRegister::XA),
            },
            Decoded::OneOp {
                op: Inc,
                dst: RegSum(BaseRegister::BB, IndexRegister::XA),
            },
            Decoded::OneOp {
                op: Inc,
                dst: RegSumIncr(BaseRegister::BA, IndexRegister::XB),
            },
            Decoded::OneOp {
                op: Inc,
                dst: RegSumDecr(BaseRegister::BB),
            },
            Decoded::OneOp {
                op: Inc,
                dst: BasedIndexedAddr(BaseRegister::BA, IndexRegister::XB),
            },
        ];
        assert_in_ref(inputs, expect);
    }

    #[test]
    fn generic_two_op() {
        let inputs = vec![0x4292, 0x140A, 0x612E];
        let expect = vec![
            Decoded::TwoOp {
                op: Test,
                src: MaybeDst(RegSumIncr(BaseRegister::BB, IndexRegister::XA)),
                dst: Reg(RA),
            },
            Decoded::TwoOp {
                op: Add,
                src: MaybeDst(Reg(XB)),
                dst: RegSum(BaseRegister::BA, IndexRegister::XA),
            },
            Decoded::TwoOp {
                op: Sub,
                src: Imm,
                dst: BasedAddr(BaseRegister::BA),
            },
        ];
        assert_in_ref(inputs, expect);
    }

    #[test]
    fn all_ea_one_op_ops_types() {
        let inputs = vec![
            0x0008, // INC [BA+XA]
            0xA048, // DEC [XB]
            0x2128, // NEG [XA + Depls]
            0x8168, // NOT [BA+XB+Depls]
            0x0318, // SHL RA
            0xE158, // SHR [BB + Depls]
            0xE238, // SAR [[Depls]]
        ];

        let expect = vec![
            Decoded::OneOp {
                 op: Inc, 
                 dst: RegSum(BaseRegister::BA, IndexRegister::XA) 
            },
            Decoded::OneOp { 
                op: Dec, 
                dst: RegisterAddress(AddrRegister::Index(IndexRegister::XB))
            },
            Decoded::OneOp { 
                op: Neg, 
                dst: IndexedAddr(IndexRegister::XA)
            },
            Decoded::OneOp { 
                op: Not, 
                dst: BasedIndexedAddr(BaseRegister::BA, IndexRegister::XB)
            },
            Decoded::OneOp {
                op: Shl, 
                dst: Reg(RA) 
            },
            Decoded::OneOp { 
                op: Shr,
                dst: BasedAddr(BaseRegister::BB) 
            },
            Decoded::OneOp { 
                op: Sar, 
                dst: IndirectAddress 
            },
        ];

        assert_in_ref(inputs, expect);
    }

    #[test]
    fn all_cfnea_types() {
        let inputs = vec![
            0x0001, // IN
            0x0041, // OUT
            0x0021, // PUSHF
            0x0061, // POPF
            0x0011, // RET
            0x0051, // IRET
            0x0031, // HLT
        ];

        let expect = vec![
            Decoded::CfNea(In),
            Decoded::CfNea(Out),
            Decoded::CfNea(Pushf),
            Decoded::CfNea(Popf),
            Decoded::CfNea(Ret),
            Decoded::CfNea(Iret),
            Decoded::CfNea(CfNea::Hlt),
        ];
        assert_in_ref(inputs, expect);
    }

    #[test]
    fn all_jumps() {
        let inputs = vec![
            0x0009, 0x0089, 0x0049, 0x00C9,
            0x0029, 0x00A9, 0x0069, 0x00E9,
            0x0019, 0x0099, 0x0059, 0x00D9,
            0x0039, 0x00B9, 0x0079, 0x00F9,
        ];
        let expect = vec![
            Decoded::Jcond(Jbe),
            Decoded::Jcond(Jb), 
            Decoded::Jcond(Jle), 
            Decoded::Jcond(Jl),
            Decoded::Jcond(Je),  
            Decoded::Jcond(Jo), 
            Decoded::Jcond(Js),  
            Decoded::Jcond(Jpe),
            Decoded::Jcond(Ja),  
            Decoded::Jcond(Jae),
            Decoded::Jcond(Jg),  
            Decoded::Jcond(Jge),
            Decoded::Jcond(Jne), 
            Decoded::Jcond(Jno),
            Decoded::Jcond(Jns), 
            Decoded::Jcond(Jpo),
        ];

        assert_in_ref(inputs, expect);
    }

    #[test]
    fn all_cf_ea_types() {
        let inputs = vec![
            0x8000, // MOV [BA+XB], RA
            0x0B84, // MOVI RC, 0
            0x4120, // PUSH [BB+XA+Depls]
            0x2260, // POP  [BA+XA-]
            0xC010, // CALL [BB+XB]
            0x6250, // JMP [Depls]
        ];

        let expect = vec![
            Decoded::TwoOp { 
                op: Mov,
                src: MaybeDst(Reg(RA)),
                dst: RegSum(BaseRegister::BA, IndexRegister::XB) 
            },
            Decoded::OneOp { 
                op: MovI, 
                dst: Reg(RA)
            },
                Decoded::OneOp { 
                op: Push, 
                dst: BasedIndexedAddr(BaseRegister::BB, IndexRegister::XA) 
            },
            Decoded::OneOp { 
                op: Pop, 
                dst: RegSumDecr(BaseRegister::BA)
            },
                Decoded::OneOp { 
                op: Call, 
                dst: RegSum(BaseRegister::BB, IndexRegister::XB) 
            },
            Decoded::OneOp { 
                op: Jmp, 
                dst: DirectAddress
            }
        ];

        assert_in_ref(inputs, expect);
    }

    #[test]
    fn all_two_op_saving_nimm() {
        let inputs = vec![
            0x808A, // ADD RA, [BA+XB]
            0x8A4A, // ADC [BA+XB+], RC
            0x66AA, // SUB XA, [Depls]
            0xED6A, // SBB [BB+Depls], BA
            0x839A, // AND RA, RB
            0x385A, // OR  [XA], IS
            0xF23A, // XOR [[Depls]], RB
        ];
        let mut expect = vec![
            Decoded::TwoOp {
                op: Add,
                src: MaybeDst(RegSum(BaseRegister::BA, IndexRegister::XB)),
                dst: Reg(RA),
            },
            Decoded::TwoOp {
                op: Adc,
                src: MaybeDst(Reg(RC)),
                dst: RegSumIncr(BaseRegister::BA, IndexRegister::XB),
            },
            Decoded::TwoOp {
                op: Sub,
                src: MaybeDst(DirectAddress),
                dst: Reg(XA),
            },
            Decoded::TwoOp {
                op: Sbb,
                src: MaybeDst(Reg(BA)),
                dst: BasedAddr(BaseRegister::BB),
            },
            Decoded::TwoOp {
                op: And,
                src: MaybeDst(Reg(RB)),
                dst: Reg(RA),
            },
            Decoded::TwoOp {
                op: Or,
                src: MaybeDst(Reg(SP)),
                dst: RegisterAddress(AddrRegister::Index(IndexRegister::XA))
            },
            Decoded::TwoOp {
                op: Xor,
                src: MaybeDst(Reg(RB)),
                dst: IndirectAddress,
            }
        ];
        assert_in_ref(inputs, expect);
    }

    #[test]
    fn all_two_op_saving_imm() {
        let inputs = vec![
            0x210E, // ADD [XA+Depls], X
            0x824E, // ADC [BA+XB+], X
            0x27AE, // SUB XA, X
            0xE16E, // SBB [BB+Depls], X
            0xA21E, // AND [BB+XA-], X
            0x205E, // OR  [XA], X
            0xE23E, // XOR [[Depls]], X
        ];
        let mut expect = vec![
            Decoded::TwoOp {
                op: Add,
                src: Imm,
                dst: IndexedAddr(IndexRegister::XA),
            },
            Decoded::TwoOp {
                op: Adc,
                src: Imm,
                dst: RegSumIncr(BaseRegister::BA, IndexRegister::XB),
            },
            Decoded::TwoOp {
                op: Sub,
                src: Imm,
                dst: Reg(XA),
            },
            Decoded::TwoOp {
                op: Sbb,
                src: Imm,
                dst: BasedAddr(BaseRegister::BB),
            },
            Decoded::TwoOp {
                op: And,
                src: Imm,
                dst: RegSumDecr(BaseRegister::BB),
            },
            Decoded::TwoOp {
                op: Or,
                src: Imm,
                dst: RegisterAddress(AddrRegister::Index(IndexRegister::XA))
            },
            Decoded::TwoOp {
                op: Xor,
                src: Imm,
                dst: IndirectAddress,
            }
        ];
        assert_in_ref(inputs, expect);
    }

    #[test]
    fn cmp_and_test() {
        let inputs = vec![
            0xCDA2, // CMP  BA, [BB+XB+Depls]
            0xE892, // TEST RC, [BB]
            0xA226, // CMP  [BB+XA-], X
            0x8116, // TEST [BA+XB+Depls], X
        ];
        let mut expect = vec![
            Decoded::TwoOp {
                op: Cmp,
                src: MaybeDst(BasedIndexedAddr(BaseRegister::BB, IndexRegister::XB)),
                dst: Reg(BA),
            },
            Decoded::TwoOp {
                op: Test,
                src: MaybeDst(RegisterAddress(AddrRegister::Base(BaseRegister::BB))),
                dst: Reg(RC),
            },
            Decoded::TwoOp {
                op: Cmp,
                src: Imm,
                dst: RegSumDecr(BaseRegister::BB),
            },
            Decoded::TwoOp {
                op: Test,
                src: Imm,
                dst: BasedIndexedAddr(BaseRegister::BA, IndexRegister::XB),
            },
        ];
        assert_in_ref(inputs, expect);
    }
}
