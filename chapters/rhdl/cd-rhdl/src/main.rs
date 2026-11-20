mod alu;
mod control_unit;
mod cpu;
mod decode_unit;
mod memory;
mod prelude;
mod register;
mod register_file;
mod io_unit;

use crate::prelude::*;
use termion::{
    event::Key,
    input::TermRead,
    raw::IntoRawMode,
    screen::IntoAlternateScreen
};
use std::io::{Write, stdout};
use std::fs::File;



// run in an interactive way
fn sim_cpu() -> Result<(), RHDLError> {
    let mut init = CpuDefault::default();
    for i in 0..8 {
        init.regs[i] = i as u128 + 1;
    }
    init.regs[3] = 420 as u128;
    init.PC = 0;
    let (cpu, mut s) = start_cpu_test(
        r#"
            mov bb, here
            call bb
            add ra,rc
            mov bb, after
            jmp bb


            here: add ra, rb
            ret
            after: hlt

        "#,
        init
    )?;
    let mut v = vec![];
    let mut i:usize = 0;
    let mut screen = stdout()
    .into_raw_mode()
    .unwrap()
    .into_alternate_screen()
    .unwrap();

    // print_cd(&s, &o);
    let stdin = std::io::stdin();
    let mut peek = 0;
    let mut peek_buf = peek;
    let mut wait_for_peek = false;
    let mut dump_ram = true;
    let o = step(&cpu, bits(0x0), &mut s);
    v.push((o,s.clone()));
    write!(screen, "{}", termion::clear::All)?;
    write!(screen, "{}", termion::cursor::Goto(1, 1))?;
    screen.flush()?;
    let help_str = "Press ← → for single clock cycle step, p n for instruction step, d for mem.dump or q; Press /<addr(HEX)><enter> for a peek in ram ";
    write!(screen, "{}(step {}, lookup MA)\r\n", help_str, i);
    let (o,state) = &v[if i >= v.len() {v.len() - 1} else {i}];
    let myst = print_cd(state, o, peek);
    write!(screen, "{}",myst);
    for key in stdin.keys() {
        write!(screen, "{}", termion::clear::All)?;
        write!(screen, "{}", termion::cursor::Goto(1, 1))?;
        screen.flush()?;
        match key.unwrap() {
            Key::Left => {
                i = i.saturating_sub(1);
                let (_,state) = &v[i];
                peek = ma(&state);
                peek_buf = peek & 0x3FF;
                wait_for_peek = false;
                // let myst = print_cd(state, o, peek);
                // write!(screen, "{}",myst);
            }
            Key::Right => {
                if i == v.len() {
                    let o = step(&cpu, bits(0x0), &mut s);
                    v.push((o,s.clone()));
                }
                let (_,state) = &v[i];
                peek = ma(&state);
                peek_buf = peek & 0x3FF;
                wait_for_peek = false;
                // let myst = print_cd(state, o, peek);
                // write!(screen, "{}",myst);
                i = i + 1
            }
            Key::Char('q') => break,
            Key::Char('/') => {
                wait_for_peek=true;
                peek_buf = 0;
            }
            Key::Char('n') => {
                let mut steps = 0;
                wait_for_peek = false;
                if i != v.len() {
                    i = i + 1;
                }
                loop {
                    if steps >= 10000  {
                        break;
                    }
                    if i == v.len() {
                        let o = step(&cpu, bits(0x0), &mut s);
                        v.push((o,s.clone()));
                    }
                    let (_,state) = &v[i];
                    peek = ma(&state);
                    if matches!(cu_state(&state), Decode|Reset|Hlt) {
                        break;
                    }
                    i = i + 1;
                    steps = steps + 1;
                };
            }
            Key::Char('p') => {
                wait_for_peek = false;
                let mut steps = 0;
                i = i.saturating_sub(1);
                loop {
                    if steps >= 10000 {
                        break;
                    }
                    let (_,state) = &v[i];
                    peek = ma(&state);
                    if matches!(cu_state(&state), Decode|Reset|Hlt) {
                        break;
                    }
                    i = i.saturating_sub(1);
                    steps = steps + 1;
                }
            }
            Key::Char(c @ ('0'..='9' | 'a'..='f')) if wait_for_peek => {
                let x = c.to_digit(16).map(|d| d as u128).unwrap();
                peek_buf = (peek_buf << 4 | x) & 0x3FF;
            }
            Key::Char('d') => {
                dump_ram = true;
            }
            Key::Char('\n') => {
                wait_for_peek=false;
                peek = peek_buf;

            }
            _ => {}
        }
        
        let (o,state) = &v[if i >= v.len() {v.len() - 1} else {i}];
        if dump_ram {
            let mut file = File::create("mem.dump")?;
            let ram = ram(&state);
            for value in ram.into_iter() {
                writeln!(&mut file, "{:04X}", value)?;
            }
            dump_ram = false;
        }
        let peek_str = format!("{:03X}", peek);
        write!(screen, "{}(step {}, lookup {}{})\r\n", help_str, i, if peek == ma(&state) {
            "MA"
        } else {
            &peek_str
        }, if wait_for_peek {
            format!("; next lookup {:03X}, press enter to commit, accepts [0-3FF]", peek_buf)
        } else {
            "".to_string()
        })?;
        let myst = print_cd(state, o, peek);
        write!(screen, "{}",myst);
    }

    Ok(())
}


fn main() {
    // let reg = RegFile::<U16>::default();
    // let mut s = reg.init();
    // println!("{}",s.0.binary_string());
    // let _ = reg.sim(ClockReset { clock: clock(true), reset: reset(false) }, (RegInput::<U16> { data_in: Bits::from(69), oe: false, we: true }, RA), &mut s);
    // println!("{}",s.0.binary_string());

    // let _ = reg.sim(ClockReset { clock: clock(false), reset: reset(false) }, (RegInput::<U16> { data_in: Bits::from(69), oe: false, we: true }, RA), &mut s);
    // let _ = reg.sim(ClockReset { clock: clock(true), reset: reset(false) }, (RegInput::<U16> { data_in: Bits::from(69), oe: false, we: false }, RA), &mut s);
    // println!("{}",s.0.);
    // let x: Vec<(RegInput<U16>,Reg)> = Vec::new();
    // let x = x.with_reset(1).clock_pos_edge(100);
    if let Err(e) = sim_cpu() {
        println!("{}", miette_report(e));
    }
    // sim_cpu();
}
