const std = @import("std");
const syscall = @import("./syscall.zig");
pub export fn _start() callconv(.Naked) noreturn {
    std.os.exit(76);
}
