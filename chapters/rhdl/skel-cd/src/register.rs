use crate::prelude::*;

#[derive(Debug, Digital, PartialEq, Default)]
pub struct RegisterInput<N: BitWidth + Unsigned> {
    pub data_in: Bits<N>,
    pub oe: bool,
    pub we: bool,
}

#[derive(Debug, Synchronous, SynchronousDQ, Clone)]
pub struct Register<N: BitWidth + Unsigned> {
    pub memory: DFF<Bits<N>>,
}

impl<N: BitWidth + Unsigned> Default for Register<N> {
    fn default() -> Self {
        Self {
            memory: DFF::default(),
        }
    }
}

impl<N: BitWidth + Unsigned> SynchronousIO for Register<N> {
    type I = RegisterInput<N>;
    type O = Bits<N>;
    type Kernel = reg_ker<N>;
}

#[kernel]
pub fn reg_ker<N: BitWidth + Unsigned>(
    _cr: ClockReset,
    i: RegisterInput<N>,
    q: Q<N>,
) -> (Bits<N>, D<N>) {
    (
        if i.oe && !i.we { q.memory } else { bits(0) },
        D::<N> {
            memory: if i.we { i.data_in } else { q.memory },
        },
    )
}
