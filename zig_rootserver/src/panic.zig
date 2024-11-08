const std = @import("std");
const io = @import("io.zig");

fn panic(
    msg: []const u8,
    error_return_trace: ?*const std.builtin.StackTrace,
    first_trace_addr: ?usize,
) noreturn {
    io.stderr.print("{s} at {?} {?}\n", .{msg, error_return_trace, first_trace_addr}) catch unreachable;
    std.debug.defaultPanic(msg, error_return_trace, first_trace_addr);
}

const Implement = struct {
    pub const call = panic;
    pub const sentinelMismatch = std.debug.FormattedPanic.sentinelMismatch;
    pub const unwrapError = std.debug.FormattedPanic.unwrapError;
    pub const outOfBounds = std.debug.FormattedPanic.outOfBounds;
    pub const startGreaterThanEnd = std.debug.FormattedPanic.startGreaterThanEnd;
    pub const inactiveUnionField = std.debug.FormattedPanic.inactiveUnionField;
    pub const messages = std.debug.FormattedPanic.messages;
};

pub usingnamespace Implement;