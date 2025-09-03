@testable import GridNavigation
import XCTest

final class GridNavigationTests: XCTestCase {
    struct TestItem: GridNavigable {
        let id = UUID()
        let title: String
    }

    func testGridNavigableProtocol() {
        let item = TestItem(title: "Test Item")

        XCTAssertNotNil(item.id)
        XCTAssertEqual(item.title, "Test Item")
    }

    func testGridNavigableHashable() {
        let item1 = TestItem(title: "Test Item 1")
        let item2 = TestItem(title: "Test Item 2")

        XCTAssertNotEqual(item1, item2)
        XCTAssertNotEqual(item1.hashValue, item2.hashValue)
    }

    func testGridNavigableIdentifiable() {
        let item = TestItem(title: "Test Item")

        XCTAssertEqual(item.id, item.id) // ID should be stable
    }
}
