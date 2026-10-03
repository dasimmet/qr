const std = @import("std");
const qr_code = @import("src/index.zig");
const ansi_renderer = @import("src/ansi-renderer.zig");

const cli = @import("src/cli.zig");

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);

    const options = cli.parseCliArgs(args);

    const matrix = try qr_code.create(arena, options);
    defer matrix.deinit();

    try ansi_renderer.render(init.io, matrix);
}
