const std = @import("std");

pub fn all(
    T         : type,
    buf       : []const T,
    predicate : fn (val: T) bool,
  ) bool {
  for (buf) |val| if (!predicate(val)) return false;
  return true;
}

test "test all" {
  const arr_1 = [_]i32{1} ** 5;
  try std.testing.expect(
    all(i32, arr_1[0..], struct {
      pub fn eql(val: i32) bool { return val == 1; }
    }.eql)
  );
}


