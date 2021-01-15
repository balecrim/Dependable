import XCTest

import DependableTests

var tests = [XCTestCaseEntry]()
tests += DependableTests.allTests()
XCTMain(tests)
