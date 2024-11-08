const std = @import("std");

const Kind = enum {
    stdout,
    stderr,
};

pub const Writer = std.io.Writer(Kind, error{}, write);
pub const stdout: Writer = .{ .context = .stdout };
pub const stderr: Writer = .{ .context = .stderr };

fn write(_: Kind, bytes: []const u8) error{}!usize {
    for (bytes) |byte| @import("root").c.seL4_DebugPutChar(byte);
    return bytes.len;
}

pub fn print(comptime format: []const u8, args: anytype) void {
    stdout.print(format, args) catch unreachable;
}
