use regex::Regex;
use strum_macros::EnumString;
use std::str::FromStr;
use once_cell::sync::Lazy;
use strum_macros::Display;

use Register::*;
use Mnemonic::*;

impl From<&Mnemonic> for u16 {
    fn from(value: &Mnemonic) -> Self {
        match value {
            In|Mov|Inc|Add|Jbe => 0,
            Out|Dec|Jb|Jc|Adc => 1,
            Pushf|Push|Neg|Jle|Cmp|Sub => 2,
            Popf|Pop|Not|Jl|Sbb => 3,
            Ret|Call|Shl|Sal|Je|Jz|Test|And => 4,
            Iret|Jmp|Shr|Jo|Or => 5,
            Hlt|Sar|Js|Xor => 6,
            Jpe => 7,
            Ja => 8,
            Jae|Jnc => 9,
            Jg => 10,
            Jge => 11,
            Jne|Jnz => 12,
            Jno => 13,
            Jns => 14,
            Jpo => 15
        }
    }
}
#[derive(Debug, EnumString, Display)]
#[strum(serialize_all = "snake_case")]

pub enum Mnemonic {
    // General instructions
    Mov,
    Push,
    Pop,
    Pushf,
    Popf,
    In,
    Out,
    // Arithmetic instructions
    Add,
    Adc,
    Inc,
    Sub,
    Sbb,
    Dec,
    Neg,
    Cmp,
    // Logic instructions
    Not,
    And,
    Or,
    Xor,
    Test,
    // Shift instructions
    Shl,
    Sal,
    Shr,
    Sar,
    // Control flow instructions
    Call,
    Ret,
    Iret,
    Jmp,
    Hlt,
    // Conditional jump instructions
    Jbe,
    Jb,
    Jc,
    Jle,
    Jl,
    Je,
    Jz,
    Jo,
    Js,
    Jpe,
    Ja,
    Jae,
    Jnc,
    Jg,
    Jge,
    Jne,
    Jnz,
    Jno,
    Jns,
    Jpo
}

impl Mnemonic {
    pub fn is_jump(&self) -> bool {
        matches!(self, Jbe|Jb|Jc|Jle|Jl|Je|Jz|Jo|Js|Jpe|Ja|Jae|Jnc|Jg|Jge|Jne|Jnz|Jno|Jns|Jpo)
    }
}

impl From<Register> for usize {
    fn from(value: Register) -> Self {
        match value {
            Ra => 0,
            Rb => 1,
            Rc => 2,
            Is => 3,
            Xa => 4,
            Xb => 5,
            Ba => 6,
            Bb => 7
        }
    }
}

#[derive(Debug, EnumString, Display, Clone, Copy)]
#[strum(serialize_all = "snake_case")]
pub enum Register {
    // General purpose registers
    Ra,
    Rb,
    Rc,
    // Stack pointer
    Is,
    // Index register
    Xa,
    Xb,
    // Base register
    Ba,
    Bb,
}

#[derive(Debug, Clone)]
pub enum Expr {
    // Identifier
    Id(String),
    // Numeric value
    Int(isize)
}

impl FromStr for Expr {
    type Err = String;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        static CHECK_IF_ID: Lazy<Regex> = Lazy::new(|| {
            Regex::new("^[a-z_][a-z0-9_]*$").unwrap()
        });
        let (sgn, s) = if s.starts_with("-") {
            (-1, &s[1..])
        } else {
            (1, s)
        };
        if s.starts_with("0b") {
            match isize::from_str_radix(&s[2..], 2) {
                Ok(x) => Ok(Expr::Int(sgn * x)),
                Err(e) => Err(format!("Invalid binary number '{s}', {e}"))
            }
        } else if s.starts_with("0x") {
            match isize::from_str_radix(&s[2..], 16) {
                Ok(x) => Ok(Expr::Int(sgn * x)),
                Err(e) => Err(format!("Invalid hex number '{s}', {e}"))
            }
        } else {
            match s.chars().nth(0) {
                Some('0'..'9') => match s.parse::<isize>() {
                    Ok(x) => Ok(Expr::Int(sgn * x)),
                    Err(e) => Err(format!("Invalid number '{s}', {e}"))
                },
                None => panic!("We should never have an empty string here"),
                _ => if CHECK_IF_ID.is_match(s) {
                    Ok(Expr::Id(s.to_owned()))
                } else {
                    Err(format!("Invalid identifier '{s}'"))
                }
            }
        }
    }
}

#[derive(Debug, Clone)]
pub enum Operand {
    /// <REG>
    Reg(Register),
    /// <EXPR>
    Imm(Expr),
    /// [<EXPR>]
    Direct(Expr),
    /// [[<EXPR>]]
    Indirect(Expr),
    /// [<REG>]
    RegIndirect(Register),
    /// [<REG>+<REG>]
    /// [<REG>][<REG]
    RegSum {
        b: Register,
        x: Register
    },
    /// [<REG>][<REG>+]
    /// [<REG>+<REG>+]
    RegSumAutoincrement {
        b: Register,
        x: Register
    },
    /// [<REG>][<REG>-]
    /// [<REG>+<REG>-]
    RegSumAutodecrement {
        b: Register,
        // x: Register
    },
    /// [<REG>]+<EXPR>
    /// <EXPR>[<REG>]
    /// [<REG>+<EXPR>]
    /// [<REG>].<EXPR>
    Based {
        b: Register,
        depls: Expr
    },
    /// [<REG>]+<EXPR>
    /// <EXPR>[<REG>]
    /// [<REG>+<EXPR>]
    /// [<REG>].<EXPR>
    Indexed {
        x: Register,
        depls: Expr
    },
    /// [<REG>][<REG>]+<EXPR>
    /// <EXPR>[<REG>][<REG>]
    /// [<REG>+<REG>+<EXPR>]
    /// [<REG>][<REG>].<EXPR>
    BasedIndexed {
        b: Register,
        x: Register,
        depls: Expr
    }
}

use RegOrExpr::*;
enum RegOrExpr {
    Reg(Register),
    Expression(Expr)
}

impl FromStr for RegOrExpr {
    type Err = String;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        if let Ok(reg) = Register::from_str(s) {
            Ok(RegOrExpr::Reg(reg))
        } else {
            Ok(RegOrExpr::Expression(Expr::from_str(s)?))
        }
    }
}

impl FromStr for Operand {
    type Err = String;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        static CHECK_IF_DOUBLE_INDIRECT: Lazy<Regex> = Lazy::new(|| {
            Regex::new(r"^\[\s*\[\s*(.+?)\s*\]\s*\]$").unwrap()
        });
        static CHECK_OUTER_BRACKETS: Lazy<Regex> = Lazy::new(|| {
            Regex::new(r"^\[\s*(.+)\s*\]$").unwrap()
        });
        static CHECK_INSIDE_BRACKETS: Lazy<Regex> = Lazy::new(|| {
            Regex::new(r"^([a-z0-9_]+)\s*\+\s*([a-z0-9_]+)\s*(?:\+\s*([a-z0-9_]+)|([+\-]))?$").unwrap()
        });



        if let Some(cap) = CHECK_IF_DOUBLE_INDIRECT.captures(s) {
            let (_, [op]) = cap.extract();
            if let Ok(_) = Register::from_str(op) {
                Err(format!("This indirect addressing syntax cannot be done on registers! ({op})"))
            } else {
                match Expr::from_str(op) {
                    Ok(s) => Ok(Operand::Indirect(s)),
                    Err(e) => Err(format!("Syntax error on indirect addressing '{op}': {e}"))
                }
            }
        } else if let Some(cap) = CHECK_OUTER_BRACKETS.captures(s) {
            let (_, [op]) = cap.extract();
            if let Ok(reg) = Register::from_str(op) {
                if matches!(reg, Ra|Rb|Rc|Is) {
                    Err(format!("{reg} is not supported in indirect register addresing!"))
                } else {
                    Ok(Operand::RegIndirect(reg))
                }
            } else if let Ok(expr) = Expr::from_str(op) {
                Ok(Operand::Direct(expr))
            } else if let Some(cap) = CHECK_INSIDE_BRACKETS.captures(op) {
                let op1 = RegOrExpr::from_str(cap.get(1).unwrap().as_str())?;
                let op2 = RegOrExpr::from_str(cap.get(2).unwrap().as_str())?;
                let op3 = cap.get(3).map(|x| RegOrExpr::from_str(x.as_str())).transpose()?;
                let sign = cap.get(4).map(|x| x.as_str());
                match (op1, op2, op3, sign) {
                    (Reg( b @ (Ba|Bb) ), Reg( x @ (Xa|Xb) ), None, None) |
                    (Reg( x @ (Xa|Xb) ), Reg( b @ (Ba|Bb) ), None, None)
                        => Ok(Operand::RegSum { b, x }),
                    (Reg( b @ (Ba|Bb) ), Reg( x @ (Xa|Xb) ), Some(Expression(e)), None) |
                    (Reg( x @ (Xa|Xb) ), Reg( b @ (Ba|Bb) ), Some(Expression(e)), None) |
                    (Reg( b @ (Ba|Bb) ), Expression(e), Some(Reg( x @ (Xa|Xb) )), None) |
                    (Reg( x @ (Xa|Xb) ), Expression(e), Some(Reg( b @ (Ba|Bb) )), None) |
                    (Expression(e), Reg( b @ (Ba|Bb) ), Some(Reg( x @ (Xa|Xb) )), None) |
                    (Expression(e), Reg( x @ (Xa|Xb) ), Some(Reg( b @ (Ba|Bb) )), None)
                        => Ok(Operand::BasedIndexed { b, x, depls: e }),
                    (Reg( b @ (Ba|Bb) ), Reg( x @ (Xa|Xb) ), None, Some("+")) |
                    (Reg( x @ (Xa|Xb) ), Reg( b @ (Ba|Bb) ), None, Some("+"))
                        => Ok(Operand::RegSumAutoincrement { b, x }),
                    (Reg( b @ (Ba|Bb) ), Reg( Xa ), None, Some("-")) |
                    (Reg( Xa ), Reg( b @ (Ba|Bb) ), None, Some("-"))
                        => Ok(Operand::RegSumAutodecrement { b }),
                    (Reg(_), Reg( Xb ), None, Some("-")) |
                    (Reg( Xb ), Reg(_), None, Some("-"))
                        => Err(format!("xb is not supported in autodecrement instructions")),
                    (Reg( b @ (Ba|Bb) ), Expression(e), None, None) |
                    (Expression(e), Reg( b @ (Ba|Bb) ), None, None) 
                        => Ok(Operand::Based { b, depls: e }),
                    (Reg( x @ (Xa|Xb) ), Expression(e), None, None) |
                    (Expression(e), Reg( x @ (Xa|Xb) ), None, None) 
                        => Ok(Operand::Indexed { x, depls: e }),
                    
    


                    (Reg(_), Reg(_), Some(Reg(_)), _)
                        => Err(format!("Sum between 3 registers is not supported by the ISA")),
                    (Reg(Ba|Bb), Reg(Ba|Bb), _, _) | (Reg(Xa|Xb), Reg(Xa|Xb), _, _) |
                    (_, Reg(Ba|Bb), Some(Reg(Ba|Bb)), _) | (_, Reg(Xa|Xb), Some(Reg(Xa|Xb)), _) |
                    (Reg(Ba|Bb), _, Some(Reg(Ba|Bb)), _) | (Reg(Xa|Xb), _, Some(Reg(Xa|Xb)), _)
                        => Err(format!("Using the same register group (B/X) between 2 registers is not allowed in an operand")),
                    (Expression(_), Expression(_), _, _) |
                    (Expression(_),_,Some(Expression(_)), _) |
                    (_, Expression(_), Some(Expression(_)), _)
                        => Err(format!("Sum between 2 or more expressions is not supported by the ISA")),
                    (Reg(x @ (Ra|Rb|Rc|Is)), _, _, _) |
                    (_, Reg(x @ (Ra|Rb|Rc|Is)), _, _) |
                    (_, _, Some(Reg(x @ (Ra|Rb|Rc|Is))), _)
                        => Err(format!("Register sum syntax does not support register {x}")),
                    _ => Err(format!("Something went wrong! Report the given instruction to the developer for more specific error messages!"))
                }
                // Err("".to_string())
            } else {
                Err(format!("Syntax error between brackets: '{s}'"))
            }
        } else {
            match RegOrExpr::from_str(s)? {
                Reg(r) => Ok(Operand::Reg(r)),
                Expression(e) => Ok(Operand::Imm(e))
            }
        }
    }
}