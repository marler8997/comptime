const std = @import("std");
pub export fn _start() callconv(.Naked) noreturn {
    std.os.exit(modify(76));
}
fn modify(n: u8) u8 {
    var mutable_n = n;
    var i : usize = 0;
    while (i < 10) : (i += 1) {
        mutable_n += 1;
    }
    return mutable_n;
}
