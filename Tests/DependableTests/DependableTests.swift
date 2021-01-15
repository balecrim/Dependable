import XCTest
@testable import Dependable

final class DependableTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Dependable().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
