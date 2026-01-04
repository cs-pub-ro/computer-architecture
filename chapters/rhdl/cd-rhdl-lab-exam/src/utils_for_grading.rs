use rand::Rng;

use crate::{
    control_unit::{ControlSignals, ExecStage, FetchStage, State},
    decode_unit::Decoded,
    graded_control_unit::{GradedState, decoded_control_unit},
    prelude::*,
};

impl From<&State> for GradedState {
    fn from(s: &State) -> Self {
        match s {
            State::Reset => GradedState::Reset,
            State::Fetch(_) => GradedState::Fetch,
            State::Decode => GradedState::Decode,
            State::LoadEa(_) | State::LoadImm(_) | State::LoadTemps(_) => GradedState::Load,
            State::Exec(_) | State::Nea(_) => GradedState::Execute,
            State::Store => GradedState::Store,
            State::IncPC | State::IncPC1 => GradedState::IncPC,
            State::Hlt => GradedState::Hlt,
        }
    }
}

#[derive(Synchronous, SynchronousDQ, Clone, Debug)]
pub struct GradedControlUnit {
    pub state: DFF<GradedState>,
}

impl Default for GradedControlUnit {
    fn default() -> Self {
        Self {
            state: DFF::new(GradedState::default()),
        }
    }
}

impl GradedControlUnit {
    pub fn new(init: GradedState) -> Self {
        Self {
            state: DFF::new(init),
        }
    }
}

impl SynchronousIO for GradedControlUnit {
    type I = (Decoded, AluFlags);
    type O = ControlSignals;
    type Kernel = decoded_cu_kernel;
}

#[kernel]
pub fn decoded_cu_kernel(_cr: ClockReset, i: (Decoded, AluFlags), q: Q) -> (ControlSignals, D) {
    let (next_state, cs) = decoded_control_unit(i.0, i.1, q.state);
    (cs, D { state: next_state })
}

pub fn grade_fetch(instruction: String) -> Result<u32, RHDLError> {
    let mut grade = 0;
    for i in 0..100 {
        let mut init = CpuDefault::default();
        for i in 0..8 {
            init.regs[i] = i as u128 + 1;
        }
        init.regs[3] = 420 as u128;
        init.PC = i as u128;

        let asm_source = format!(
            "{}\n{}",
            instruction.trim(), // e.g. "add ra, rb"
            "hlt"
        );

        let (cpu, mut s) = start_cpu_test(&asm_source, init.clone())?;

        init.graded_cu_on = 1;

        let (graded_cpu, mut graded_s) = start_cpu_test(&asm_source, init)?;

        let mut counter = 0;
        while cu_state(&s) != State::Decode && counter < 100 {
            step(&cpu, bits(0x0), &mut s);
            counter += 1;
        }
        if counter == 100 {
            eprintln!("Too many steps");
        }

        let mut counter = 0;
        while graded_cu_state(&graded_s) != GradedState::Decode && counter < 100 {
            step(&graded_cpu, bits(0x0), &mut graded_s);
            counter += 1;
        }
        if counter == 100 {
            eprintln!("Too many steps in implementation");
            grade = 0;
            break;
        }

        if pc(&s) == pc(&graded_s) && ma(&s) == ma(&graded_s) && ir(&s) == ir(&graded_s) {
            grade += 1;
        }
    }

    Ok(grade)
}

pub fn grade_load(instruction: String) -> Result<u32, RHDLError> {
    let mut grade = 0;

    for _ in 0..100 {
        let mut init = CpuDefault::default();
        let mut rng = rand::rng();
        for i in 0..8 {
            init.regs[i] = rng.random_range(..100);
        }
        init.regs[3] = 420 as u128;
        init.PC = 0;

        let asm_source = format!(
            "{}\n{}",
            instruction.trim(), // e.g. "add ra, rb"
            "hlt"
        );

        let (cpu, mut s) = start_cpu_test(&asm_source, init.clone())?;
        step(&cpu, bits(0x0), &mut s);

        init.state = State::Decode;
        init.graded_cu_on = 1;

        let (graded_cpu, mut graded_s) = start_cpu_test(&asm_source, init.clone())?;
        step(&graded_cpu, bits(0x0), &mut graded_s);

        let mut counter = 0;
        while GradedState::from(&cu_state(&s)) != GradedState::Execute && counter < 100 {
            step(&cpu, bits(0x0), &mut s);
            counter += 1;
        }
        if counter == 100 {
            eprintln!("Too many steps");
        }

        let mut counter = 0;
        while graded_cu_state(&graded_s) != GradedState::Execute && counter < 100 {
            step(&graded_cpu, bits(0x0), &mut graded_s);
            counter += 1;
        }
        if counter == 100 {
            eprintln!("Too many steps in implementation");
            grade = 0;
            break;
        }

        if t1(&s) == t1(&graded_s) && t2(&s) == t2(&graded_s) {
            grade += 1;
        }
    }

    Ok(grade)
}

pub fn grade_execute(instruction: String) -> Result<u32, RHDLError> {
    let mut grade = 0;

    for _ in 0..100 {
        let mut init = CpuDefault::default();
        let mut rng = rand::rng();
        for i in 0..8 {
            init.regs[i] = rng.random_range(..100);
        }
        init.regs[3] = 420 as u128;
        init.PC = 0;

        init.T1 = rng.random_range(..100);
        init.T2 = rng.random_range(..100);

        let asm_source = format!(
            "{}\n{}",
            instruction.trim(), // e.g. "add ra, rb"
            "hlt"
        );

        let (cpu, mut s) = start_cpu_test(&asm_source, init.clone())?;
        step(&cpu, bits(0x0), &mut s);

        let mut counter = 0;
        while cu_state(&s) != State::Decode && counter < 100 {
            step(&cpu, bits(0x0), &mut s);
            counter += 1;
        }
        if counter == 100 {
            eprintln!("Too many steps");
        }

        init.IR = ir(&s);

        init.state = Exec(ExecStage::ExecStart);

        let (cpu, mut s) = start_cpu_test(&asm_source, init.clone())?;
        step(&cpu, bits(0x0), &mut s);

        init.graded_state = GradedState::Execute;
        init.graded_cu_on = 1;

        let (graded_cpu, mut graded_s) = start_cpu_test(&asm_source, init.clone())?;
        step(&graded_cpu, bits(0x0), &mut graded_s);

        let mut counter = 0;
        while GradedState::from(&cu_state(&s)) != GradedState::Store && counter < 100 {
            step(&cpu, bits(0x0), &mut s);
            counter += 1;
        }
        if counter == 100 {
            eprintln!("Too many steps");
        }

        let mut counter = 0;
        while graded_cu_state(&graded_s) != GradedState::Store && counter < 100 {
            step(&graded_cpu, bits(0x0), &mut graded_s);
            counter += 1;
        }
        if counter == 100 {
            eprintln!("Too many steps in implementation");
            grade = 0;
            break;
        }

        if t1(&s) == t1(&graded_s) {
            grade += 1;
        }
    }

    Ok(grade)
}

pub fn grade_store(instruction: String) -> Result<u32, RHDLError> {
    let mut grade = 0;

    for _ in 0..100 {
        let mut init = CpuDefault::default();
        let mut rng = rand::rng();
        for i in 0..8 {
            init.regs[i] = rng.random_range(..100);
        }
        init.regs[3] = 420 as u128;
        init.PC = 0;

        init.T1 = rng.random_range(..100);
        init.T2 = rng.random_range(..100);

        let asm_source = format!(
            "{}\n{}",
            instruction.trim(), // e.g. "add ra, rb"
            "hlt"
        );

        let (cpu, mut s) = start_cpu_test(&asm_source, init.clone())?;
        step(&cpu, bits(0x0), &mut s);

        let mut counter = 0;
        while cu_state(&s) != State::Decode && counter < 100 {
            step(&cpu, bits(0x0), &mut s);
            counter += 1;
        }
        if counter == 100 {
            eprintln!("Too many steps");
        }

        init.IR = ir(&s);

        init.state = Store;

        let (cpu, mut s) = start_cpu_test(&asm_source, init.clone())?;
        step(&cpu, bits(0x0), &mut s);

        init.graded_state = GradedState::Store;
        init.graded_cu_on = 1;

        let (graded_cpu, mut graded_s) = start_cpu_test(&asm_source, init.clone())?;
        step(&graded_cpu, bits(0x0), &mut graded_s);

        let mut counter = 0;
        while GradedState::from(&cu_state(&s)) != GradedState::IncPC && counter < 100 {
            step(&cpu, bits(0x0), &mut s);
            counter += 1;
        }
        if counter == 100 {
            eprintln!("Too many steps");
        }

        let mut counter = 0;
        while graded_cu_state(&graded_s) != GradedState::IncPC && counter < 100 {
            step(&graded_cpu, bits(0x0), &mut graded_s);
            counter += 1;
        }
        if counter == 100 {
            eprintln!("Too many steps in implementation");
            grade = 0;
            break;
        }

        let mut regs_ok = true;
        for i in 0..8 {
            if rg(&s, i) != rg(&graded_s, i) {
                regs_ok = false;
            }
        }

        // if regs_ok && ram(&s) == ram(&graded_s) {
        if regs_ok {
            grade += 1;
        }
    }

    Ok(grade)
}

pub fn grade_inc(instruction: String) -> Result<u32, RHDLError> {
    let mut grade = 0;
    for _ in 0..100 {
        let mut init = CpuDefault::default();
        for i in 0..8 {
            init.regs[i] = i as u128 + 1;
        }
        init.regs[3] = 420 as u128;
        let mut rng = rand::rng();
        init.PC = rng.random_range(..200);

        init.state = State::IncPC;
        init.graded_state = GradedState::IncPC;

        let asm_source = format!(
            "{}\n{}",
            instruction.trim(), // e.g. "add ra, rb"
            "hlt"
        );

        let (cpu, mut s) = start_cpu_test(&asm_source, init.clone())?;
        step(&cpu, bits(0x0), &mut s);

        init.graded_cu_on = 1;

        let (graded_cpu, mut graded_s) = start_cpu_test(&asm_source, init)?;
        step(&graded_cpu, bits(0x0), &mut graded_s);

        let mut counter = 0;
        while cu_state(&s) != State::Fetch(FetchStage::PcToMA) && counter < 100 {
            step(&cpu, bits(0x0), &mut s);
            counter += 1;
        }
        if counter == 100 {
            eprintln!("Too many steps");
        }

        let mut counter = 0;
        while graded_cu_state(&graded_s) != GradedState::Fetch && counter < 100 {
            step(&graded_cpu, bits(0x0), &mut graded_s);
            counter += 1;
        }
        if counter == 100 {
            eprintln!("Too many steps in implementation");
            grade = 0;
            break;
        }

        if pc(&s) == pc(&graded_s) {
            grade += 1;
        }
    }

    Ok(grade)
}

pub mod pretty {
    pub const RESET: &str = "\x1b[0m";
    pub const BOLD: &str = "\x1b[1m";
    pub const DIM: &str = "\x1b[2m";

    pub const RED: &str = "\x1b[31m";
    pub const GREEN: &str = "\x1b[32m";
    pub const YELLOW: &str = "\x1b[33m";
    pub const CYAN: &str = "\x1b[36m";

    pub fn hr(width: usize) -> String {
        "─".repeat(width)
    }

    pub fn box_title(title: &str) {
        let tlen = title.chars().count();

        let width = (tlen + 6).clamp(24, 80);
        let inner = width - 2;

        let pad = inner.saturating_sub(tlen);

        println!("┌{}┐", hr(inner));
        print!("│{}{}{}{}", BOLD, CYAN, title, RESET);
        println!("{:pad$}│", "", pad = pad);
        println!("└{}┘", hr(inner));
    }

    pub fn bar(done: u32, total: u32, width: usize) -> String {
        if total == 0 {
            return " ".repeat(width);
        }
        let done = done.min(total);
        let filled = ((done as usize) * width) / (total as usize);
        let empty = width.saturating_sub(filled);
        format!("{}{}", "█".repeat(filled), "░".repeat(empty))
    }

    pub fn color_for_pct(pct: f32) -> &'static str {
        if pct >= 0.85 {
            GREEN
        } else if pct >= 0.60 {
            YELLOW
        } else {
            RED
        }
    }

    pub fn line(label: &str, score: u32, total: u32) {
        let pct = if total == 0 {
            0.0
        } else {
            score as f32 / total as f32
        };
        let c = color_for_pct(pct);
        let pct_txt = format!("{:>6.1}%", pct * 100.0);
        let bar_txt = bar(score, total, 24);

        println!(
            "  {DIM}{:<8}{RESET}  {c}{:>3}/{:<3}{RESET}  {c}{}{RESET}  {DIM}{}{RESET}",
            label,
            score,
            total,
            bar_txt,
            pct_txt,
            c = c,
            DIM = DIM,
            RESET = RESET
        );
    }

    pub fn final_grade(score: f32) {
        let pct = score; // 0.0..1.0
        let c = color_for_pct(pct);
        let bar_txt = bar((pct * 100.0).round() as u32, 100, 30);
        println!(
            "\n  {BOLD}Final{RESET}     {c}{:>6.1}%{RESET}  {c}{}{RESET}",
            pct * 100.0,
            bar_txt,
            c = c,
            BOLD = BOLD,
            RESET = RESET
        );
    }
}
