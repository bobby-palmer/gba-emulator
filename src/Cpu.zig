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

// CPU STATE

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

/// Execute the next instruction and update cycle count accordingly.
fn execute_instruction() void {
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

        // Start with C's

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
