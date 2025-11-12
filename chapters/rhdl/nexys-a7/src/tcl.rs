use camino::Utf8PathBuf;



pub struct FlashBitstream {
    pub bit_file: Utf8PathBuf,
}

impl std::fmt::Display for FlashBitstream {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        writeln!(f, "open_hw_manager")?;
        writeln!(f, "connect_hw_server")?;
        writeln!(f, "current_hw_target")?;
        writeln!(f, "current_hw_target")?;
        writeln!(f, "open_hw_target")?;
        writeln!(f, "set_property PROGRAM.FILE {} [current_hw_device]", self.bit_file)?;
        writeln!(f, "program_hw_devices [current_hw_device]")?;
        Ok(())
    }
}
