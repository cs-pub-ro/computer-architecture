use rhdl::prelude::*;

#[derive(Digital, Eq, PartialEq)]
pub struct SevenSegmentOut {
    a: Bits<U1>,
    b: Bits<U1>,
    c: Bits<U1>,
    d: Bits<U1>,
    e: Bits<U1>,
    f: Bits<U1>,
    g: Bits<U1>
}

#[kernel]
pub fn seven_segment(_cr: ClockReset, i: Bits<U4>) -> SevenSegmentOut {
    match i.raw() {
        0 => SevenSegmentOut { // "0"
            a: bits(1),
            b: bits(1),
            c: bits(1),
            d: bits(1),
            e: bits(1),
            f: bits(1),
            g: bits(0),
        },
        // TODO Add rest of the digits
        _ => SevenSegmentOut { // Default
            a: bits(0),
            b: bits(0),
            c: bits(0),
            d: bits(0),
            e: bits(0),
            f: bits(0),
            g: bits(0),
        },
    }
}

pub type SevenSegment = Func<Bits<U4>, SevenSegmentOut>;

pub fn new() -> Result<SevenSegment, RHDLError> {
    Func::try_new::<seven_segment>()
}

pub fn sim_seven_segment() -> Result<(), RHDLError> {
    let my_seven_segment = new()?;
    let test_data = vec![
        (0,  0),   // "0"
        (10, 1),   // "1"
        (20, 2),   // "2"
        (30, 3),   // "3"
        (40, 4),   // "4"
        (50, 5),   // "5"
        (60, 6),   // "6"
        (70, 7),   // "7"
        (80, 8),   // "8"
        (90, 9),   // "9"
    ];
    let input = test_data.into_iter().map(|(time, digit)| TimedSample {
        time,
        value: (
            ClockReset::default(),
            bits::<U4>(digit),
        ),
    });
    let vcd = my_seven_segment.run(input)?.collect::<Vcd>();
    vcd.dump_to_file("seven_segment.vcd")?;
    Ok(())
}