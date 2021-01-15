import XCTest
@testable import Dependable

protocol TestProtocol {
    var id: UUID { get }
}

class TestClass: TestProtocol {
    var id = UUID()
}


final class DependableTests: XCTestCase {

    override class func setUp() {
        DependencyResolver.current = DependencyResolver()
    }

    func testResolutionFlow() {

        let testFactoryMethod = {
            TestClass()
        }

        DependencyResolver.current.register(factory: testFactoryMethod, for: TestProtocol.self)
        XCTAssertNotNil(try! DependencyResolver.current.resolve(for: TestProtocol.self))

    }


    static var allTests = [
        ("testResolutionFlow", testResolutionFlow),
    ]
}
