const std = @import("std");
pub export fn _start() callconv(.Naked) noreturn {
    std.os.exit(modify(76));
}
fn modify(n: u8) u8 {
    const buffer = [1]u8 { @intCast(u8, 0xFF & n) };
    return @intCast(u8, 0xFF & djb2(&buffer));
}
fn djb2(msg: []const u8) usize {
    var hash : u32 = 5381;
    var i : usize = 0;
    while (i < msg.len) : (i += 1) {
        hash = ((hash << 5) + hash) + msg[i];
    }
    return hash;
}