use crate::{decode_unit::{Decoded, DstOperand, OneOp, Operand, TwoOp}, prelude::*};

#[derive(Digital, PartialEq, Debug)]
pub struct ControlSignals {
    pub rf_sel: Reg,
    pub rf_oe: bool,
    pub rf_we: bool,
    pub t1_oe: bool,
    pub t1_we: bool,
    pub t2_oe: bool,
    pub t2_we: bool,
    pub ma_oe: bool,
    pub ma_we: bool,
    pub ram_oe: bool,
    pub ram_we: bool,
    pub alu_carry: bool,
    pub alu_oe: bool,
    pub alu_sel: AluOp,
    pub pc_we: bool,
    pub pc_oe: bool,
    pub ir_we: bool,
    pub ir_oe: bool,
    pub fr_we: bool,
    pub fr_oe: bool,
    pub fr_sel_bus: bool,
}

#[derive(Digital, PartialEq, Debug, Default)]
pub enum FetchStage {
    PcToMA,
    MaToMem,
    MemToIr
}

#[derive(Digital, PartialEq, Debug, Default)]
pub enum LoadEaStage {
    Init,
    LoadDa,
    LoadIda,
    LoadIda1,
    LoadIda2,
    LoadRs1,
    LoadRsi,
    LoadRsd,
    LoadRsa,
}

#[derive(Digital, PartialEq, Debug, Default)]
pub enum State {
    #[default]
    Reset,
    Fetch(FetchStage),
    Decode,
    // Effective addres starting point
    LoadEa(LoadEaStage),
    // Immediate operand starting point
    LoadImm,
    // Only register starting point
    LoadRegs,

    LoadCf,
    LoadJc,
    IncPC,
    IncPC1,
    Hlt,
}

#[derive(Synchronous, SynchronousDQ, Clone, Debug)]
pub struct ControlUnit {
    state: DFF<State>,
}

impl Default for ControlUnit {
    fn default() -> Self {
        Self {
            state: DFF::new(State::default()),
        }
    }
}

impl SynchronousIO for ControlUnit {
    type I = (Decoded, AluFlags);
    type O = ControlSignals;
    type Kernel = cu_kernel;
}


#[kernel]
fn has_imm(i: Decoded) -> bool {
    if let Decoded::TwoOp { op: _x, src: _x3 @ Operand::Imm , dst: _x2 } = i {
        true
    } else if let Decoded::OneOp {op: _x1 @ OneOp::MovI, dst: _x} = i {
        true
    } else {
        false
    }
}

#[kernel]
fn extract_ea(i: Decoded) -> Option<DstOperand> {
    match i {
        Decoded::TwoOp { op: _x, src: _x3 @ Operand::Imm, dst} => {
            if let DstOperand::Reg(_r1) = dst {
                None
            } else {
                Some(dst)
            }
        }
        Decoded::TwoOp { op: _x, src, dst } => {
            // Imm covered by arm above
            if let Operand::MaybeDst(src) = src {
                if let DstOperand::Reg(_r) = src {
                    if let DstOperand::Reg(_r1) = dst {
                        None
                    } else {
                        Some(dst)
                    }
                } else {
                    Some(src)
                }
            } else {None}
        }
        Decoded::OneOp { op: _x, dst } => {
            if let DstOperand::Reg(_r1) = dst {
                None
            } else {
                Some(dst)
            }
        }
        _ => None
    }
}

// #[kernel]
// fn extract_ir_postinc(i: Decoded) -> Option<Reg> {
//     if let Some(x) = extract_ea(i) {
//         if let DstOperand::RegSumIncr(_ba, ia) = i {
//             Some(itr(ia))
//         } else {
//             None
//         }
//     } else { None };
// }

#[kernel]
pub fn cu_kernel(_cr: ClockReset, _i: (Decoded, AluFlags), q: Q) -> (ControlSignals, D) {
    let mut cs = ControlSignals {
        rf_sel: RA,
        rf_oe: false,
        rf_we: false,
        t1_oe: false,
        t1_we: false,
        t2_oe: false,
        t2_we: false,
        ma_oe: false,
        ma_we: false,
        ram_oe: false,
        ram_we: false,
        alu_carry: false,
        alu_oe: false,
        alu_sel: ADC,
        pc_we: false,
        pc_oe: false,
        ir_we: false,
        ir_oe: false,
        fr_we: false,
        fr_oe: false,
        fr_sel_bus: false,
    };
    let next_state = match q.state {
        State::Reset => Fetch,
        Fetch => {
            cs.pc_oe = true;
            cs.ma_we = true;
            Fetch1
        },
        Fetch1 => {
            cs.ma_oe = true;
            Fetch2
        },
        Fetch2 => {
            cs.ram_oe = true;
            cs.ir_we = true;
            Decode
        },
        Decode => {
            let eastate = if let Some(_x) = extract_ea(_i.0) {
                LoadEa
            } else if has_imm(_i.0) {
                LoadImm
            } else {
                LoadRegs
            };
            match _i.0 {
                Decoded::TwoOp {op:_x,dst:_x2,src:_x3} => eastate,
                Decoded::OneOp {op:_x,dst:_x2} => eastate,
                Decoded::CfNea(_x) => LoadCf,
                Decoded::Jcond(_x) => LoadJc,
                Decoded::Invalid => Hlt,
            }
        },
        // Handles the beginning of EA.
        // At this stage's beginning the assumptions are:
        // If disp => PC = &disp - 1
        // At this stage's end the assumptions are:
        // if dst => T1 = ea
        // else => T2 = ea
        // if disp => PC = PC + 1
        // LoadEa => {
        //     let ea = extract_ea(_i.0);
        //     if let Some(ea) = ea {
        //         match ea {
        //             // [disp]
        //             // Should MA, PC = PC + 1
        //             DstOperand::DirectAddress => {
        //                 cs.pc_oe = true;
        //                 cs.t1_we = true;
        //                 LoadDa
        //             }
        //             DstOperand::IndirectAddress => {
        //                 cs.pc_oe = true;
        //                 cs.t1_we = true;
        //                 LoadIda
        //             }
        //             DstOperand::RegSum(ba, _ia) => {
        //                 cs.rf_oe = true;
        //                 cs.rf_sel = btr(ba);
        //                 cs.t1_we = true;
        //                 LoadRs
        //             }
        //             // DstOperand::RegSumIncr(ba, _ia) => {
        //             //     cs.rf_oe = true;
        //             //     if let Some(r) = extract_ir_postinc(_i.0) {
        //             //         cs.rf_sel = r;
        //             //         Hlt
        //             //     } else {
        //             //         Hlt
        //             //     }
        //             // }
        //             // DstOperand::
        //             DstOperand::Reg(_r1) => Hlt,
        //             // DstOperand::
        //             _ => Hlt
        //         }
        //     } else {
        //         Hlt
        //     }
        // }

        // LoadDa => {
        //     cs.pc_we = true;
        //     // ADC(T1, 0, 1)
        //     cs.t1_oe = true;
        //     cs.t1_we = true;
        //     cs.alu_oe = true;
        //     cs.alu_carry = true;
        //     cs.alu_sel = ADC;
        //     Hlt
        // }
        // LoadIda => {
        //     cs.pc_we = true;
        //     cs.t1_oe = true;
        //     cs.ma_we = true;
        //     cs.alu_oe = true;
        //     cs.alu_carry = true;
        //     cs.alu_sel = ADC;
        //     LoadIda1
        // }
        // LoadIda1 => {
        //     cs.ma_oe = true;
        //     LoadIda2
        // }
        // LoadIda2 => {
        //     cs.ram_oe = true;
        //     cs.t1_we = true;
        //     Hlt
        // }
        // LoadRs => {
        //     if let Some(x) = extract_ea(_i.0) {
        //         if let DstOperand::RegSum(_ba, ia) = x {
        //             cs.t2_we = true;
        //             cs.rf_oe = true;
        //             cs.rf_sel = itr(ia);
        //             LoadRs1
        //         } else {
        //             Hlt
        //         }
        //     } else {
        //         Hlt
        //     }
        // }
        // LoadRs1 => {
        //     cs.t1_we = true;
        //     cs.t1_oe = true;
        //     cs.t2_oe = true;
        //     cs.alu_oe = true;
        //     cs.alu_sel = ADC;
        //     cs.alu_carry = false;
        //     Hlt
        // }
        IncPC => {
            cs.pc_oe = true;
            cs.t1_we = true;
            IncPC1
        },
        IncPC1 => {
            cs.alu_carry = true;
            cs.alu_oe = true;
            cs.alu_sel = ADC;
            cs.t1_oe = true;
            cs.pc_we = true;
            Fetch
        }
        _ => Hlt
    };
    (cs, D { state: next_state })
}
