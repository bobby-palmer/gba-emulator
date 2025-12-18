//! NES instruction granularity, Cpu emulator

const Bus = @import("Bus.zig");

const Flags = packed struct {
    Carry: u1 = 0,
    Zero: u1 = 0,
    InteruptDisable: u1 = 1,
    Decimal: u1 = 0,
    BFlag: u1 = 0,
    _: u1 = 0,
    Overflow: u1 = 0,
    Negative: u1 = 0,
};

const AddressingMode = enum {
    // Indexed modes
    ZeroPageX,
    ZeroPageY,
    AbsoluteX,
    AbsoluteY,
    IndirectX,
    IndirectY,

    // Other modes
    Accumulator,
    Immediate,
    ZeroPage,
    Absolute,
    Relative,
    Indirect,
    Implied,
};

/// (A)ccumulator
var a: u8 = 0;
/// GPR x
var x: u8 = 0;
/// GPR y
var y: u8 = 0;
/// (S)tack pointer
var s: u8 = 0xFD;
/// Cpu status flags
var p: Flags = Flags{};
/// Program counter
var pc: u16 = 0xFFFC;

/// Return 1 if highest bit is set
fn isNegative(byte: u8) u1 {
    return byte & 0x80 == 0x80;
}

fn readWithMode(addr_mode: AddressingMode) u8 {
    _ = addr_mode;
    unreachable;
}

fn writeWithMode(addr_mode: AddressingMode, value: u8) void {
    _ = addr_mode;
    _ = value;
    unreachable;
}

fn executeInstruction() void {
    const opcode = Bus.read(pc);

    switch (opcode) {
        0x69 => ADC(.Immediate),
        0x65 => ADC(.ZeroPage),
        0x75 => ADC(.ZeroPageX),
        0x6D => ADC(.Absolute),
        0x7D => ADC(.AbsoluteX),
        0x79 => ADC(.AbsoluteY),
        0x61 => ADC(.IndirectX),
        0x71 => ADC(.IndirectY),

        0x29 => AND(.Immediate),
        0x25 => AND(.ZeroPage),
        0x35 => AND(.ZeroPageX),
        0x2D => AND(.Absolute),
        0x3D => AND(.AbsoluteX),
        0x39 => AND(.AbsoluteX),
        0x21 => AND(.IndirectX),
        0x31 => AND(.IndirectY),

        0x0A => ASL(.Accumulator),
        0x06 => ASL(.ZeroPage),
        0x16 => ASL(.ZeroPageX),
        0x0E => ASL(.Absolute),
        0x1E => ASL(.AbsoluteX),

        0x90 => BCC(),
        0xB0 => BCS(),
        0xF0 => BEQ(),

        0x24 => BIT(.ZeroPage),
        0x2C => BIT(.Absolute),

        0x30 => BMI(),
        0xD0 => BNE(),
        0x10 => BPL(),
        0x00 => BRK(),
        0x50 => BVC(),
        0x70 => BVS(),
        0x18 => CLC(),
        0xD8 => CLD(),
        0xB8 => CLI(),

        0xC9 => CMP(.Immediate),
        0xC5 => CMP(.ZeroPage),
        0xD5 => CMP(.ZeroPageX),
        0xCD => CMP(.Absolute),
        0xDD => CMP(.AbsoluteX),
        0xD9 => CMP(.AbsoluteY),
        0xC1 => CMP(.IndirectX),
        0xD1 => CMP(.IndirectY),

        0xE0 => CPX(.Immediate),
        0xE4 => CPX(.ZeroPage),
        0xEC => CPX(.Absolute),

        0xC0 => CPY(.Immediate),
        0xC4 => CPY(.ZeroPage),
        0xCC => CPY(.Absolute),

        0xC6 => DEC(.ZeroPage),
        0xD6 => DEC(.ZeroPageX),
        0xCE => DEC(.Absolute),
        0xDE => DEC(.AbsoluteX),

        0xCA => DEX(),
        0x88 => DEY(),

        0x49 => EOR(.Immediate),
        0x45 => EOR(.ZeroPage),
        0x55 => EOR(.ZeroPageX),
        0x4D => EOR(.Absolute),
        0x5D => EOR(.AbsoluteX),
        0x59 => EOR(.AbsoluteY),
        0x41 => EOR(.IndirectX),
        0x51 => EOR(.IndirectY),

        0xE6 => INC(.ZeroPage),
        0xF6 => INC(.ZeroPageX),
        0xEE => INC(.Absolute),
        0xFE => INC(.AbsoluteX),

        0xE8 => INX(),
        0xC8 => INY(),

        0x4C => JMP(.Absolute),
        0x6C => JMP(.Indirect),

        0x20 => JSR(),

        0xA9 => LDA(.Immediate),
        0xA5 => LDA(.ZeroPage),
        0xB5 => LDA(.ZeroPageX),
        0xAD => LDA(.Absolute),
        0xBD => LDA(.AbsoluteX),
        0xB9 => LDA(.AbsoluteY),
        0xA1 => LDA(.IndirectX),
        0xB1 => LDA(.IndirectY),

        0xA2 => LDX(.Immediate),
        0xA6 => LDX(.ZeroPage),
        0xB6 => LDX(.ZeroPageY),
        0xAE => LDX(.Absolute),
        0xBE => LDX(.AbsoluteY),

        0xA0 => LDY(.Immediate),
        0xA4 => LDY(.ZeroPage),
        0xB4 => LDY(.ZeroPageX),
        0xAC => LDY(.Absolute),
        0xBC => LDY(.AbsoluteX),

        0x4A => LSR(.Accumulator),
        0x46 => LSR(.ZeroPage),
        0x56 => LSR(.ZeroPageX),
        0x4E => LSR(.Absolute),
        0x5E => LSR(.AbsoluteX),

        0xEA => NOP(),

        0x09 => ORA(.Immediate),
        0x05 => ORA(.ZeroPage),
        0x15 => ORA(.ZeroPageX),
        0x0D => ORA(.Absolute),
        0x1D => ORA(.AbsoluteX),
        0x19 => ORA(.AbsoluteY),
        0x01 => ORA(.IndirectX),
        0x11 => ORA(.IndirectY),

        0x48 => PHA(),
        0x08 => PHP(),
        0x68 => PLA(),
        0x28 => PLP(),

        0x2A => ROL(.Accumulator),
        0x26 => ROL(.ZeroPage),
        0x36 => ROL(.ZeroPageX),
        0x2E => ROL(.Absolute),
        0x3E => ROL(.AbsoluteX),

        0x6A => ROR(.Accumulator),
        0x66 => ROR(.ZeroPage),
        0x76 => ROR(.ZeroPageX),
        0x6E => ROR(.Absolute),
        0x7E => ROR(.AbsoluteX),

        0x40 => RTI(),
        0x60 => RTS(),

        0xE9 => SBC(.Immediate),
        0xE5 => SBC(.ZeroPage),
        0xF5 => SBC(.ZeroPageX),
        0xED => SBC(.Absolute),
        0xFD => SBC(.AbsoluteX),
        0xF9 => SBC(.AbsoluteY),
        0xE1 => SBC(.IndirectX),
        0xF1 => SBC(.IndirectY),

        0x38 => SEC(),
        0xF8 => SED(),
        0x78 => SEI(),

        0x85 => STA(.ZeroPage),
        0x95 => STA(.ZeroPageX),
        0x8D => STA(.Absolute),
        0x9D => STA(.AbsoluteX),
        0x99 => STA(.AbsoluteY),
        0x81 => STA(.IndirectX),
        0x91 => STA(.IndirectY),

        0x86 => STX(.ZeroPage),
        0x96 => STX(.ZeroPageY),
        0x8E => STX(.Absolute),

        0x84 => STY(.ZeroPage),
        0x94 => STY(.ZeroPageX),
        0x8C => STY(.Absolute),

        0xAA => TAX(),
        0xA8 => TAY(),
        0xBA => TSX(),
        0x8A => TXA(),
        0x9A => TXS(),
        0x98 => TYA(),

        else => unreachable
    }
}

// ===== OPCODE IMPLEMENTATIONS =====

fn ADC(addr_mode: AddressingMode) void {
    _ = addr_mode;
}

fn AND(addr_mode: AddressingMode) void {
    _ = addr_mode;
}

fn ASL(addr_mode: AddressingMode) void {
    _ = addr_mode;
}

fn BCC() void { }

fn BCS() void { }

fn BEQ() void { }

fn BIT(addr_mode: AddressingMode) void {
    _ = addr_mode;
}

fn BMI() void { }

fn BNE() void { }

fn BPL() void { }

fn BRK() void { }

fn BVC() void { }

fn BVS() void { }

fn CLC() void { }

fn CLD() void { }

fn CLI() void { }

fn CMP(addr_mode: AddressingMode) void {
    _ = addr_mode;
}

fn CPX(addr_mode: AddressingMode) void {
    _  = addr_mode;
}

fn CPY(addr_mode: AddressingMode) void {
    _ = addr_mode;
}

fn DEC(addr_mode: AddressingMode) void {
    _ = addr_mode;
}

fn DEX() void { }

fn DEY() void { }

fn EOR(addr_mode: AddressingMode) void {
    _ = addr_mode;
}

fn INC(addr_mode: AddressingMode) void {
    _ = addr_mode;
}

fn INX() void { }

fn INY() void { }

fn JMP(addr_mode: AddressingMode) void {
    _ = addr_mode;
}

fn JSR() void { }

fn LDA(addr_mode: AddressingMode) void {
    _ = addr_mode;
}

fn LDX(addr_mode: AddressingMode) void {
    _ = addr_mode;
}

fn LDY(addr_mode: AddressingMode) void {
    _ = addr_mode;
}

fn LSR(addr_mode: AddressingMode) void {
    _ = addr_mode;
}

fn NOP() void { }

fn ORA(addr_mode: AddressingMode) void {
    _ = addr_mode;
}

fn PHA() void { }

fn PHP() void { }

fn PLA() void { }

fn PLP() void { }

fn ROL(addr_mode: AddressingMode) void {
    _ = addr_mode;
}

fn ROR(addr_mode: AddressingMode) void {
    _ = addr_mode;
}

fn RTI() void { }

fn RTS() void { }

fn SBC(addr_mode: AddressingMode) void {
    _ = addr_mode;
    unreachable;
}

fn SEC() void { 
    p.Carry = 1;
}

fn SED() void { 
    p.Decimal = 1;
}

fn SEI() void { 
    // TODO should be delayed by one instruction
    p.InteruptDisable = 1;
}

fn STA(addr_mode: AddressingMode) void {
    writeWithMode(addr_mode, a);
}

fn STX(addr_mode: AddressingMode) void {
    writeWithMode(addr_mode, x);
}

fn STY(addr_mode: AddressingMode) void {
    writeWithMode(addr_mode, y);
}

fn TAX() void { 
    x = a;
    p.Zero = x == 0;
    p.Negative = isNegative(x);
}

fn TAY() void { 
    y = a;
    p.Zero = y == 0;
    p.Negative = isNegative(y);
}

fn TSX() void { 
    x = s;
    p.Zero = x == 0;
    p.Negative = isNegative(x);
}

fn TXA() void { 
    a = x;
    p.Zero = a == 0;
    p.Negative = isNegative(a);
}

fn TXS() void {
    s = x;
}

fn TYA() void { 
    a = y;
    p.Zero = a == 0;
    p.Negative = isNegative(a);
}
