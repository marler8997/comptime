const std = @import("std");
pub export fn _start() callconv(.Naked) noreturn {
    std.os.exit(modify(76));
}
fn modify(n: u8) u8 { return n + 1; }
