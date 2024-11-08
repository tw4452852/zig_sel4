const std = @import("std");
const io = @import("io.zig");
pub const c = @cImport({
    @cInclude("sel4/syscalls.h");
    @cInclude("sel4/bootinfo.h");
});

pub const Panic = @import("panic.zig");

export fn __assert_fail(str: [*c]const u8, file: [*c]const u8, line: c_int, function: [*c]const u8) callconv(.C) void {
    io.stderr.print("{s}:{d}:{s}: {s}\n", .{ file, line, function, str }) catch unreachable;
}

export fn strcpy(dst: [*c]u8, src: [*c]const u8) callconv(.C) void {
    var i: usize = 0;
    while (src.* != 0) : (i += 1) {
        dst[i] = src[i];
    }
}

export fn main(bi: *const c.seL4_BootInfo) callconv(.C) void {
    io.print("hello zig on Node {d}/{d}\n", .{ bi.nodeID, bi.numNodes });
    io.print("IPC buffer: {*}\n", .{bi.ipcBuffer});
    io.print("Empty slots: {d} --> {d}\n", .{ bi.empty.start, bi.empty.end });
    io.print("Untypeds slots: {d} --> {d}\n", .{ bi.untyped.start, bi.untyped.end });
    io.print("Memory info:\n", .{});
    for (0..bi.untyped.end - bi.untyped.start) |i| {
        const untyped = bi.untypedList[i];
        io.print("{s}:0x{x}, size: {}\n", .{
            if (untyped.isDevice == 1) "dev" else "mem",
            untyped.paddr,
            std.fmt.fmtIntSizeBin(@as(u64, 1) << @truncate(untyped.sizeBits)),
        });
    }
}
