use bitfield::{bitfield, BitRange, BitRangeMut};
use regex::Regex;
#[allow(unused_imports)]
use std::collections::{HashMap, HashSet};
use std::fmt::Display;



mod tokens;
use tokens::*;
use std::str::FromStr;
use Mnemonic::*;
use Operand::*;

bitfield! {
    /// While some fields might be renamed, they might still
    /// be useful for understanding what exactly you are filling out
    struct Instruction(u16);
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
    pc_depls, set_pc_depls: 8,15;
}

impl BitRange<u16> for Instruction {
    fn bit_range(&self, msb: usize, lsb: usize) -> u16 {
        let width = msb.abs_diff(lsb) + 1;
        let mask = (1 << width) - 1;
        ((self.0 >> lsb) & mask) as u16
    }
}
impl BitRangeMut<u16> for Instruction {
    fn set_bit_range(&mut self, msb: usize, lsb: usize, value: u16) {
        let w = msb.abs_diff(lsb) + 1;
        let mn = if msb > lsb {lsb} else {msb};
        let _mx = if msb > lsb {msb} else {lsb};
        let value = if msb > lsb {value} else {value.reverse_bits() >> (16 - w)};
        let mask = ((1 << w) - 1) << mn;
        let mask = !mask;
        // println!("Bitmask: {mask:016b}, {value:0width$b}", width=w);
        self.0 = self.0 & mask;
        self.0 += (value as u16) << mn;
    }
}

// impl BitRange<u8> for Instruction {
//     fn bit_range(&self, msb: usize, lsb: usize) -> u8 {
//         let width = msb - lsb + 1;
//         let mask = (1 << width) - 1;
//         ((self.0 >> lsb) & mask) as u8
//     }
// }
// impl BitRangeMut<u8> for Instruction {
//     fn set_bit_range(&mut self, msb: usize, lsb: usize, value: u8) {
//         self.0 = (value as u16) << lsb;
//         print_bits(&self);
//     }
// }

#[derive(Debug)]
struct Statement {
    lineno: usize,
    line: String,
    mnemonic: String,
    op1: Option<String>,
    op2: Option<String>
}

#[derive(Debug)]
struct ParsedStatement {
    mnemonic: Mnemonic,
    op1: Option<Operand>,
    op2: Option<Operand>
}

#[derive(Debug)]
struct FullInstruction {
    i: Instruction,
    depls: Option<u16>,
    imm: Option<u16>
}

#[allow(dead_code)]
fn print_bits(instr: &Instruction) {
    print!("Bits: ");
    let x = instr.0;
    for i in 0..16 {
        print!("{}", (x >> i) & 1);
    }
    println!();
}

impl Display for FullInstruction {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let x = self.i.0;
        write!(f, "{:016b}", x)?;
        if let Some(x) = self.depls {
            write!(f, " {:016b}", x)?;
        }
        if let Some(x) = self.imm {
            write!(f, " {:016b}", x)?;
        }
        
        Ok(())
    }
}

impl ParsedStatement {
    fn from_statement(s: Statement) -> Result<Self, String> {
        Ok(ParsedStatement {
            mnemonic: Mnemonic::from_str(&s.mnemonic).map_err(|_| format!("'{}' is not a supported mnemonic", &s.mnemonic))?,
            op1: s.op1.map(|op| Operand::from_str(&op)).transpose()?,
            op2: s.op2.map(|op| Operand::from_str(&op)).transpose()?
        })
    }

    fn convert_to_instruction(self) -> Result<FullInstruction, String> {
        let ParsedStatement { mnemonic, op1, op2, .. } = self;
        let mut opcode: Instruction = Instruction(0);
        opcode.set_op((&mnemonic).into());

        let imm = match (op1.clone(), op2.clone()) {
            // Since the first operand might be a port or relative jump, we just ignore that Imm is source operand
            // We check for this possibility later
            (Some(Imm(i)), _) |
            (_, Some(Imm(i)))
                => Some(i),
            _ => None
        };

        match &mnemonic {
            In|Out|Pushf|Popf|Ret|Iret|Hlt => {
                opcode.set_in_type(0b1000);
            },
            m @ (Jbe|Jb|Jc|Jle|Jl|Je|Jz|Jo|Js|Jpe|Ja|Jae|Jnc|
            Jg|Jge|Jne|Jnz|Jno|Jns|Jpo) => {
                opcode.set_in_type(0b1001);
                opcode.set_op_jcond(m.into());
            },
            Push|Pop|Call|Jmp => {
                opcode.set_in_type(0b0000);
            },
            Inc|Dec|Neg|Not|Shl|Shr|Sar|Sal => {
                opcode.set_in_type(0b0001);
            },
            Cmp|Test => {
                opcode.set_in_type(0b0100);
                opcode.set_if_imm(imm.is_some() as u16);
            },
            Mov => {
                opcode.set_in_type(0b0000);
                // print_bits(&opcode);
                opcode.set_if_imm(imm.is_some() as u16);
                // print_bits(&opcode);

            },
            Add|Adc|Sub|Sbb|And|Or|Xor => {
                opcode.set_in_type(0b0101);
                opcode.set_if_imm(imm.is_some() as u16);
            }
        }
        let (d, reg) = match (op1.clone(), op2.clone()) {
            (Some(Reg(r)), _) => (true, Some(r as usize)),
            (_, Some(Reg(r))) => (false, Some(r as usize)),
            _ => (false, None)
        };

        let (m, rm, depls) = match (op1, op2) {
            (Some(Reg(_)), Some(Reg(ri)))
                => (0b11, Some(ri.into()), None),
            (Some(Imm(_)), Some(Imm(_))) => {return Err(format!("Operations between 2 immediate values is not allowed!"));},
            (Some(Imm(_)), Some(_)) => {return Err(format!("Immediate values are not allowed to be the source operand! Consider swapping the operands"));},
            (Some(RegIndirect(_)|RegSum{..}|RegSumAutodecrement{..}|RegSumAutoincrement{..}|Based{..}|Indexed{..}|BasedIndexed{..}|Direct(_)|Indirect(_)),
            Some(RegIndirect(_)|RegSum{..}|RegSumAutodecrement{..}|RegSumAutoincrement{..}|Based{..}|Indexed{..}|BasedIndexed{..}|Direct(_)|Indirect(_)))
                => {return Err(format!("You are not allowed to have an operation between 2 operands that use memory!"));}
            (Some(RegIndirect(ri)), _) |
            (_, Some(RegIndirect(ri)))
                => (0b00, Some(ri.into()), None),
            (Some(RegSum { b, x }), _) |
            (_, Some(RegSum { b, x }))
                => (0b00, Some(((x as usize) & 0b1) + ((b as usize)&0b10)), None),
            (Some(Indexed { x: ri, depls }|Based { b: ri, depls }), _) |
            (_, Some(Indexed { x: ri, depls }|Based { b: ri, depls }))
                => (0b10, Some(ri.into()), Some(depls)),
            (Some(BasedIndexed { b, x, depls }), _) |
            (_, Some(BasedIndexed { b, x, depls }))
                => (0b10, Some(((x as usize)&0b1) + ((b as usize)&0b10)), Some(depls)),
            (Some(RegSumAutoincrement { b, x }), _) |
            (_, Some(RegSumAutoincrement { b, x }))
                => (0b01, Some(((x as usize)&0b1) + ((b as usize)&0b10)), None),
            (Some(RegSumAutodecrement{b, ..}), _) |
            (_, Some(RegSumAutodecrement { b, ..}))
                => (0b01, Some(0b100 + ((b as usize >> 1)&1)), None),
            (Some(Direct(depls)), _) |
            (_, Some(Direct(depls)))
                => (0b01, Some(0b110), Some(depls)),
            (Some(Indirect(depls)), _) |
            (_, Some(Indirect(depls)))
                => (0b01, Some(0b111), Some(depls)),
            // Cases that should have been placed in _ but explicitly stated
            // to utilize the pattern matching mechanism of rust for
            // proving completeness on this match
            (None|Some(Reg(_)|Imm(_)), None|Some(Reg(_)|Imm(_)))
                => (0, None, None)
        };
        let depls = depls.map(|e| match e {
            Expr::Id(_) => unimplemented!("Identifiers are work in progress"),
            Expr::Int(i) => i
        });

        let imm = imm.map(|e| match e {
            Expr::Id(_) => unimplemented!("Identifiers are work in progress"),
            Expr::Int(i) => i
        });

        match (mnemonic, reg, rm, depls, imm) {
            (In|Out, None, None, None, Some(x)) => {
                let x: u8 = x.try_into().map_err(|_| format!("Cannot convert '{x}' into an 8 bit unsigned integer"))?;
                opcode.set_port(x.into());
                Ok(FullInstruction {
                    i: opcode,
                    depls: None,
                    imm: None
                })
            },
            (i@(In|Out),_,_,_,_)
                => Err(format!("{i} only takes an immediate operand!")),
            (Pushf|Popf|Ret|Iret|Hlt, None, None, None, None) => Ok(FullInstruction {
                i: opcode,
                depls: None,
                imm: None
            }),
            (i@(Pushf|Popf|Ret|Iret|Hlt),_,_,_,_)
                => Err(format!("{i} does not take any operands!")),
            (Jbe|Jb|Jc|Jle|Jl|Je|Jz|Jo|Js|Jpe|Ja|Jae|Jnc|
                Jg|Jge|Jne|Jnz|Jno|Jns|Jpo, None, None, None, Some(x)) => {
                    let x: u8 = x.try_into().map_err(|_| format!("Cannot convert '{x}' into an 8 bit unsigned integer"))?;    
                    opcode.set_port(x.into());
                    Ok(FullInstruction { i: opcode, depls: None, imm: None })
                },
            (i@(Jbe|Jb|Jc|Jle|Jl|Je|Jz|Jo|Js|Jpe|Ja|Jae|Jnc|
                Jg|Jge|Jne|Jnz|Jno|Jns|Jpo),_,_,_,_)
                => Err(format!("{i} only takes an immediate operand!")),
            (Inc|Dec|Neg|Not|Shl|Shr|Sar|Sal|Pop|Push|Call|Jmp, Some(reg), None, None, None) => {
                opcode.set_reg(reg.try_into().unwrap());
                opcode.set_dir(d as u16);
                Ok(FullInstruction { i: opcode, depls: None, imm: None })
            },
            (Inc|Dec|Neg|Not|Shl|Shr|Sar|Sal|Pop|Push|Call|Jmp, None, Some(rm), x, None) => {
                opcode.set_rm(rm.try_into().unwrap());
                opcode.set_dir(d as u16);
                opcode.set_mod(m);
                let x: Option<u16> = x.map(|x| x.try_into().map_err(|_|
                    format!("{x} cannot be converted to unsigned 16 bit"))).transpose()?;
                Ok(FullInstruction {
                    i: opcode,
                    depls: x,
                    imm: None
                })
            },
            (i@(Inc|Dec|Neg|Not|Shl|Shr|Sar|Sal|Pop|Push|Call|Jmp), _,_,_,Some(_))
                => Err(format!("{i} does not support immediate values!")),
            (i@(Inc|Dec|Neg|Not|Shl|Shr|Sar|Sal|Pop|Push|Call|Jmp),Some(_),Some(_),_,None)|
            (i@(Inc|Dec|Neg|Not|Shl|Shr|Sar|Sal|Pop|Push|Call|Jmp),None,None,None,None)
                => Err(format!("{i} only supports one operand!")),
            (Inc|Dec|Neg|Not|Shl|Shr|Sar|Sal|Pop|Push|Call|Jmp,_,None,Some(_),_)
                => Err(format!("We should never reach this point. Contact the developer!")),
            (Mov|Cmp|Test|Add|Adc|Sub|Sbb|And|Or|Xor, Some(reg), Some(rm), x, y) => {
                opcode.set_dir(d as u16);
                opcode.set_mod(m);
                opcode.set_reg(reg.try_into().unwrap());
                opcode.set_rm(rm.try_into().unwrap());
                let x: Option<u16> = x.map(|x| x.try_into().map_err(|_|
                    format!("{x} cannot be converted to unsigned 16 bit"))).transpose()?;
                let y: Option<u16> = y.map(|x| x.try_into().map_err(|_|
                    format!("{x} cannot be converted to unsigned 16 bit"))).transpose()?;

                Ok(FullInstruction { i: opcode, depls: x, imm: y })
            },
            (Mov|Cmp|Test|Add|Adc|Sub|Sbb|And|Or|Xor, None, Some(rm), x, Some(imm)) => {
                opcode.set_dir(d as u16);
                opcode.set_mod(m);
                opcode.set_rm(rm.try_into().unwrap());
                let x: Option<u16> = x.map(|x| x.try_into().map_err(|_|
                    format!("{x} cannot be converted to unsigned 16 bit"))).transpose()?;
                let imm = imm.try_into().map_err(|_|format!("{imm} cannot be converted to unsigned 16 bit"))?;
                Ok(FullInstruction { i: opcode, depls: x, imm: Some(imm) })
            },
            // Tecnhically this should be covered already by a previous branch
            // but we are placing this here for completion's sake
            (Mov|Cmp|Test|Add|Adc|Sub|Sbb|And|Or|Xor, Some(reg), None, None, Some(imm)) => {
                opcode.set_dir(d as u16);
                opcode.set_reg(reg.try_into().unwrap());
                let imm = imm.try_into().map_err(|_|format!("{imm} cannot be converted to unsigned 16 bit"))?;
                Ok(FullInstruction { i: opcode, depls: None, imm: Some(imm) })
            },
            (i @ (Mov|Cmp|Test|Add|Adc|Sub|Sbb|And|Or|Xor),Some(_),None,None,None) |
            (i @ (Mov|Cmp|Test|Add|Adc|Sub|Sbb|And|Or|Xor),None,Some(_),_,None) |
            (i @ (Mov|Cmp|Test|Add|Adc|Sub|Sbb|And|Or|Xor),None,None,None,Some(_)|None)
                => Err(format!("{i} requires at least 2 operands!")),
            (Mov|Cmp|Test|Add|Adc|Sub|Sbb|And|Or|Xor,_,None,Some(_),_)
                => Err(format!("We should never reach this point. Contact the developer!"))
        }

    }
}

fn main() {
    let _labels = HashMap::<String, usize>::new();
    let line_parser = Regex::new(r#"^(?:\s*([a-zA-Z_0-9]+)\s*:)?\s*(?:(.*?);.*|(.*))$"#).unwrap();
    let stmt_parser = Regex::new(r#"^([a-z]+)(?:\s+([^,]+)(?:\s*,\s*([^,]+))?)?$"#).unwrap();
    let equ_parser = Regex::new(r#"^([a-z_][a-z_0-9]*)\s+equ\s+(.*)$"#).unwrap();
    let mut defines = HashMap::<String, String>::new();
    let file = std::fs::read_to_string("hello.asm").unwrap();
    let mut _label_queue = Vec::<String>::new();
    let mut any_error1 = false;
    let mut any_error2 = false;
    let mut any_error3 = false;
    let statements = file.lines().enumerate()
    .map(|(lineno, line)| (lineno, line_parser.captures(line).unwrap()))
    .filter_map(|(lineno, cap)| {
        let [_lbl, com, nocom] = cap.iter()
            .skip(1)
            .map(|m| m.map(|c| c.as_str().trim()))
            .collect::<Vec<_>>().try_into().unwrap();
        let stmt = com.or(nocom).map(|s| if s.is_empty() {None} else {Some(s.to_lowercase())}).unwrap();

        if let Some(stmt) = stmt {
            if let Some(c) = stmt_parser.captures(&stmt) {
    
                Some(Statement {
                    lineno: lineno + 1,
                    line: stmt.to_owned(),
                    mnemonic: c.get(1).unwrap().as_str().to_string(),
                    op1: c.get(2).map(|x| x.as_str().to_string()),
                    op2: c.get(3).map(|x| x.as_str().to_string()),
                })
            } else if let Some(c) = equ_parser.captures(&stmt) {
                let key = c.get(1).unwrap().as_str();
                if defines.contains_key(key) {
                    eprintln!("Redefinition of {key} at line {}\n{}", lineno + 1, stmt);
                    any_error1 = true;
                    None
                } else {
                    defines.insert(key.to_string(), c.get(2).unwrap().as_str().to_string());
                    None
                }
            } else {
                eprintln!("Syntax error on line {}: Line should be of either format:\n<MNEMONIC>\n<MNEMONIC> op1\n<MNEMONIC> op1, op2\nwhere the mnemonic is only formed out of letters\n{}", lineno + 1, stmt);
                any_error1 = true;
                None
            }
        } else {
            None
        }
    })
    .filter_map(|stmt| {
        let line = stmt.line.to_owned();
        let lineno = stmt.lineno;
        match ParsedStatement::from_statement(stmt) {
            Ok(stmt) => Some((line, lineno, stmt)),
            Err(e) => {
                any_error2 = true;
                eprintln!("Error at line {}: {}\n{}", lineno, e, line);
                None
            }
        }
    })
    .map(|(line, lineno, x)| (line, lineno, x.convert_to_instruction()))
    .filter_map(|(line, lineno, instr)| {
        
        match instr {
            Ok(stmt) => Some((line,stmt)),
            Err(e) => {
                any_error3 = true;
                eprintln!("Semantic error at line {}: {}\n{}", lineno, e, line);
                None
            }
        }
    })
    .map(|(line, x)| format!("// {line}\n{x}"))
    .collect::<Vec<_>>();
    if any_error1 || any_error2 || any_error3 {std::process::exit(1)};
    println!("{}", statements.join("\n"));
    
}

