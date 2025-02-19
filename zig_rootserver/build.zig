const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const includes_opt = b.option([]const []const u8, "include", "include search path");
    const libs_opt = b.option([]const []const u8, "library", "library search path");

    const exe = b.addExecutable(.{
        .name = "zig_rootserver",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.addAssemblyFile(b.path("src/start.S"));
    exe.stack_size = 0;
    exe.linkSystemLibrary("sel4");
    if (includes_opt) |includes| for (includes) |inc| {
        exe.addIncludePath(.{ .cwd_relative = inc });
    };
    if (libs_opt) |libraries| for (libraries) |library| {
        exe.addLibraryPath(.{ .cwd_relative = library });
    };
    b.installArtifact(exe);
}
