//:_____________________________________________________________________
//  ztest  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_____________________________________________________________________
pub const ztest = @This();
// @deps std
const std = @import("std");
// @deps zdk
const zstd = struct {
  const cstr = []const u8;
};

//______________________________________
// @section Types
//____________________________
pub const string = zstd.cstr;
pub const Fn     = fn () anyerror!void;


//______________________________________
// @section Forward Exports
//____________________________
pub const A      = std.testing.allocator;
pub const ok     = std.testing.expect;
pub const err    = std.testing.expectError;
pub const log    = struct {
  pub const info = std.debug.print;
};
pub fn eq     (value :anytype, expected :anytype) !void { try std.testing.expectEqual(expected, value); }
pub fn eq_str (value :anytype, expected :anytype) !void { try std.testing.expectEqualStrings(expected, value); }
pub const not = struct {
  pub fn ok (value :bool) !void { try ztest.ok(!value); }
  pub fn eq (value :anytype, expected :anytype) !void { try ztest.ok(ztest.check.not.eq(value, expected)); }
  pub fn eq_str (value :anytype, expected :anytype) !void { try ztest.not.ok(std.mem.eql(@TypeOf(value[0]), value, expected)); }
};


//______________________________________
// @section Boolean Checks
//____________________________
pub const check = struct {
  pub fn eq (value :anytype, expected :anytype) bool { switch (@typeInfo(@TypeOf(value))) {
    .pointer => return std.mem.eql(@TypeOf(value[0]), expected, value),
    .void    => return @TypeOf(value) == @TypeOf(expected),
    else     => return value == expected,
  }}
  pub const not = struct {
    pub fn eq (value :anytype, expected :anytype) bool { return !ztest.check.eq(value, expected); }
  };
};

//______________________________________
// @section Configuration
//____________________________
const Prefix = struct {
  const pass = " ✓  ";
  const fail = "[𐄂] ";
  const name = "[߹] ztest";
  const cli  = ztest.Prefix.name++": ";
};

//______________________________________
// @section Title Tools
//____________________________
var currentID :?*u32= null;
pub const Title = struct {
  data :ztest.string,
  id   :u32= 0,
  pub fn create (data :ztest.string) ztest.Title { return .{.data= data}; }
  pub fn begin (T :*ztest.Title) void { ztest.log.info("{s}Testing {s} ...\n",   .{ztest.Prefix.cli, T.data}); currentID = &T.id; }
  pub fn end   (T :*ztest.Title) void { ztest.log.info("{s}Done testing {s}.\n", .{ztest.Prefix.cli, T.data}); currentID = null; }
};
pub const title = Title.create;

//______________________________________
// @section Describe Tools
//____________________________
fn pass (comptime msg :ztest.string) void { ztest.log.info("{s}{?d:0>2} | {s}\n", .{ztest.Prefix.pass, currentID.?.*, msg}); }
fn fail (e :anyerror, comptime msg :ztest.string) anyerror { ztest.log.info("{s}{s}: {?d:0>2} | {s}\n", .{ztest.Prefix.fail, @errorName(e), currentID.?.*, msg}); return e; }

pub fn it (
    comptime msg       : ztest.string,
    comptime statement : ztest.Fn,
  ) !void {
  currentID.?.* = if (currentID == null) 0 else currentID.?.* + 1;
  statement() catch |e| { return ztest.fail(e, msg); };
  ztest.pass(msg);
}

