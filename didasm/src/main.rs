use regex::Regex;
#[allow(unused_imports)]
use std::collections::{HashMap, HashSet};

mod codegen;
mod tokens;
use codegen::{Instruction, Ir, ParsedStatement, Statement};
use std::str::FromStr;
use tokens::*;


/// Represents the actions each line of the input file can make
/// Important for moving the cursor and keeping track of labels
#[derive(Debug)]
enum Action {
    SetCursor(usize),
    PushWord(u16),
    PushIr(usize, String, Ir),
    PushLabel(String),
    // Intermediate steps that will eventually be converted to IR
    // We need them because Label, Word and SetCursor need to bypass every other step the statement goes through
    Stmt(Statement),
    ParsedStatement((String, usize, ParsedStatement)),
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if args.len() < 3 {
        eprintln!("Usage: {} <input-filename> <output-filename>", args[0]);
        std::process::exit(1);
    }
    let Ok(file) = std::fs::read_to_string(args[1].clone()) else {
        eprintln!("No such file or directory");
        std::process::exit(2);
    };

    // These should never ever ever fail
    let line_parser = Regex::new(r#"^(?:\s*([a-zA-Z_0-9]+)\s*:)?\s*(?:(.*?);.*|(.*))$"#)
        .expect("Line parser regex was tampered with and has syntax errors");
    let stmt_parser = Regex::new(r#"^([a-z]+)(?:\s+([^,]+)(?:\s*,\s*([^,]+))?)?$"#)
        .expect("Statement parser regex was tampered with and has syntax errors");
    let equ_parser = Regex::new(r#"^([a-z_][a-z_0-9]*)\s+equ\s+(.*)$"#)
        .expect("Equ parser regex was tampered with and has syntax errors");

    // The memory we will be writing to. It might also contain comments in mem_instr that are related to the given memory addresses
    let mut mem: Vec<u16> = (0..1024).map(|i| 0).collect();
    // May also represent separators between each word
    let mut mem_instr: Vec<String> = (0..1024).map(|_| "\n".to_string()).collect();
    // All code implicitly starts at memory address 0
    let mut cursor: usize = 0;

    let mut label_queue = Vec::<String>::new();
    // Needed 3 of these because of borrow checking rules of mutable references inside closures
    let mut any_error1 = false;
    let mut any_error2 = false;
    let mut any_error3 = false;

    // Contains all labels and definitions, we will need a 2 pass system for name resolution
    let mut symtable = HashMap::<String, isize>::new();
    let statements = file.to_lowercase().lines()
    .enumerate()
    .map(|(lineno, line)| (lineno, line_parser.captures(line)
        .expect("Line parser regex was tampered with. It is supposed to match anything, it's capture groups are the ones that are allowed to fail")))
    // We will return a vector of actions for each line, which will be flattened later
    // This is due to the fact that a line can contain both a label and a statement, both of which generate an action
    .filter_map(|(lineno, cap)| {
        // Line is organized in label and statement; The statement might either contain a comment which will be filtered by the regex
        // or will not contain any comment, in either case it is one or another that will be non null but never both non-null or null
        // The non-null branch captured by the regex will be the statement moving forward
        let [lbl, com, nocom] = cap.iter()
            .skip(1)
            .map(|m| m.map(|c| c.as_str().trim()))
            .collect::<Vec<_>>().try_into().unwrap_or([None; 3]);
        // We combine both the comment and no comment branches. It is impossible for neither to exist, therefore we panic if it happens
        // This is done because if the regex was modified accidentally, it might not detect the statement properly
        let stmt = com.or(nocom).filter(|s| !s.is_empty());

        let mut v: Vec<Action> = Vec::new();
        if let Some(l) = lbl {
            match Expr::from_str(l) {
                Ok(Expr::Id(id)) => {
                    // We make sure to always evaluate label first, otherwise labels
                    // on the same line will be considered to exist after the statement
                    v.push(Action::PushLabel(id.to_owned()));
                },
                // An integer as a label will represent the memory location of everything that will follow it
                Ok(Expr::Int(i)) => {
                    if i.is_negative() {
                        eprintln!("Line {}: Negative numbers are not allowed as labels", lineno + 1);
                        any_error1 = true;
                    } else {
                        v.push(Action::SetCursor(i as usize));
                    }
                }
                Err(_) => {}
            }
        }

        // Parse statements as either equ, instruction or arbitrary word
        if let Some(stmt) = stmt {
            // Evaluate equ statements first, as the identifier might be seen as an invalid mnemonic in later stage
            if let Some(c) = equ_parser.captures(&stmt) {
                let key = c.get(1).expect("Equ parser regex was tampered with and no longer detects key properly: {lineno}").as_str();
                if symtable.contains_key(key) {
                    eprintln!("Redefinition of {key} at line {}\n{}", lineno + 1, stmt);
                    any_error1 = true;
                } else {
                    let _ = c.get(2).expect("Equ parser regex was tampered with and no longer detects definition value properly: {lineno}")
                        .as_str().parse::<isize>()
                        .inspect_err(|_| {
                            any_error1 = true;
                            eprintln!("Cannot convert to integer in expression at {}", lineno + 1)
                        })
                        .map(|x| symtable.insert(key.to_string(), x));
                }
            } else if let Some(c) = stmt_parser.captures(&stmt) {
                v.push(Action::Stmt(Statement {
                    lineno: lineno + 1,
                    line: stmt.to_owned(),
                    mnemonic: c.get(1).expect("Statement parser regex was tampered with and no longer detects mnemonics properly: {lineno}")
                        .as_str().to_string(),
                    op1: c.get(2).map(|x| x.as_str().to_string()),
                    op2: c.get(3).map(|x| x.as_str().to_string()),
                }));
            } else if let Ok(Expr::Int(x)) = Expr::from_str(&stmt) {
                v.push(Action::PushWord(x as u16));
            } else {
                eprintln!("Syntax error on line {}: Line should be of either format:\n<MNEMONIC>\n<MNEMONIC> op1\n<MNEMONIC> op1, op2\nwhere the mnemonic is only formed out of letters\n{}", lineno + 1, stmt);
                any_error1 = true;
            }
        };
        (!v.is_empty()).then_some(v)
    })
    .flat_map(|x| x.into_iter())
    .filter_map(|stmt| {
        // Bypass label, word and setcursor actions, since they no longer need to be modified
        let Action::Stmt(stmt) = stmt else {return Some(stmt)};
        let line = stmt.line.to_owned();
        let lineno = stmt.lineno;
        // Parsing statement into operands. Up until this point we do not check for semantic errors such as multiple memory operands
        // or invalid immediate values as source operands
        // However we check the overall lexical structure of each operand
        match ParsedStatement::from_statement(stmt) {
            Ok(stmt) => Some(Action::ParsedStatement((line, lineno, stmt))),
            Err(e) => {
                any_error2 = true;
                eprintln!("Error at line {}: {}\n{}", lineno, e, line);
                None
            }
        }
    })
    .filter_map(|stmt| {
        // Bypass label, word and setcursor actions, since they no longer need to be modified
        let Action::ParsedStatement((line, lineno, stmt)) = stmt else {return Some(stmt)};
        // Some semantic analysis is done here, such as checking if there are too many memory operands
        match Ir::from_parsed_statement(stmt) {
            Ok(stmt) => Some(Action::PushIr(lineno, line,stmt)),
            Err(e) => {
                any_error3 = true;
                eprintln!("Semantic error at line {}: {}\n{}", lineno, e, line);
                None
            }
        }
    })
    .collect::<Vec<_>>();
    if any_error1 || any_error2 || any_error3 {
        std::process::exit(1)
    };
    // Name resolution step. We need to know the memory location of each label before we can convert the IR to machine code
    for action in statements.iter() {
        match action {
            Action::PushIr(_, _, ir) => {
                for i in label_queue.iter() {
                    symtable.insert(i.to_owned(), cursor as isize);
                }
                label_queue.clear();
                // We "simulate" the memory usage of the instruction
                // This is not correct all the times, but it is correct for all code that does not return an error
                let words = ir.peek_word_count();
                cursor += words;
            }
            // The moment you set a cursor, all labels before it are considered to be after the last instruction before cursor change
            // Exampple: 
            // ```
            // mov a, b
            // after_a: ; This is the memory location right after the instruction mov a, b
            // 0xFF:
            // after_ff: ; This is the memory location right after the memory cursor change (0xFF)
            // ```
            Action::SetCursor(x) => {
                for i in label_queue.iter() {
                    symtable.insert(i.to_owned(), cursor as isize);
                }
                label_queue.clear();
                cursor = *x;
            }
            // One single word pushed to memory, acts like an instruction in the sense that a label may be placed before it
            Action::PushWord(_) => {
                for i in label_queue.iter() {
                    symtable.insert(i.to_owned(), cursor as isize);
                }
                label_queue.clear();

                cursor += 1;
            }
            // There may be multiple labels before an instruction (silly, i know, but it is possible)
            Action::PushLabel(x) => {
                label_queue.push(x.to_owned());
            }
            _ => {}
        }
    }
    let mut prev_labels = String::new();
    let mut any_error = false;
    cursor = 0;

    for action in statements {
        match action {
            Action::PushIr(lineno, line, ir) => {
                // Final step in conversion, now we know all identifiers and their values
                match ir.convert_to_instruction(&symtable, cursor) {
                    Err(e) => {
                        any_error = true;
                        eprintln!("Semantic error at line {}: {}\n{}", lineno, e, line)
                    }
                    Ok(instr) => {
                        mem_instr[cursor] = format!(
                            "{}\n// {line}{}\n",
                            prev_labels,
                            // a tribute to cioc's description of my code
                            if let Some("--beautiful") = args.get(3).map(|x| x.as_str()) {
                                format!(
                                    " (type_opcode_d_mod_reg_rm:{})",
                                    Instruction(instr.get_i())
                                )
                            } else {
                                "".to_string()
                            }
                        );
                        prev_labels.clear();
                        mem[cursor] = instr.get_i();
                        cursor += 1;
                        if let Some(x) = instr.displacement {
                            mem_instr[cursor] = " ".to_string(); // Space instead of newline to see which words are part of the same instruction
                            mem[cursor] = x;
                            cursor += 1;
                        }
                        if let Some(x) = instr.imm {
                            mem_instr[cursor] = " ".to_string(); // Space instead of newline to see which words are part of the same instruction
                            mem[cursor] = x;
                            cursor += 1;
                        }
                    }
                }
            }
            // Not an important step to the binary produced but useful for tracing back the original program
            Action::PushLabel(x) => {
                prev_labels.push_str(format!("\n// {x}:").as_str());
            }
            // Analogue step to PushWord in label resolution step, but this time for consuming the comments generated by them
            Action::PushWord(x) => {
                mem[cursor] = x;
                mem_instr[cursor] = if prev_labels.is_empty() { "\n".to_string() } else { prev_labels.clone() };
                cursor += 1;
            }
            // Analogue step to SetCursor in label resolution step, but this time for consuming the comments generated by them
            Action::SetCursor(x) => {
                mem_instr[cursor] = if prev_labels.is_empty() { "\n".to_string() } else { prev_labels.clone() };
                cursor = x;
            }
            _ => {}
        }
    }
    if any_error {
        std::process::exit(1)
    };
    // Write the memory addresses and the comments associated with them
    let statements = mem
        .iter()
        .zip(mem_instr.iter())
        .map(|(word, comment)| {
            let word = format!("{:04X}", word);
            let comment = comment.as_str();
            format!(
                "{}{}",
                if let Some("--quiet") = args.get(3).map(|x| x.as_str()) {
                    "\n"
                } else {
                    comment
                },
                word
            )
        })
        .collect::<Vec<_>>()
        .join("");
    if std::fs::write(args[2].clone(), &statements).is_err() {
        eprintln!("Error writing to {}", args[2].clone());
    }
}
