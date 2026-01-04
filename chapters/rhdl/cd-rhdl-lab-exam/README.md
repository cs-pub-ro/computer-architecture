# CD RHDL Lab Exam — Checker README

This project contains a checker + visual simulator for the **graded control unit** lab exam.

The checker compares your implementation against a reference solution by running multiple randomized tests for a **given instruction**.

---

## What you are allowed to edit

You are only allowed to modify this file:

```
computer-architecture/chapters/rhdl/cd-rhdl-lab-exam/src/graded_control_unit.rs
```

**Do not modify any other files.** The checker will be run on a clean repository where only that file is replaced.

---

## Required `GradedState` variants

You must keep the existing variants exactly as they are:

```rust
#[derive(Digital, PartialEq, Debug, Default)]
pub enum GradedState {
    #[default]
    Reset,
    Fetch,
    Decode,
    Load,
    Execute,
    Store,
    IncPC,
    Hlt,
}
```

✅ You **may add extra states** (for example `Fetch1`, `Fetch2`, etc.) if you need multiple micro-steps.

✅ You **may change the transitions and control signals** produced by your graded control unit.

❌ You **may not remove** or rename the required variants.

---

## How to run

All interactions with the checker happen through `cargo run` with one of two modes:

- `--test "<instruction>"` : interactive/visual simulation (useful for debugging)
- `--grade "<instruction>"` : grades your implementation against the reference

> Important: the instruction must be passed in quotes (`"..."`).

---

## Visual simulation mode (`--test`)

Use this while developing: it runs your CPU and shows a step-by-step visual environment in the terminal.

Example:

```bash
cargo run -- --test "add ra, rc"
```

### Controls in the visual environment

- `→` : step one clock cycle forward
- `←` : step one clock cycle back (history)
- `n` : jump forward to the next “instruction boundary”
- `p` : jump backward to the previous “instruction boundary”
- `d` : dump memory to `mem.dump`
- `/` then type a hex address then `Enter` : peek RAM at that address
- `q` : quit

This mode is meant for debugging your FSM/state transitions and the control signals you generate.

---

## Grading mode (`--grade`)

Use this to run the checker. It executes multiple randomized tests and compares your behavior with the reference solution.

Example:

```bash
cargo run -- --grade "add rc, rb"
```

You can also simulate (without grading) like this:

```bash
cargo run -- --test "add ra, rc"
```

The checker prints per-stage results (Fetch / Load / Execute / Store / IncPC) and a final score.

---

## What instruction should I use?

While practicing locally, you can choose any supported instruction and pass it as a string:

```bash
cargo run -- --grade "add rc, rb"
cargo run -- --test  "add ra, rc"
```

For the **final exam**, the instruction you must use will be provided by the Moodle assignment (it will be generated per student).
Copy that instruction **exactly** and pass it in quotes to `--grade` and/or `--test`.

---

## Common mistakes

- Forgetting to keep the required `GradedState` variants (`Reset`, `Fetch`, `Decode`, `Load`, `Execute`, `Store`, `IncPC`, `Hlt`)
- Editing files outside `src/graded_control_unit.rs`
- Running without quotes around the instruction:
  - ✅ `--grade "add rc, rb"`
  - ❌ `--grade add rc, rb`

---

