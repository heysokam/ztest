//:_____________________________________________________________________
//  ztest  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_____________________________________________________________________
// @deps ztest
const ztest = @import("./ztest.zig");
const it    = ztest.it;

//______________________________________
// @section Validate Usage
//____________________________
var  BaseCases = ztest.title("ztest | Base Functionality");
test BaseCases { BaseCases.begin(); defer BaseCases.end();

try ztest.err(error.HelloIt,
  it("should run with an error", struct { fn f() !void {
    return error.HelloIt;
  }}.f)
);

try it("should run without an error", struct { fn f() !void {
  return;
}}.f);

} //:: ztest.BaseCases

