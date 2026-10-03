const std = @import("std");
const BitMatrix = @import("bit-matrix.zig").BitMatrix;

const ANSIColors = struct {
    const Reset = "\u{001B}[0m";
    const BgBlack = "\u{001B}[40m";
    const BgWhite = "\u{001B}[47m";
};

pub fn render(io: std.Io, matrix: BitMatrix) !void {
    try printMatrix(io, matrix, ANSIColors.BgBlack, ANSIColors.BgWhite);
}

fn printMatrix(io: std.Io, matrix: BitMatrix, trueColor: []const u8, falseColor: []const u8) !void {
    var buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writerStreaming(io, &buffer);
    const stdout = &stdout_writer.interface;

    for (0..matrix.size) |r| {
        for (0..matrix.size) |c| {
            const value = matrix.get(r, c);
            const color = if (value == 1) trueColor else falseColor;
            try stdout.print("{s}  {s}", .{ color, ANSIColors.Reset });
        }

        try stdout.print("\n", .{});
    }
    try stdout.flush();
}
