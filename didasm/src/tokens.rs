use regex::Regex;
use strum_macros::EnumString;
use std::{fmt::Display, str::FromStr};
use once_cell::sync::Lazy;
use strum_macros::Display;

use Register::*;
use Mnemonic::*;
use GeneralMnemonic::*;
use ArithmeticMnemonic::*;
use LogicMnemonic::*;
use ShiftMnemonic::*;
use ControlFlowMnemonic::*;
use ConditionalJumpMnemonic::*;
impl From<&Mnemonic> for u16 {
    fn from(value: &Mnemonic) -> Self {
        match value {
            General(m) => u16::from(*m),
            Arithmetic(m) => u16::from(*m),
            Logic(m) => u16::from(*m),
            Shift(m) => u16::from(*m),
            ControlFlow(m) => u16::from(*m),
            ConditionalJump(m) => u16::from(*m)
        }
    }
}

#[derive(Debug, EnumString, Display, Clone, Copy)]
#[strum(serialize_all = "snake_case")]
pub enum GeneralMnemonic {
    Mov,
    Push,
    Pop,
    Pushf,
    Popf,
    In,
    Out,
}

impl From<GeneralMnemonic> for u16 {
    fn from(value: GeneralMnemonic) -> Self {
        match value {
            Mov | In => 0b000,
            Out => 0b001,
            Push | Pushf => 0b010,
            Pop | Popf => 0b011,
        }
    }
}

#[derive(Debug, EnumString, Display, Clone, Copy)]
#[strum(serialize_all = "snake_case")]
pub enum ArithmeticMnemonic {
    Add,
    Adc,
    Inc,
    Sub,
    Sbb,
    Dec,
    Neg,
    Cmp,
}

impl From<ArithmeticMnemonic> for u16 {
    fn from(value: ArithmeticMnemonic) -> Self {
        match value {
            Add | Inc => 0b000,
            Adc | Dec => 0b001,
            Sub | Neg | Cmp => 0b010,
            Sbb => 0b011,
        }
    }
}

#[derive(Debug, EnumString, Display, Clone, Copy)]
#[strum(serialize_all = "snake_case")]
pub enum LogicMnemonic {
    And,
    Or,
    Xor,
    Not,
    Test,
}

impl From<LogicMnemonic> for u16 {
    fn from(value: LogicMnemonic) -> Self {
        match value {
            And | Test => 0b100,
            Or => 0b101,
            Xor => 0b110,
            Not => 0b011
        }
    }
    
}

#[derive(Debug, EnumString, Display, Clone, Copy)]
#[strum(serialize_all = "snake_case")]
pub enum ShiftMnemonic {
    Shl,
    Sal,
    Shr,
    Sar,
}

impl From<ShiftMnemonic> for u16 {
    fn from(value: ShiftMnemonic) -> Self {
        match value {
            Shl | Sal => 0b100,
            Shr => 0b101,
            Sar => 0b110,
        }
    }
}

#[derive(Debug, EnumString, Display, Clone, Copy)]
#[strum(serialize_all = "snake_case")]
pub enum ControlFlowMnemonic {
    Call,
    Ret,
    Iret,
    Jmp,
    Hlt,
}

impl From<ControlFlowMnemonic> for u16 {
    fn from(value: ControlFlowMnemonic) -> Self {
        match value {
            Call | Ret => 0b100,
            Iret | Jmp => 0b010,
            Hlt => 0b110,
        }
    }
}

#[derive(Debug, EnumString, Display, Clone, Copy)]
#[strum(serialize_all = "snake_case")]
pub enum ConditionalJumpMnemonic {
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

impl From<ConditionalJumpMnemonic> for u16 {
    fn from(cj: ConditionalJumpMnemonic) -> u16 {
        match cj {
            Jbe => 0b0000,
            Jb | Jc => 0b0001,
            Jle => 0b0010,
            Jl => 0b0011,
            Je | Jz => 0b0100,
            Jo => 0b0101,
            Js => 0b0110,
            Jpe => 0b0111,
            Ja => 0b1000,
            Jae | Jnc => 0b1001,
            Jg => 0b1010,
            Jge => 0b1011,
            Jne | Jnz => 0b1100,
            Jno => 0b1101,
            Jns => 0b1110,
            Jpo => 0b1111,
        }
    }

}

#[derive(Debug)]
pub enum Mnemonic {
    General(GeneralMnemonic),
    // Arithmetic instructions
    Arithmetic(ArithmeticMnemonic),
    // Logic instructions
    Logic(LogicMnemonic),
    // Shift instructions
    Shift(ShiftMnemonic),
    // Control flow instructions
    ControlFlow(ControlFlowMnemonic),
    // Conditional jump instructions
    ConditionalJump(ConditionalJumpMnemonic),
}

impl FromStr for Mnemonic {
    type Err = String;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        if let Ok(general) = GeneralMnemonic::from_str(s) {
            Ok(Mnemonic::General(general))
        } else if let Ok(arithmetic) = ArithmeticMnemonic::from_str(s) {
            Ok(Mnemonic::Arithmetic(arithmetic))
        } else if let Ok(logic) = LogicMnemonic::from_str(s) {
            Ok(Mnemonic::Logic(logic))
        } else if let Ok(shift) = ShiftMnemonic::from_str(s) {
            Ok(Mnemonic::Shift(shift))
        } else if let Ok(control_flow) = ControlFlowMnemonic::from_str(s) {
            Ok(Mnemonic::ControlFlow(control_flow))
        } else if let Ok(conditional_jump) = ConditionalJumpMnemonic::from_str(s) {
            Ok(Mnemonic::ConditionalJump(conditional_jump))
        } else {
            Err(format!("Invalid mnemonic '{s}'"))
        }
    }
}

impl Display for Mnemonic {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", match self {
            General(m) => m.to_string(),
            Arithmetic(m) => m.to_string(),
            Logic(m) => m.to_string(),
            Shift(m) => m.to_string(),
            ControlFlow(m) => m.to_string(),
            ConditionalJump(m) => m.to_string()
        })
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
            Regex::new("^[a-z_][a-z0-9_]*$").expect("ID regex has a syntax error.")
        });
        let (sgn, s) = if let Some(stripped) = s.strip_prefix("-") {
            (-1, stripped)
        } else {
            (1, s)
        };
        if let Some(stripped) = s.strip_prefix("0b") {
            match isize::from_str_radix(stripped, 2) {
                Ok(x) => Ok(Expr::Int(sgn * x)),
                Err(e) => Err(format!("Invalid binary number '{s}', {e}"))
            }
        } else if let Some(stripped) = s.strip_prefix("0x") {
            match isize::from_str_radix(stripped, 16) {
                Ok(x) => Ok(Expr::Int(sgn * x)),
                Err(e) => Err(format!("Invalid hex number '{s}', {e}"))
            }
        } else {
            match s.chars().nth(0) {
                Some('0'..='9') => match s.parse::<isize>() {
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
            Regex::new(r"^\[\s*\[\s*(.+?)\s*\]\s*\]$").expect("Double indirect regex has a syntax error.")
        });
        static CHECK_OUTER_BRACKETS: Lazy<Regex> = Lazy::new(|| {
            Regex::new(r"^\[\s*(.+)\s*\]$").expect("Outer brackets regex has a syntax error.")
        });
        static CHECK_INSIDE_BRACKETS: Lazy<Regex> = Lazy::new(|| {
            Regex::new(r"^([a-z0-9_]+)\s*\+\s*([a-z0-9_]+)\s*(?:\+\s*([a-z0-9_]+)|([+\-]))?$").expect("Inside brackets regex has a syntax error.")
        });



        if let Some(cap) = CHECK_IF_DOUBLE_INDIRECT.captures(s) {
            let (_, [op]) = cap.extract();
            if Register::from_str(op).is_ok() {
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
                let op1 = RegOrExpr::from_str(cap.get(1)
                    .expect("The check inside brackets regex should always yield an expression.").as_str())?;
                let op2 = RegOrExpr::from_str(cap.get(2)
                    .expect("The check inside brackets regex should always yield an expression.").as_str())?;
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
                        => Err("xb is not supported in autodecrement instructions".to_string()),
                    (Reg( b @ (Ba|Bb) ), Expression(e), None, None) |
                    (Expression(e), Reg( b @ (Ba|Bb) ), None, None) 
                        => Ok(Operand::Based { b, depls: e }),
                    (Reg( x @ (Xa|Xb) ), Expression(e), None, None) |
                    (Expression(e), Reg( x @ (Xa|Xb) ), None, None) 
                        => Ok(Operand::Indexed { x, depls: e }),
                    
    


                    (Reg(_), Reg(_), Some(Reg(_)), _)
                        => Err("Sum between 3 registers is not supported by the ISA".to_string()),
                    (Reg(Ba|Bb), Reg(Ba|Bb), _, _) | (Reg(Xa|Xb), Reg(Xa|Xb), _, _) |
                    (_, Reg(Ba|Bb), Some(Reg(Ba|Bb)), _) | (_, Reg(Xa|Xb), Some(Reg(Xa|Xb)), _) |
                    (Reg(Ba|Bb), _, Some(Reg(Ba|Bb)), _) | (Reg(Xa|Xb), _, Some(Reg(Xa|Xb)), _)
                        => Err("Using the same register group (B/X) between 2 registers is not allowed in an operand".to_string()),
                    (Expression(_), Expression(_), _, _) |
                    (Expression(_),_,Some(Expression(_)), _) |
                    (_, Expression(_), Some(Expression(_)), _)
                        => Err("Sum between 2 or more expressions is not supported by the ISA".to_string()),
                    (Reg(x @ (Ra|Rb|Rc|Is)), _, _, _) |
                    (_, Reg(x @ (Ra|Rb|Rc|Is)), _, _) |
                    (_, _, Some(Reg(x @ (Ra|Rb|Rc|Is))), _)
                        => Err(format!("Register sum syntax does not support register {x}")),
                    _ => Err("Something went wrong! Report the given instruction to the developer for more specific error messages!".to_string())
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