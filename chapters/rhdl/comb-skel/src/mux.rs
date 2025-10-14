use rhdl::prelude::*;

#[derive(Digital, Debug, PartialEq, Eq)]
struct DataBus {
    d0: Bits<U1>,
    d1: Bits<U1>,
    d2: Bits<U1>,
    d3: Bits<U1>,
}

#[derive(Digital, Debug, PartialEq, Eq)]
struct Select {
    s0: Bits<U1>,
    s1: Bits<U1>,
}

#[derive(Digital, Debug, PartialEq, Eq)]
pub struct MUXInput {
    bus: DataBus,
    sel: Select, 
}

#[kernel]
pub fn mux(_cr: ClockReset, i: MUXInput) -> Bits<U1> {
    // TODO MUX
    bits(0)
}

pub type MUX = Func<MUXInput, Bits<U1>>;

pub fn new() -> Result<MUX, RHDLError> {
    Func::try_new::<mux>()
}

fn sim_mux() -> Result<(), RHDLError> {
    let my_mux = new()?;

    let test_data = vec![
        (0,  (Bits::<U1>::from(0), Bits::<U1>::from(0),
              Bits::<U1>::from(1), Bits::<U1>::from(0),
              Bits::<U1>::from(0), Bits::<U1>::from(0))),
        (10, (Bits::<U1>::from(0), Bits::<U1>::from(1),
              Bits::<U1>::from(0), Bits::<U1>::from(1),
              Bits::<U1>::from(0), Bits::<U1>::from(0))),
        (20, (Bits::<U1>::from(1), Bits::<U1>::from(0),
              Bits::<U1>::from(0), Bits::<U1>::from(0),
              Bits::<U1>::from(1), Bits::<U1>::from(0))),
        (30, (Bits::<U1>::from(1), Bits::<U1>::from(1),
              Bits::<U1>::from(0), Bits::<U1>::from(0),
              Bits::<U1>::from(0), Bits::<U1>::from(1))),
        (40, (Bits::<U1>::default(), Bits::<U1>::default(),
              Bits::<U1>::default(), Bits::<U1>::default(),
              Bits::<U1>::default(), Bits::<U1>::default())),
    ];

    // Convert to TimedSample stream
    let input = test_data.into_iter().map(|(time, (s1, s0, d0, d1, d2, d3))| {
        TimedSample {
            time,
            value: (
                ClockReset::default(),
                MUXInput {
                    bus: DataBus { d0, d1, d2, d3 },
                    sel: Select { s0, s1 },
                },
            ),
        }
    });

    let vcd = my_mux.run(input)?.collect::<Vcd>();
    vcd.dump_to_file("mux.vcd")?;

    Ok(())
}