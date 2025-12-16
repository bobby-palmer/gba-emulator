/// Intel 6502 emulator.
pub struct Cpu {
    a: u8,
    x: u8,
    y: u8,
    pc: u16,
    s: u8,
    p: u8,
}
