import XCTest

import SwiftCSSTests

var tests = [XCTestCaseEntry]()
tests += ColorTests.allTests()
tests += CascadeTests.allTests()
XCTMain(tests)
