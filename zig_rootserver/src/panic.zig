const std = @import("std");
const io = @import("io.zig");

fn panic(
    msg: []const u8,
    first_trace_addr: ?usize,
) noreturn {
    io.stderr.print("{s} at {?}\n", .{ msg, first_trace_addr }) catch unreachable;
    std.debug.defaultPanic(msg, first_trace_addr);
}

pub usingnamespace std.debug.FullPanic(panic);
