use std::path::PathBuf;

use anyhow;
use rhdl::prelude::*;

pub fn write_svg(vcd: Vcd, name: &str) -> anyhow::Result<()> {
    let mut options = SvgOptions::default();
    options.pixels_per_time_unit = 5.0;
    let path = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let path = path.join("doc");
    std::fs::create_dir_all(&path)?;
    let path = path.join(name);
    std::fs::write(path, format!("{}\n", vcd.dump_svg(&options)))?;
    Ok(())
}
