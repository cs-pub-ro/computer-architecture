use crate::{
    alu::{alu, flags, fr},
    control_unit::{ControlSignals, ControlUnit, State},
    decode_unit::decode,
    memory::{Ram, RamInput},
    prelude::*,
};
use bitops_rhdl::bitops;
use rhdl_fpga::core::dff::DFF;

pub mod cpu_test;


#[derive(Clone, Debug, Default)]
pub struct CpuDefault {
    pub regs: [u128; 8],
    pub T1: u128,
    pub T2: u128,
    pub MA: u128,
    pub IR: u128,
    pub PC: u128,
    pub FR: u128,
    pub state: State,
}
#[derive(Synchronous, SynchronousDQ, Clone, Debug)]

pub struct Cpu {
    pub regs: RegFile<U16>,
    pub T1: Register<U16>,
    pub T2: Register<U16>,
    pub MA: Register<U16>,
    pub PC: Register<U16>,
    // Special register that is always readable by the ControlUnit, not always readable by bus
    pub IR: DFF<Bits<U16>>,
    // Flags register, alyaws visible to ControlUnit
    pub FR: DFF<Bits<U16>>,
    pub Cu: ControlUnit,
    pub RAM: Ram,
}

impl Default for Cpu {
    fn default() -> Self {
        Self {
            T1: Register {
                memory: DFF::new(Bits::<U16>::from(5)),
            },
            T2: Register::default(),
            MA: Register::default(),
            Cu: ControlUnit::default(),
            regs: RegFile::default(),
            RAM: Ram::from_hex_file("cram.data").unwrap_or_default(),
            IR: DFF::default(),
            PC: Register::default(),
            FR: DFF::default(),
        }
    }
}

impl Cpu {
    pub fn new(init: CpuDefault) -> Self {
        Self {
            T1: Register::new(init.T1),
            T2: Register::new(init.T2),
            MA: Register::new(init.MA),
            Cu: ControlUnit::new(init.state),
            regs: RegFile::new(init.regs),
            RAM: Ram::from_hex_file("cram.data").unwrap_or_default(),
            IR: DFF::new(Bits::from(init.IR)),
            PC: Register::new(init.PC),
            FR: DFF::new(Bits::from(init.FR)),
        }
    }
}

impl SynchronousIO for Cpu {
    type I = Bits<U16>;
    type O = (Bits<U16>, IOSignals);
    type Kernel = top_kernel;
}

#[bitops]
#[kernel]
pub fn top_kernel(_cr: ClockReset, i: Bits<U16>, q: Q) -> ((Bits<U16>, IOSignals), D) {
    let mut d = D::dont_care();
    let ControlSignals {
        rf_sel,
        rf_oe,
        rf_we,
        t1_oe,
        t1_we,
        t2_oe,
        t2_we,
        ma_oe,
        ma_we,
        ram_oe,
        ram_we,
        alu_carry,
        alu_oe,
        alu_sel,
        pc_we,
        pc_oe,
        ir_we,
        ir_oe,
        fr_oe,
        fr_we,
        fr_sel_bus,
        ioa_we,
        ioa_oe,
        io_oe,
        io_we,
        .. // done signals
    } = q.Cu;
    let alu_res = alu::<U16>(AluInput::<U16> {
        t1: q.T1.1, // Not a bus output
        t2: q.T2.1, // Not a bus output
        carry_in: alu_carry,
        opsel: alu_sel,
    });
    // let alu_res  = AluOutput::<U16> { res: bits(0), flags: AluFlags { c: false, z: false, s: false, o: false, p: false } };
    let bus = if fr_oe && !(fr_sel_bus && fr_we) { q.FR } else { bits(0) }
        | if ir_oe && !ir_we { (q.IR[8], q.IR[8], q.IR[8], q.IR[8], q.IR[8], q.IR[8], q.IR[8], q.IR[8], q.IR[8], q.IR[9], q.IR[10], q.IR[11], q.IR[12], q.IR[13], q.IR[14], q.IR[15]) } else { bits(0) }
        | q.PC.0 // Bus output
        | q.regs
        | q.RAM
        | if io_oe {i} else { bits(0) } // Even if we send oe signal to the exterior, we cannot control its behavior fully, so we guard against the risk
        | if alu_oe { alu_res.res } else { bits(0) };
    d.T1 = RegisterInput::<U16> {
        oe: t1_oe,
        we: t1_we,
        data_in: bus,
    };
    d.T2 = RegisterInput::<U16> {
        oe: t2_oe,
        we: t2_we,
        data_in: bus,
    };
    d.MA = RegisterInput::<U16> {
        oe: ma_oe,
        we: ma_we,
        data_in: bus,
    };
    d.RAM = RamInput {
        oe: ram_oe,
        we: ram_we,
        data_in: bus,
        address: q.MA.1.resize(), // Not a bus output
    };
    d.PC = RegisterInput::<U16> {
        data_in: bus,
        oe: pc_oe,
        we: pc_we,
    };

    // These registers are permanently visible to Control unit
    d.Cu.0 = decode(q.IR);
    d.Cu.1 = flags(q.FR);

    d.IR = if ir_we { bus } else { q.IR };
    d.FR = if fr_we {
        // If from bus ignore anything outside the flag range
        if fr_sel_bus { bus[4..0].resize() } else { fr(alu_res.flags) }
    } else {
        q.FR
    };

    d.regs.0 = RegisterInput::<U16> {
        oe: rf_oe,
        we: rf_we,
        data_in: bus,
    };
    d.regs.1 = rf_sel;
    ((bus, IOSignals {
        ioa_oe, ioa_we, io_oe, io_we
    }), d)
}

// ADD TESTBENCHES
pub mod tests {

    fn didasm(asm_source: &str){
        std::fs::write("test.asm", asm_source);
        if let Err(_) = std::process::Command::new("didasm")
            .arg("test.asm")
            .arg("cram.data")
            .arg("--quiet")
            .output() {
            eprintln!("Didasm not available (cargo install didasm --path <computer-architecture-path>/didasm), falling back to existing cram.data...")
        }
    }

    // Test just the fetch
    #[test]
    fn test_fetch() {
        let (cpu, mut s) = start_cpu_test(
            r#"
            hlt
            "#,
            CpuDefault::default()
        ).unwrap();

        step(&cpu, (), &mut s);
        step(&cpu, (), &mut s);
        let state = cu_state(&s);
        assert_eq!(state, State::Fetch(FetchStage::PcToMA));

        step(&cpu, (), &mut s);
        let state = cu_state(&s);
        assert_eq!(state, State::Fetch(FetchStage::MaToMem));
        let MA = ma(&s);
        // TODO change cpu state
        assert_eq!(MA, 0);

        let o = step(&cpu, (), &mut s);
        let state = cu_state(&s);
        assert_eq!(state, State::Fetch(FetchStage::MemToIr));
        let BUS = bus(&o);
        assert_eq!(BUS, 0x0031);
        step(&cpu, (), &mut s);
        let state = cu_state(&s);
        assert_eq!(state, State::Decode);
        let IR = ir(&s);
        assert_eq!(IR, 0x0031);


    }

    #[test]
    fn test_cpu_default_values() {
        let mut init = CpuDefault::default();
        init.regs[4] = 0x69;
        let (cpu, mut s) = start_cpu_test(
            r#"
            hlt
            "#,
            init
        ).unwrap();
        let o = step(&cpu, (), &mut s);
        assert_eq!(rg(&s, 4), 0x69);
    }

    #[test]
    fn test_load_1() {
        let mut init = CpuDefault::default();
        for i in 0..8 {
            init.regs[i] = i as u128 + 1;
        }
        let (cpu, mut s) = start_cpu_test(
            r#"
            sub [ba+43], 42
            50: 0x69
            "#,
            init
        ).unwrap();
        run_till_next_instr(&cpu, &mut s);
        let o = run_till_load_done(&cpu, &mut s);
        assert_eq!(0x69, t1(&s));
        assert_eq!(42, t2(&s));
        assert_eq!(50, ma(&s));
        assert_eq!(2, pc(&s));
    }

    #[test]
    fn test_load_2() {
        let mut init = CpuDefault::default();
        for i in 0..8 {
            init.regs[i] = i as u128 + 1;
        }
        let (cpu, mut s) = start_cpu_test(
            r#"
            mov [ba+43], 42
            50: 0x69
            "#,
            init
        ).unwrap();
        run_till_next_instr(&cpu, &mut s);
        let o = run_till_load_done(&cpu, &mut s);
        assert_ne!(0x69, t1(&s), "You don't have to load the *value* of the memory at effective address for MOV instructions if destination");
        assert_eq!(42, t2(&s));
        assert_eq!(50, ma(&s));
        assert_eq!(2, pc(&s));
    }

    #[test]
    fn test_load_5() {
        let mut init = CpuDefault::default();
        for i in 0..8 {
            init.regs[i] = i as u128 + 1;
        }
        let (cpu, mut s) = start_cpu_test(
            r#"
            add ra, [ba+xb+]
            13: 0x2
            "#,
            init
        ).unwrap();
        run_till_next_instr(&cpu, &mut s);
        let o = run_till_load_done(&cpu, &mut s);
        assert_eq!(true, control_signals(&s).load_done);
        assert_eq!(1, t1(&s));
        assert_eq!(2, t2(&s));
        assert_eq!(13, ma(&s));
        assert_eq!(7, rg(&s, 5));
        assert_eq!(0, pc(&s));
    }

    #[test]
    fn test_load_6() {
        let mut init = CpuDefault::default();
        for i in 0..8 {
            init.regs[i] = i as u128 + 1;
        }
        let (cpu, mut s) = start_cpu_test(
            r#"
            cmp [bb+xa+5], 7
            18: 0x7
            "#,
            init
        ).unwrap();
        run_till_next_instr(&cpu, &mut s);
        let o = run_till_load_done(&cpu, &mut s);
        assert_eq!(7, t1(&s));
        assert_eq!(7, t2(&s));
        assert_eq!(18, ma(&s));
        assert_eq!(2, pc(&s));
    }

    #[test]
    fn test_load_reg_dyn() {
        use rand::prelude::*;
        let mut rng = rand::rng();
        let mut init = CpuDefault::default();
        let mapping = [
            "ra",
            "rb",
            "rc",
            "sp",
            "xa",
            "xb",
            "ba",
            "bb",
        ];

        for i in 0..8 {
            init.regs[i] = rng.random_range(0..u16::MAX) as u128;
        }

        let destination = rng.random_range(0..8) as usize;
        let source = rng.random_range(0..8) as usize;

        let destination_value = init.regs[destination];
        let source_value = init.regs[source];
        
        let asm_code = format!(
            "add {dst}, {src}",
            dst = mapping[destination],
            src = mapping[source]
        );
    
        println!("{}", &asm_code);
        let (cpu, mut s) = start_cpu_test(
            &asm_code,
            init
        ).unwrap();

        run_till_next_instr(&cpu, &mut s);
        let o = run_till_load_done(&cpu, &mut s);

        assert_eq!(0, pc(&s));
        assert_eq!(destination_value, t1(&s));
        assert_eq!(source_value, t2(&s));
    }
    #[test]
    fn test_load_memory_source_addressing_modes(){
        use rand::prelude::*;
        let mut rng = rand::rng();

        let mapping = [
            "ra",
            "rb",
            "rc",
            "sp",
            "xa",
            "xb",
            "ba",
            "bb",
        ];

        // 1) Direct
        {
            let mut init = CpuDefault::default();

            for i in 0..8 {
                init.regs[i] = rng.random_range(0..u16::MAX) as u128;
            }

            let dst = rng.random_range(0..8) as usize;
            let dst_val = init.regs[dst];

            const MEM_SIZE : usize = 1024;

            let addr = rng.random_range(10..MEM_SIZE as u16) as u16;
            let mem_val = rng.random_range(0..u16::MAX) as u16;
            
            let asm_code = format!(
                "adc {dst}, [{addr:#04X}]
                {addr}: {mem_val:#04X}
                ",
                dst = mapping[dst],
                addr = addr,
                mem_val = mem_val
            );
            println!("{}", &asm_code);
            let (cpu, mut s) = start_cpu_test(
                &asm_code,
                init
            ).unwrap();
            run_till_next_instr(&cpu, &mut s);
            let o = run_till_load_done(&cpu, &mut s);
            assert_eq!(1, pc(&s));
            assert_eq!(dst_val, t1(&s));
            assert_eq!(addr as u128, ma(&s));
            assert_eq!(mem_val as u128, t2(&s));
        }

        // 2) [reg]
        {
            let mut init = CpuDefault::default();

            for i in 0..8 {
                init.regs[i] = rng.random_range(0..u16::MAX) as u128;
            }

            let addr_regs = [4usize, 5, 6, 7]; // xa, xb, ba, bb
            let addr_reg = addr_regs[rng.random_range(0..addr_regs.len())];

            const MEM_SIZE : usize = 1024;

            let addr = rng.random_range(10..MEM_SIZE as u16) as u16;
            init.regs[addr_reg] = addr as u128;
            let src_val = init.regs[addr_reg];

            let dst = rng.random_range(0..8) as usize;
            let dst_val = init.regs[dst];

            let mem_val = rng.random_range(0..u16::MAX) as u16;

            let asm_code = format!(
                "sbb {dst}, [{addr_reg}]
                {addr}: {mem_val:#04X}
                ",
                dst = mapping[dst],
                addr_reg = mapping[addr_reg],
                addr = addr,
                mem_val = mem_val
            );
            println!("{}", &asm_code);
            let (cpu, mut s) = start_cpu_test(
                &asm_code,
                init
            ).unwrap();
            run_till_next_instr(&cpu, &mut s);
            let o = run_till_load_done(&cpu, &mut s);
            assert_eq!(0, pc(&s));
            assert_eq!(dst_val, t1(&s));
            assert_eq!(src_val as u128, ma(&s));
            assert_eq!(mem_val as u128, t2(&s));
        }

        // 3) [reg + imm]
        {
            let mut init = CpuDefault::default();

            for i in 0..8 {
                init.regs[i] = rng.random_range(0..u16::MAX) as u128;
            }

            let addr_regs = [4usize, 5, 6, 7]; // xa, xb, ba, bb
            let addr_reg = addr_regs[rng.random_range(0..addr_regs.len())];

            const MEM_SIZE : usize = 1024;

            let base_addr = rng.random_range(10..(MEM_SIZE as u16 - 20)) as u16;
            let offset = rng.random_range(1..20) as u16;
            let final_addr = base_addr + offset;
            init.regs[addr_reg] = base_addr as u128;
            let src_val = init.regs[addr_reg];

            let dst = rng.random_range(0..8) as usize;
            let dst_val = init.regs[dst];

            let mem_val = rng.random_range(0..u16::MAX) as u16;

            let asm_code = format!(
                "and {dst}, [{addr_reg}+{offset}]
                {final_addr}: {mem_val:#04X}
                ",
                dst = mapping[dst],
                addr_reg = mapping[addr_reg],
                offset = offset,
                final_addr = final_addr,
                mem_val = mem_val
            );
            println!("{}", &asm_code);
            let (cpu, mut s) = start_cpu_test(
                &asm_code,
                init
            ).unwrap();
            run_till_next_instr(&cpu, &mut s);
            let o = run_till_load_done(&cpu, &mut s);
            assert_eq!(1, pc(&s));
            assert_eq!(dst_val, t1(&s));
            assert_eq!(src_val as u128 + offset as u128, ma(&s));
            assert_eq!(mem_val as u128, t2(&s));
        }

        // 4) [[imm]]
        {
            let mut init = CpuDefault::default();

            for i in 0..8 {
                init.regs[i] = rng.random_range(0..u16::MAX) as u128;
            }

            const MEM_SIZE : usize = 1024;

            let pointer_addr = rng.random_range(10..(MEM_SIZE as u16 - 20)) as u16;
            let final_addr = rng.random_range(10..(MEM_SIZE as u16 - 1)) as u16;
            let mem_val = rng.random_range(0..u16::MAX) as u16;

            // Write the final address into memory at pointer_addr
            {
                let mut ram_init = vec![0u128; MEM_SIZE];
                ram_init[pointer_addr as usize] = final_addr as u128;
                std::fs::write("cram.data", ram_init.iter().map(|v| format!("{:04X}\n", v)).collect::<String>()).unwrap();
            }

            let dst = rng.random_range(0..8) as usize;
            let dst_val = init.regs[dst];

            let asm_code = format!(
                "xor {dst}, [[{pointer_addr}]]
                {pointer_addr}: {final_addr:#04X}
                {final_addr}: {mem_val:#04X}
                ",
                dst = mapping[dst],
                pointer_addr = pointer_addr,
                final_addr = final_addr,
                mem_val = mem_val
            );
            println!("{}", &asm_code);
            let (cpu, mut s) = start_cpu_test(
                &asm_code,
                init
            ).unwrap();
            run_till_next_instr(&cpu, &mut s);
            let o = run_till_load_done(&cpu, &mut s);
            assert_eq!(1, pc(&s));
            assert_eq!(dst_val, t1(&s));
            assert_eq!(final_addr as u128, ma(&s));
            assert_eq!(mem_val as u128, t2(&s));
        }

        // 5) [base_reg + index_reg]
        {
            let mut init = CpuDefault::default();

            for i in 0..8 {
                init.regs[i] = rng.random_range(0..u16::MAX) as u128;
            }

            let addr_base_regs = [6usize, 7]; // ba, bb
            let addr_index_regs = [4usize, 5]; // xa, xb
            let base_reg = addr_base_regs[rng.random_range(0..addr_base_regs.len())];
            let index_reg = addr_index_regs[rng.random_range(0..addr_index_regs.len())];

            const MEM_SIZE : usize = 1024;

            let base_addr = rng.random_range(10..(MEM_SIZE as u16 - 20)) as u16;
            let index_offset = rng.random_range(1..20) as u16;
            let final_addr = base_addr + index_offset;
            init.regs[base_reg] = base_addr as u128;
            init.regs[index_reg] = index_offset as u128;
            let src_val = init.regs[base_reg] + init.regs[index_reg];

            let dst = rng.random_range(0..8) as usize;
            let dst_val = init.regs[dst];

            let mem_val = rng.random_range(0..u16::MAX) as u16;

            let asm_code = format!(
                "or {dst}, [{base_reg}+{index_reg}]
                {final_addr}: {mem_val:#04X}
                ",
                dst = mapping[dst],
                base_reg = mapping[base_reg],
                index_reg = mapping[index_reg],
                final_addr = final_addr,
                mem_val = mem_val
            );
            println!("{}", &asm_code);
            let (cpu, mut s) = start_cpu_test(
                &asm_code,
                init
            ).unwrap();
            run_till_next_instr(&cpu, &mut s);
            let o = run_till_load_done(&cpu, &mut s);
            assert_eq!(0, pc(&s));
            assert_eq!(dst_val, t1(&s));
            assert_eq!(src_val as u128, ma(&s));
            assert_eq!(mem_val as u128, t2(&s));
        }

        // 6) [base_reg + index_reg + imm]
        {
            let mut init = CpuDefault::default();

            for i in 0..8 {
                init.regs[i] = rng.random_range(0..u16::MAX) as u128;
            }

            let addr_base_regs = [6usize, 7]; // ba, bb
            let addr_index_regs = [4usize, 5]; // xa, xb
            let base_reg = addr_base_regs[rng.random_range(0..addr_base_regs.len())];
            let index_reg = addr_index_regs[rng.random_range(0..addr_index_regs.len())];

            const MEM_SIZE : usize = 1024;

            let base_addr = rng.random_range(10..(MEM_SIZE as u16 - 40)) as u16;
            let index_offset = rng.random_range(1..20) as u16;
            let imm_offset = rng.random_range(1..20) as u16;
            let final_addr = base_addr + index_offset + imm_offset;
            init.regs[base_reg] = base_addr as u128;
            init.regs[index_reg] = index_offset as u128;
            let src_val = init.regs[base_reg] + init.regs[index_reg] + imm_offset as u128;

            let dst = rng.random_range(0..8) as usize;
            let dst_val = init.regs[dst];

            let mem_val = rng.random_range(0..u16::MAX) as u16;

            let asm_code = format!(
                "xor {dst}, [{base_reg}+{index_reg}+{imm_offset}]
                {final_addr}: {mem_val:#04X}
                ",
                dst = mapping[dst],
                base_reg = mapping[base_reg],
                index_reg = mapping[index_reg],
                imm_offset = imm_offset,
                final_addr = final_addr,
                mem_val = mem_val
            );
            println!("{}", &asm_code);
            let (cpu, mut s) = start_cpu_test(
                &asm_code,
                init
            ).unwrap();
            run_till_next_instr(&cpu, &mut s);
            let o = run_till_load_done(&cpu, &mut s);
            assert_eq!(1, pc(&s));
            assert_eq!(dst_val, t1(&s));
            assert_eq!(src_val as u128, ma(&s));
            assert_eq!(mem_val as u128, t2(&s));
        }
    }
    
    #[test]
    pub fn test_load_memory_destination_addressing_modes(){
        use rand::prelude::*;
        let mut rng = rand::rng();

        let mapping = [
            "ra",
            "rb",
            "rc",
            "sp",
            "xa",
            "xb",
            "ba",
            "bb",
        ];

        // 1) Direct
        {
            let mut init = CpuDefault::default();

            for i in 0..8 {
                init.regs[i] = rng.random_range(0..u16::MAX) as u128;
            }

            let src = rng.random_range(0..8) as usize;
            let src_val = init.regs[src];

            const MEM_SIZE : usize = 1024;

            let addr = rng.random_range(10..MEM_SIZE as u16) as u16;
            let mem_val = rng.random_range(0..u16::MAX) as u16;
            
            let asm_code = format!(
                "adc [{addr}], {src}
                {addr}: {mem_val:#06X}
                ",
                src = mapping[src],
                addr = addr,
                mem_val = mem_val
            );
            println!("{}", &asm_code);
            let (cpu, mut s) = start_cpu_test(
                &asm_code,
                init
            ).unwrap();
            run_till_next_instr(&cpu, &mut s);
            let o = run_till_load_done(&cpu, &mut s);
            assert_eq!(1, pc(&s));
            assert_eq!(addr as u128, ma(&s));
            assert_eq!(mem_val as u128, t1(&s));
            assert_eq!(src_val, t2(&s));
        }

        // 2) [reg]
        {
            let mut init = CpuDefault::default();

            for i in 0..8 {
                init.regs[i] = rng.random_range(0..u16::MAX) as u128;
            }

            let addr_regs = [4usize, 5, 6, 7]; // xa, xb, ba, bb
            let addr_reg = addr_regs[rng.random_range(0..addr_regs.len())];

            const MEM_SIZE : usize = 1024;

            let addr = rng.random_range(10..MEM_SIZE as u16);
            init.regs[addr_reg] = addr as u128;

            let src = rng.random_range(0..8) as usize;
            let src_val = init.regs[src];

            let mem_val = rng.random_range(0..u16::MAX) as u16;

            let asm_code = format!(
                "sbb [{addr_reg}], {src}
                {addr}: {mem_val:#06X}
                ",
                src = mapping[src],
                addr_reg = mapping[addr_reg],
                addr = addr,
                mem_val = mem_val
            );
            println!("{}", &asm_code);
            let (cpu, mut s) = start_cpu_test(
                &asm_code,
                init
            ).unwrap();
            run_till_next_instr(&cpu, &mut s);
            let o = run_till_load_done(&cpu, &mut s);
            assert_eq!(1, pc(&s));
            assert_eq!(addr as u128, ma(&s));
            assert_eq!(mem_val as u128, t1(&s));
            assert_eq!(src_val, t2(&s));
        }

        // 3) [reg + imm]
        {
            let mut init = CpuDefault::default();

            for i in 0..8 {
                init.regs[i] = rng.random_range(0..u16::MAX) as u128;
            }

            let addr_regs = [4usize, 5, 6, 7]; // xa, xb, ba, bb
            let addr_reg = addr_regs[rng.random_range(0..addr_regs.len())];

            const MEM_SIZE : usize = 1024;

            let base_addr = rng.random_range(10..(MEM_SIZE as u16 - 20)) as u16;
            let offset = rng.random_range(1..20) as u16;
            let final_addr = base_addr + offset;
            init.regs[addr_reg] = base_addr as u128;

            let src = rng.random_range(0..8) as usize;
            let src_val = init.regs[src];

            let mem_val = rng.random_range(0..u16::MAX) as u16;

            let asm_code = format!(
                "and [{addr_reg}+{offset}], {src}
                {final_addr}: {mem_val:#06X}
                ",
                src = mapping[src],
                addr_reg = mapping[addr_reg],
                offset = offset,
                final_addr = final_addr,
                mem_val = mem_val
            );
            println!("{}", &asm_code);
            let (cpu, mut s) = start_cpu_test(
                &asm_code,
                init
            ).unwrap();
            run_till_next_instr(&cpu, &mut s);
            let o = run_till_load_done(&cpu, &mut s);
            assert_eq!(1, pc(&s));
            assert_eq!(final_addr as u128, ma(&s));
            assert_eq!(mem_val as u128, t1(&s));
            assert_eq!(src_val, t2(&s));
        }

        // 4) [[imm]]
        {
            let mut init = CpuDefault::default();

            for i in 0..8 {
                init.regs[i] = rng.random_range(0..u16::MAX) as u128;
            }

            const MEM_SIZE : usize = 1024;

            let pointer_addr = rng.random_range(10..(MEM_SIZE as u16 - 20)) as u16;
            let final_addr = rng.random_range(10..(MEM_SIZE as u16 - 1)) as u16;
            let mem_val = rng.random_range(0..u16::MAX) as u16;

            // Write the final address into memory at pointer_addr
            {
                let mut ram_init = vec![0u128; MEM_SIZE];
                ram_init[pointer_addr as usize] = final_addr as u128;
                std::fs::write("cram.data", ram_init.iter().map(|v| format!("{:04X}\n", v)).collect::<String>()).unwrap();
            }

            let src = rng.random_range(0..8) as usize;
            let src_val = init.regs[src];

            let asm_code = format!(
                "xor [[{pointer_addr}]], {src}
                {pointer_addr}: {final_addr:#04X}
                {final_addr}: {mem_val:#06X}
                ",
                src = mapping[src],
                pointer_addr = pointer_addr,
                final_addr = final_addr,
                mem_val = mem_val
            );
            println!("{}", &asm_code);
            let (cpu, mut s) = start_cpu_test(
                &asm_code,
                init
            ).unwrap();
            run_till_next_instr(&cpu, &mut s);
            let o = run_till_load_done(&cpu, &mut s);
            assert_eq!(1, pc(&s));
            assert_eq!(final_addr as u128, ma(&s));
            assert_eq!(mem_val as u128, t1(&s));
            assert_eq!(src_val, t2(&s));
        }

        // 5) [base_reg + index_reg]
        {
            let mut init = CpuDefault::default();

            for i in 0..8 {
                init.regs[i] = rng.random_range(0..u16::MAX) as u128;
            }

            let addr_base_regs = [6usize, 7]; // ba, bb
            let addr_index_regs = [4usize, 5]; // xa, xb
            let base_reg = addr_base_regs[rng.random_range(0..addr_base_regs.len())];
            let index_reg = addr_index_regs[rng.random_range(0..addr_index_regs.len())];

            const MEM_SIZE : usize = 1024;

            let base_addr = rng.random_range(10..(MEM_SIZE as u16 - 20)) as u16;
            let index_offset = rng.random_range(1..20) as u16;
            let final_addr = base_addr + index_offset;
            init.regs[base_reg] = base_addr as u128;
            init.regs[index_reg] = index_offset as u128;

            let src = rng.random_range(0..8) as usize;
            let src_val = init.regs[src];

            let mem_val = rng.random_range(0..u16::MAX) as u16;

            let asm_code = format!(
                "or [{base_reg}+{index_reg}], {src}
                {final_addr}: {mem_val:#06X}
                ",
                src = mapping[src],
                base_reg = mapping[base_reg],
                index_reg = mapping[index_reg],
                final_addr = final_addr,
                mem_val = mem_val
            );
            println!("{}", &asm_code);
            let (cpu, mut s) = start_cpu_test(
                &asm_code,
                init
            ).unwrap();
            run_till_next_instr(&cpu, &mut s);
            let o = run_till_load_done(&cpu, &mut s);
            assert_eq!(1, pc(&s));
            assert_eq!(final_addr as u128, ma(&s));
            assert_eq!(mem_val as u128, t1(&s));
            assert_eq!(src_val, t2(&s));
        }

        // 6) [base_reg + index_reg + imm]
        {
            let mut init = CpuDefault::default();

            for i in 0..8 {
                init.regs[i] = rng.random_range(0..u16::MAX) as u128;
            }

            let addr_base_regs = [6usize, 7]; // ba, bb
            let addr_index_regs = [4usize, 5]; // xa, xb
            let base_reg = addr_base_regs[rng.random_range(0..addr_base_regs.len())];
            let index_reg = addr_index_regs[rng.random_range(0..addr_index_regs.len())];

            const MEM_SIZE : usize = 1024;

            let base_addr = rng.random_range(10..(MEM_SIZE as u16 - 40)) as u16;
            let index_offset = rng.random_range(1..20) as u16;
            let imm_offset = rng.random_range(1..20) as u16;
            let final_addr = base_addr + index_offset + imm_offset;
            init.regs[base_reg] = base_addr as u128;
            init.regs[index_reg] = index_offset as u128;

            let src = rng.random_range(0..8) as usize;
            let src_val = init.regs[src];

            let mem_val = rng.random_range(0..u16::MAX) as u16;

            let asm_code = format!(
                "xor [{base_reg}+{index_reg}+{imm_offset}], {src}
                {final_addr}: {mem_val:#06X}
                ",
                src = mapping[src],
                base_reg = mapping[base_reg],
                index_reg = mapping[index_reg],
                imm_offset = imm_offset,
                final_addr = final_addr,
                mem_val = mem_val
            );
            println!("{}", &asm_code);
            let (cpu, mut s) = start_cpu_test(
                &asm_code,
                init
            ).unwrap();
            run_till_next_instr(&cpu, &mut s);
            let o = run_till_load_done(&cpu, &mut s);
            assert_eq!(1, pc(&s));
            assert_eq!(final_addr as u128, ma(&s));
            assert_eq!(mem_val as u128, t1(&s));
            assert_eq!(src_val, t2(&s));
        }
    }
}

