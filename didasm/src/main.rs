use regex::Regex;
#[allow(unused_imports)]
use std::collections::{HashMap, HashSet};

mod tokens;
mod codegen;
use tokens::*;
use std::str::FromStr;
use codegen::{Ir, Instruction, ParsedStatement, Statement};



#[derive(Debug)]
enum Action {
    SetCursor(usize),
    PushWord(u16),
    PushIr(usize, String, Ir),
    PushLabel(String),
    Stmt(Statement),
    ParsedStatement((String, usize, ParsedStatement)),
}

fn main() {
    let _labels = HashMap::<String, isize>::new();
    let args: Vec<String> = std::env::args().collect();
    if args.len() < 3 {
        eprintln!("Usage: {} <input-filename> <output-filename>", args[0]);
        std::process::exit(1);
    }
    // These should never ever ever fail
    let line_parser = Regex::new(r#"^(?:\s*([a-zA-Z_0-9]+)\s*:)?\s*(?:(.*?);.*|(.*))$"#)
        .expect("Line parser regex was tampered with and has syntax errors");
    let stmt_parser = Regex::new(r#"^([a-z]+)(?:\s+([^,]+)(?:\s*,\s*([^,]+))?)?$"#)
        .expect("Statement parser regex was tampered with and has syntax errors");
    let equ_parser = Regex::new(r#"^([a-z_][a-z_0-9]*)\s+equ\s+(.*)$"#)
        .expect("Equ parser regex was tampered with and has syntax errors");

    let mut mem: Vec<u16> = (0..1024).map(|_| 0).collect();
    let mut mem_instr: Vec<Option<String>> = (0..1024).map(|_| None).collect();
    let mut cursor: usize = 0;
    let Ok(file) = std::fs::read_to_string(args[1].clone()) else {
        eprintln!("No such file or directory");
        std::process::exit(2);
    };
    let mut label_queue = Vec::<String>::new();
    // Needed 3 of these because of borrow checking rules of mutable references inside closures
    let mut any_error1 = false;
    let mut any_error2 = false;
    let mut any_error3 = false;
    let mut symtable = HashMap::<String, isize>::new();
    let statements = file.lines().enumerate()
    .map(|(lineno, line)| (lineno, line_parser.captures(line)
        .expect("Line parser regex was tampered with. It is supposed to match anything, it's capture groups are the ones that are allowed to fail")))
    .filter_map(|(lineno, cap)| {
        let [lbl, com, nocom] = cap.iter()
            .skip(1)
            .map(|m| m.map(|c| c.as_str().trim()))
            .collect::<Vec<_>>().try_into().unwrap_or([None; 3]);
        let stmt = com.or(nocom).map(|s| if s.is_empty() {None} else {Some(s.to_lowercase())})
            .expect("Somehow at line {lineno}, code does not detect the statement properly\n{line}\nContact the developer.");
        let mut v: Vec<Action> = Vec::new();
        match lbl {
            Some(l) => match Expr::from_str(l) {
                Ok(Expr::Id(id)) => {
                    v.push(Action::PushLabel(id.to_owned()));
                },
                Ok(Expr::Int(i)) => {
                    if i.is_negative() {
                        eprintln!("Line {}: Negative numbers are not allowed as labels", lineno + 1);
                        any_error1 = true;
                    } else {
                        v.push(Action::SetCursor(i as usize));
                    }
                }
                Err(_) => {}
            },
            None => {}
        }
        if let Some(stmt) = stmt {
            if let Some(c) = equ_parser.captures(&stmt) {
                let key = c.get(1).expect("Equ parser regex was tampered with and no longer detects key properly: {lineno}").as_str();
                if symtable.contains_key(key) {
                    eprintln!("Redefinition of {key} at line {}\n{}", lineno + 1, stmt);
                    any_error1 = true;
                } else {
                    let mut e = false;
                    let _ = c.get(2).expect("Equ parser regex was tampered with and no longer detects definition value properly: {lineno}")
                        .as_str().parse::<isize>()
                        .inspect_err(|_| {
                            e = true;
                            eprintln!("Cannot convert to integer in expression at {}", lineno + 1)
                        })
                        .map(|x| symtable.insert(key.to_string(), x));
                    any_error1 = any_error1 || e;
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
        (!v.is_empty()).then(|| v)
    })
    .flat_map(|x| x.into_iter())
    .filter_map(|stmt| {
        let Action::Stmt(stmt) = stmt else {return Some(stmt)};
        let line = stmt.line.to_owned();
        let lineno = stmt.lineno;
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
        let Action::ParsedStatement((line, lineno, stmt)) = stmt else {return Some(stmt)};
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
    if any_error1 || any_error2 || any_error3 {std::process::exit(1)};
    for action in statements.iter() {
        match action {
            Action::PushIr(_, _, ir) => {
                for i in label_queue.iter() {
                    symtable.insert(i.to_owned(), cursor as isize);
                }
                label_queue.clear();
                let words = ir.peek_word_count();
                cursor += words;
            },
            Action::SetCursor(x) => {
                for i in label_queue.iter() {
                    symtable.insert(i.to_owned(), cursor as isize);
                }
                label_queue.clear();
                cursor = *x;
            },
            Action::PushWord(_) => {
                for i in label_queue.iter() {
                    symtable.insert(i.to_owned(), cursor as isize);
                }
                label_queue.clear();

                cursor += 1;
            },
            Action::PushLabel(x) => {
                label_queue.push(x.to_owned());
            },
            _ => {}
        }
    }
    let mut prev_labels = String::new();
    let mut any_error = false;
    cursor = 0;
    for action in statements {
        match action {
            Action::PushIr(lineno, line, ir) => {
                match ir.convert_to_instruction(&symtable, cursor){
                    Err(e) => {
                        any_error = true;
                        eprintln!("Semantic error at line {}: {}\n{}", lineno, e, line)
                    },
                    Ok(instr) => {
                        mem_instr[cursor] = Some(format!("{}// {line}{}\n", prev_labels,
                        if let Some("--beautiful") = args.get(3).map(|x| x.as_str()) { // a tribute to cioc's description of my code
                            format!(" (type_opcode_d_mod_reg_rm:{})", Instruction(instr.get_i()).to_string())
                        } else {"".to_string()}));
                        prev_labels.clear();
                        mem[cursor] = instr.get_i();
                        cursor += 1;
                        if let Some(x) = instr.depls {
                            mem[cursor] = x;
                            cursor += 1;
                        }
                        if let Some(x) = instr.imm {
                            mem[cursor] = x;
                            cursor += 1;
                        }
                    }

                }
                
                
            },
            Action::PushLabel(x) => {
                prev_labels.push_str(format!("// {x}:\n").as_str());
            },
            Action::PushWord(x) => {
                mem[cursor] = x;
                mem_instr[cursor] = (!prev_labels.is_empty()).then(|| {
                    let res = prev_labels.clone();
                    prev_labels.clear();
                    res
                });
                cursor += 1;
            },
            Action::SetCursor(x) => {
                mem_instr[cursor] = (!prev_labels.is_empty()).then(|| {
                    let res = prev_labels.clone();
                    prev_labels.clear();
                    res
                });
                cursor = x;
            },
            _ => {}
        }
    }
    if any_error {std::process::exit(1)};
    let statements = mem.iter().zip(mem_instr.iter())
        .map(|(word, comment)| {
            let word = format!("{:04X}", word);
            let comment = comment.as_ref().map(|x| x.as_str()).unwrap_or("");
            format!("{}{}", if let Some("--quiet") = args.get(3).map(|x| x.as_str()) {""} else {comment}, word)
        }).collect::<Vec<_>>().join("\n");
    if let Err(_) = std::fs::write(args[2].clone(), &statements) {
        eprintln!("Error writing to {}", args[2].clone());
    }
    
}

