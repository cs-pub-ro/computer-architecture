use rhdl::prelude::*;

#[derive(Digital, Debug, PartialEq, Eq)]
pub struct ComparatorInput {
    a: Bits<U1>,
    b: Bits<U1>
}

#[derive(Digital, Debug, PartialEq, Eq)]
pub struct ComparatorOutput {
    less_than: Bits<U1>,
    greater_than: Bits<U1>,
    equals: Bits<U1>
}

#[kernel]
pub fn comparator(_cr: ClockReset, i: ComparatorInput) -> ComparatorOutput {
    // TODO comparator outputs
    let lt = bits(0);
    let gt = bits(0);
    let eq = bits(0);

    ComparatorOutput {
        less_than: lt,
        greater_than: gt,
        equals: eq
    }
}

pub type Comparator = Func<ComparatorInput, ComparatorOutput>;

pub fn new() -> Result<Comparator, RHDLError> {
    Func::try_new::<comparator>()
}

pub fn sim_comparator() -> Result<(), RHDLError> {
    let comparator = new()?;

    let test_data = vec![
        (0,  (Bits::<U1>::from(0), Bits::<U1>::from(0))),
        (10, (Bits::<U1>::from(0), Bits::<U1>::from(1))),
        (20, (Bits::<U1>::from(1), Bits::<U1>::from(0))),
        (30, (Bits::<U1>::from(1), Bits::<U1>::from(1))),
        (40, (Bits::<U1>::default(), Bits::<U1>::default()))
    ];

    let input = test_data.into_iter().map(|(time, (a, b))| TimedSample {
        time,
        value: (ClockReset::default(), ComparatorInput {a, b}),
    });

    let vcd = comparator.run(input)?.collect::<Vcd>();

    vcd.dump_to_file("comparator.vcd")?;

    Ok(())
}
