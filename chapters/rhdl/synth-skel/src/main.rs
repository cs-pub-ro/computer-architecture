use crate::{count::count_synth_main, ssg::ssg_synth_main};
use rhdl::prelude::*;
mod ssg;
mod util;
mod count;

pub fn miette_report(err: RHDLError) -> String {
    let handler =
        miette::GraphicalReportHandler::new_themed(miette::GraphicalTheme::unicode_nocolor());
    let mut msg = String::new();
    handler.render_report(&mut msg, &err).unwrap();
    msg
}

fn main() {
    if let Err(e) = ssg_synth_main() {
        eprintln!("ssg_synth_main error:\n{}", miette_report(e));
        return;
    }
}