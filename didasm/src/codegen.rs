use crate::tokens::Operand::*;
use crate::tokens::{
    ArithmeticMnemonic::*, ControlFlowMnemonic::*, GeneralMnemonic::*, LogicMnemonic::*,
    Mnemonic::*, ShiftMnemonic::*, *,
};
use bitfield::{bitfield, BitRange, BitRangeMut};
use core::str::FromStr;
use std::collections::HashMap;
use std::fmt::Display;

#[derive(Debug)]
pub struct Statement {
    pub lineno: usize,
    pub line: String,
    pub mnemonic: String,
    pub op1: Option<String>,
    pub op2: Option<String>,
}

#[derive(Debug)]
pub struct ParsedStatement {
    pub mnemonic: Mnemonic,
    pub op1: Option<Operand>,
    pub op2: Option<Operand>,
}

impl ParsedStatement {
    pub fn from_statement(s: Statement) -> Result<Self, String> {
        Ok(ParsedStatement {
            mnemonic: Mnemonic::from_str(&s.mnemonic)
                .map_err(|_| format!("'{}' is not a supported mnemonic", &s.mnemonic))?,
            op1: s.op1.map(|op| Operand::from_str(&op)).transpose()?,
            op2: s.op2.map(|op| Operand::from_str(&op)).transpose()?,
        })
    }
}

bitfield! {
    /// While some fields might be renamed, they might still
    /// be useful for understanding what exactly you are filling out
    pub struct Instruction(u16);
    no default BitRange;
    impl Debug;

    eff_address, set_eff_address: 0,0;
    two_addresses, set_if_2_addrs: 1,1;
    is_imm, set_if_imm: 2,2;
    does_save, set_if_saves: 3,3;
    is_operation, set_if_operation: 3,3;
    in_type, set_in_type: 0,3;
    opcode, set_op: 4,6;
    opcode_jcond, set_op_jcond:4,7;
    d, set_dir: 7,7;
    modifier, set_mod: 8,9;
    reg, set_reg: 10,12;
    rm, set_rm: 13,15;
    port, set_port: 8,15;
    pc_displacement, set_pc_displacement: 8,15;
}

impl BitRange<u16> for Instruction {
    fn bit_range(&self, msb: usize, lsb: usize) -> u16 {
        let w = msb.abs_diff(lsb) + 1;
        // let mn = if msb > lsb {lsb} else {msb};
        let mx = if msb > lsb { msb } else { lsb };
        let mask = (1 << w) - 1;
        let value = if msb > lsb {
            self.0
        } else {
            self.0.reverse_bits() >> (16 - mx - 1)
        };
        value & mask
    }
}
impl BitRangeMut<u16> for Instruction {
    fn set_bit_range(&mut self, msb: usize, lsb: usize, value: u16) {
        let w = msb.abs_diff(lsb) + 1;
        let mn = if msb > lsb { lsb } else { msb };
        // let mx = if msb > lsb {msb} else {lsb};
        let value = if msb > lsb {
            value
        } else {
            value.reverse_bits() >> (16 - w)
        };
        let mask = ((1 << w) - 1) << mn;
        let mask = !mask;
        // println!("Bitmask: {mask:016b}, {value:0width$b}", width=w);
        self.0 &= mask;
        self.0 += value << mn;
    }
}

impl Display for Instruction {
    /// Beautiful representation is default because otherwise we would just print the u16 inside it
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{:04b}_{:03b}_{:01b}_{:02b}_{:03b}_{:03b}",
            self.in_type(),
            self.opcode(),
            self.d(),
            self.modifier(),
            self.reg(),
            self.rm()
        )
    }
}

#[derive(Debug)]
pub struct FullInstruction {
    i: Instruction,
    pub displacement: Option<u16>,
    pub imm: Option<u16>,
}

impl Display for FullInstruction {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let x = self.i.0;
        write!(f, "{:04X}", x)?;
        if let Some(x) = self.displacement {
            write!(f, " {:04X}", x)?;
        }
        if let Some(x) = self.imm {
            write!(f, " {:04X}", x)?;
        }

        Ok(())
    }
}

impl FullInstruction {
    pub fn get_i(&self) -> u16 {
        self.i.0
    }
}

#[derive(Debug)]
pub struct Ir {
    mnemonic: Mnemonic,
    d: bool,
    m: u16,
    reg: Option<usize>,
    rm: Option<usize>,
    displacement: Option<Expr>,
    imm: Option<Expr>,
}

impl Ir {
    // Intermediate check step. It takes the operands and sees what mod, d, imm, displacement should look like
    pub fn from_parsed_statement(ps: ParsedStatement) -> Result<Self, String> {
        let ParsedStatement { mnemonic, op1, op2 } = ps;
        let mut opcode: Instruction = Instruction(0);
        opcode.set_op((&mnemonic).into());

        let imm = match (op1.clone(), op2.clone()) {
            // Since the first operand might be a port or relative jump, we just ignore that Imm is source operand
            // We check for this possibility later
            (Some(Imm(i)), _) | (_, Some(Imm(i))) => Some(i),
            _ => None,
        };

        let (d, reg) = match (op1.clone(), op2.clone()) {
            (Some(Reg(_)), Some(Imm(_))|None) => (false, None),
            (Some(Reg(r)), _) => (true, Some(r as usize)),
            (_, Some(Reg(r))) => (false, Some(r as usize)),
            _ => (false, None),
        };

        let (m, rm, displacement) = match (op1, op2) {
            (Some(Reg(_)), Some(Reg(ri))) => (0b11, Some(ri.into()), None),
            (Some(Imm(_)), Some(Imm(_))) => {
                return Err("Operations between 2 immediate values is not allowed!".to_string());
            },
            (Some(Reg(ri)), Some(Imm(_))|None) => (0b11, Some(ri.into()), None),
            (Some(Imm(_)), Some(_)) => {
                if matches!(
                    mnemonic,
                    Mnemonic::ConditionalJump(_) | Mnemonic::General(In | Out)
                ) {
                    (0b00, None, None)
                } else {
                    return Err("Immediate values are not allowed to be the source operand! Consider swapping the operands".to_string());
                }
            }
            (
                Some(
                    RegIndirect(_)
                    | RegSum { .. }
                    | RegSumAutodecrement { .. }
                    | RegSumAutoincrement { .. }
                    | Based { .. }
                    | Indexed { .. }
                    | BasedIndexed { .. }
                    | Direct(_)
                    | Indirect(_),
                ),
                Some(
                    RegIndirect(_)
                    | RegSum { .. }
                    | RegSumAutodecrement { .. }
                    | RegSumAutoincrement { .. }
                    | Based { .. }
                    | Indexed { .. }
                    | BasedIndexed { .. }
                    | Direct(_)
                    | Indirect(_),
                ),
            ) => {
                return Err(
                    "You are not allowed to have an operation between 2 operands that use memory!"
                        .to_string(),
                );
            }
            (Some(RegIndirect(ri)), _) | (_, Some(RegIndirect(ri))) => {
                (0b00, Some(ri.into()), None)
            }
            (Some(RegSum { b, x }), _) | (_, Some(RegSum { b, x })) => (
                0b00,
                Some(((x as usize) & 0b1) + ((b as usize) & 0b10)),
                None,
            ),
            (Some(Indexed { x: ri, displacement } | Based { b: ri, displacement }), _)
            | (_, Some(Indexed { x: ri, displacement } | Based { b: ri, displacement })) => {
                (0b10, Some(ri.into()), Some(displacement))
            }
            (Some(BasedIndexed { b, x, displacement }), _) | (_, Some(BasedIndexed { b, x, displacement })) => (
                0b10,
                Some(((x as usize) & 0b1) + ((b as usize) & 0b10)),
                Some(displacement),
            ),
            (Some(RegSumAutoincrement { b, x }), _) | (_, Some(RegSumAutoincrement { b, x })) => (
                0b01,
                Some(((x as usize) & 0b1) + ((b as usize) & 0b10)),
                None,
            ),
            (Some(RegSumAutodecrement { b }), _) | (_, Some(RegSumAutodecrement { b })) => {
                (0b01, Some(0b100 + ((b as usize >> 1) & 1)), None)
            }
            (Some(Direct(displacement)), _) | (_, Some(Direct(displacement))) => (0b01, Some(0b110), Some(displacement)),
            (Some(Indirect(displacement)), _) | (_, Some(Indirect(displacement))) => {
                (0b01, Some(0b111), Some(displacement))
            }
            // Cases that should have been placed in _ but explicitly stated
            // to utilize the pattern matching mechanism of rust for
            // proving completeness on this match
            (None | Some(Imm(_)), None | Some(Reg(_) | Imm(_))) => (0, None, None),
        };
        Ok(Ir {
            mnemonic,
            d,
            m,
            reg,
            rm,
            displacement,
            imm,
        })
    }

    // This does not keep track of errors since they will be detected in the last stage
    // It may also have erroneous results however it does not matter since the errors will be detected later
    // and the program will halt
    pub fn peek_word_count(&self) -> usize {
        let Ir {
            mnemonic,
            displacement,
            imm,
            ..
        } = self;
        match (mnemonic, displacement, imm) {
            (General(In | Out | Pushf | Popf) | ControlFlow(Ret | Iret | Hlt), _, _) => 1,
            (ConditionalJump(_), _, _) => 1,
            (
                Arithmetic(Inc | Dec | Neg)
                | Logic(Not)
                | Shift(Shl | Shr | Sar | Sal)
                | General(Pop | Push)
                | ControlFlow(Call | Jmp),
                None,
                _,
            ) => 1,
            (
                Arithmetic(Inc | Dec | Neg)
                | Logic(Not)
                | Shift(Shl | Shr | Sar | Sal)
                | General(Pop | Push)
                | ControlFlow(Call | Jmp),
                Some(_),
                _,
            ) => 2,
            (
                General(Mov)
                | Arithmetic(Cmp | Add | Adc | Sub | Sbb)
                | Logic(Test | And | Or | Xor),
                Some(_),
                Some(_),
            ) => 3,
            (
                General(Mov)
                | Arithmetic(Cmp | Add | Adc | Sub | Sbb)
                | Logic(Test | And | Or | Xor),
                None,
                Some(_),
            ) => 2,
            (
                General(Mov)
                | Arithmetic(Cmp | Add | Adc | Sub | Sbb)
                | Logic(Test | And | Or | Xor),
                Some(_),
                None,
            ) => 2,
            (
                General(Mov)
                | Arithmetic(Cmp | Add | Adc | Sub | Sbb)
                | Logic(Test | And | Or | Xor),
                None,
                None,
            ) => 1,
        }
    }

    pub fn convert_to_instruction(
        self,
        symbol_table: &HashMap<String, isize>,
        cursor: usize,
    ) -> Result<FullInstruction, String> {
        let Ir {
            mnemonic,
            d,
            m,
            reg,
            rm,
            displacement,
            imm,
        } = self;
        let mut opcode: Instruction = Instruction(0);
        opcode.set_op((&mnemonic).into());

        // Set generic opcode fields
        match &mnemonic {
            General(In | Out | Pushf | Popf) | ControlFlow(Ret | Iret | Hlt) => {
                opcode.set_in_type(0b1000);
            }
            ConditionalJump(m) => {
                opcode.set_in_type(0b1001);
                opcode.set_op_jcond(u16::from(*m));
            }
            General(Pop | Push) | ControlFlow(Call | Jmp) => {
                opcode.set_in_type(0b0000);
            }
            Arithmetic(Inc | Dec | Neg) | Logic(Not) | Shift(Shl | Shr | Sar | Sal) => {
                opcode.set_in_type(0b0001);
            }
            Arithmetic(Cmp) | Logic(Test) => {
                opcode.set_in_type(0b0100);
                opcode.set_if_imm(imm.is_some() as u16);
            }
            General(Mov) => {
                opcode.set_in_type(0b0000);
                // print_bits(&opcode);
                opcode.set_if_imm(imm.is_some() as u16);
                // print_bits(&opcode);
            }
            Arithmetic(Add | Adc | Sub | Sbb) | Logic(And | Or | Xor) => {
                opcode.set_in_type(0b0101);
                opcode.set_if_imm(imm.is_some() as u16);
            }
        }

        // Parse the possible identifiers
        let displacement = displacement
            .map(|e| match e {
                Expr::Id(i) => symbol_table
                    .get(&i)
                    .ok_or_else(|| format!("Identifier '{i}' not found in symbol table"))
                    .copied(),
                Expr::Int(i) => Ok(i),
            })
            .transpose()?;

        let imm = imm
            .map(|e| match e {
                Expr::Id(i) => symbol_table
                    .get(&i)
                    .ok_or_else(|| format!("Identifier '{i}' not found in symbol table"))
                    .map(|&x| {
                        if matches!(mnemonic, Mnemonic::ConditionalJump(_)) {
                            x - (cursor as isize)
                        } else {
                            x
                        }
                    }),
                Expr::Int(i) => Ok(i),
            })
            .transpose()?;

        // Final check of every combination an instruction may take
        // Even if technically all building blocks are available, extras will raise a semantic error
        match (mnemonic, reg, rm, displacement, imm) {
            (General(In | Out), None, None, None, Some(x)) => {
                let x: u8 = x
                    .try_into()
                    .map_err(|_| format!("Cannot convert '{x}' into an 8 bit unsigned integer"))?;
                opcode.set_port(x.into());
                Ok(FullInstruction {
                    i: opcode,
                    displacement: None,
                    imm: None,
                })
            }
            (General(i @ (In | Out)), _, _, _, _) => {
                Err(format!("{i} only takes an immediate operand!"))
            }
            (General(Pushf | Popf) | ControlFlow(Ret | Iret | Hlt), None, None, None, None) => {
                Ok(FullInstruction {
                    i: opcode,
                    displacement: None,
                    imm: None,
                })
            }
            (i @ (General(Pushf | Popf) | ControlFlow(Ret | Iret | Hlt)), _, _, _, _) => {
                Err(format!("{i} does not take any operands!"))
            }
            (ConditionalJump(_), None, None, None, Some(x)) => {
                let x: i8 = x
                    .try_into()
                    .map_err(|_| format!("Cannot convert '{x}' into an 8 bit signed integer"))?;
                opcode.set_port((x as u8) as u16);
                Ok(FullInstruction {
                    i: opcode,
                    displacement: None,
                    imm: None,
                })
            }
            (ConditionalJump(i), _, _, _, _) => {
                Err(format!("{i} only takes an immediate operand!"))
            }
            (
                Arithmetic(Inc | Dec | Neg)
                | Logic(Not)
                | Shift(Shl | Shr | Sar | Sal)
                | General(Pop | Push)
                | ControlFlow(Call | Jmp),
                Some(reg),
                None,
                None,
                None,
            ) => {
                opcode.set_reg(reg.try_into().map_err(|_| {
                    "Register enum should always be convertible to u16".to_string()
                })?);
                opcode.set_dir(d as u16);
                Ok(FullInstruction {
                    i: opcode,
                    displacement: None,
                    imm: None,
                })
            }
            (
                Arithmetic(Inc | Dec | Neg)
                | Logic(Not)
                | Shift(Shl | Shr | Sar | Sal)
                | General(Pop | Push)
                | ControlFlow(Call | Jmp),
                None,
                Some(rm),
                x,
                None,
            ) => {
                opcode.set_rm(rm.try_into().map_err(|_| {
                    "Register enum should always be convertible to u16".to_string()
                })?);
                opcode.set_dir(d as u16);
                opcode.set_mod(m);
                let x: Option<u16> = x
                    .map(|x| {
                        x.try_into()
                            .map_err(|_| format!("{x} cannot be converted to unsigned 16 bit"))
                    })
                    .transpose()?;
                Ok(FullInstruction {
                    i: opcode,
                    displacement: x,
                    imm: None,
                })
            }
            (
                i @ (Arithmetic(Inc | Dec | Neg)
                | Logic(Not)
                | Shift(Shl | Shr | Sar | Sal)
                | General(Pop | Push)
                | ControlFlow(Call | Jmp)),
                _,
                _,
                _,
                Some(_),
            ) => Err(format!("{i} does not support immediate values!")),
            (
                i @ (Arithmetic(Inc | Dec | Neg)
                | Logic(Not)
                | Shift(Shl | Shr | Sar | Sal)
                | General(Pop | Push)
                | ControlFlow(Call | Jmp)),
                Some(_),
                Some(_),
                _,
                None,
            )
            | (
                i @ (Arithmetic(Inc | Dec | Neg)
                | Logic(Not)
                | Shift(Shl | Shr | Sar | Sal)
                | General(Pop | Push)
                | ControlFlow(Call | Jmp)),
                None,
                None,
                None,
                None,
            ) => Err(format!("{i} only supports one operand!")),
            (
                Arithmetic(Inc | Dec | Neg)
                | Logic(Not)
                | Shift(Shl | Shr | Sar | Sal)
                | General(Pop | Push)
                | ControlFlow(Call | Jmp),
                _,
                None,
                Some(_),
                _,
            ) => Err("We should never reach this point. Contact the developer!".to_string()),
            (
                General(Mov)
                | Arithmetic(Cmp | Add | Adc | Sub | Sbb)
                | Logic(Test | And | Or | Xor),
                Some(reg),
                Some(rm),
                x,
                y,
            ) => {
                opcode.set_dir(d as u16);
                opcode.set_mod(m);
                opcode.set_reg(reg.try_into().map_err(|_| {
                    "Register enum should always be convertible to u16".to_string()
                })?);
                opcode.set_rm(rm.try_into().map_err(|_| {
                    "Register enum should always be convertible to u16".to_string()
                })?);
                let x: Option<u16> = x
                    .map(|x| {
                        x.try_into()
                            .map_err(|_| format!("{x} cannot be converted to unsigned 16 bit"))
                    })
                    .transpose()?;
                let y: Option<u16> = y
                    .map(|x| {
                        x.try_into()
                            .map_err(|_| format!("{x} cannot be converted to unsigned 16 bit"))
                    })
                    .transpose()?;

                Ok(FullInstruction {
                    i: opcode,
                    displacement: x,
                    imm: y,
                })
            }
            (
                General(Mov)
                | Arithmetic(Cmp | Add | Adc | Sub | Sbb)
                | Logic(Test | And | Or | Xor),
                None,
                Some(rm),
                x,
                Some(imm),
            ) => {
                opcode.set_dir(d as u16);
                opcode.set_mod(m);
                opcode.set_rm(rm.try_into().map_err(|_| {
                    "Register enum should always be convertible to u16".to_string()
                })?);
                let x: Option<u16> = x
                    .map(|x| {
                        x.try_into()
                            .map_err(|_| format!("{x} cannot be converted to unsigned 16 bit"))
                    })
                    .transpose()?;
                let imm = imm
                    .try_into()
                    .map_err(|_| format!("{imm} cannot be converted to unsigned 16 bit"))?;
                Ok(FullInstruction {
                    i: opcode,
                    displacement: x,
                    imm: Some(imm),
                })
            }
            // Tecnhically this should be covered already by a previous branch
            // but we are placing this here for completion's sake
            (
                General(Mov)
                | Arithmetic(Cmp | Add | Adc | Sub | Sbb)
                | Logic(Test | And | Or | Xor),
                Some(reg),
                None,
                None,
                Some(imm),
            ) => {
                opcode.set_dir(d as u16);
                opcode.set_reg(reg.try_into().map_err(|_| {
                    "Register enum should always be convertible to u16".to_string()
                })?);
                let imm = imm
                    .try_into()
                    .map_err(|_| format!("{imm} cannot be converted to unsigned 16 bit"))?;
                Ok(FullInstruction {
                    i: opcode,
                    displacement: None,
                    imm: Some(imm),
                })
            }
            (
                i @ (General(Mov)
                | Arithmetic(Cmp | Add | Adc | Sub | Sbb)
                | Logic(Test | And | Or | Xor)),
                Some(_),
                None,
                None,
                None,
            )
            | (
                i @ (General(Mov)
                | Arithmetic(Cmp | Add | Adc | Sub | Sbb)
                | Logic(Test | And | Or | Xor)),
                None,
                Some(_),
                _,
                None,
            )
            | (
                i @ (General(Mov)
                | Arithmetic(Cmp | Add | Adc | Sub | Sbb)
                | Logic(Test | And | Or | Xor)),
                None,
                None,
                None,
                Some(_) | None,
            ) => Err(format!("{i} requires at least 2 operands!")),
            (
                General(Mov)
                | Arithmetic(Cmp | Add | Adc | Sub | Sbb)
                | Logic(Test | And | Or | Xor),
                _,
                None,
                Some(_),
                _,
            ) => Err("We should never reach this point. Contact the developer!".to_string()),
        }
    }
}
