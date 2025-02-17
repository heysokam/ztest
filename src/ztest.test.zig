//:_____________________________________________________________________
//  ztest  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_____________________________________________________________________
// @deps ztest
const ztest = @import("./ztest.zig");
const it    = ztest.it;

//______________________________________
// @section Validate Usage
//____________________________
const BaseCases = ztest.title("ztest | Base Functionality");
test BaseCases { BaseCases.begin(); defer BaseCases.end();

const Expected = error.HelloIt;
try ztest.err(Expected,
  it("should run with an error", struct { fn f() !void {
    return Expected;
  }}.f)
);

try it("should run without an error", struct { fn f() !void {
  return;
}}.f);

} //:: ztest.BaseCases

