import XCTest
import InputReader
import StandardLibraries
import Year2021

class Day15Tests: XCTestCase {
    
    let input = Input("Day15.input", Year2021.bundle).lines
    lazy var grid = Grid<Int>(input)

    func test_part1() {
        XCTAssertEqual(769, grid.dijkstra(start: .zero, end: Point(grid.columns - 1, grid.rows - 1)))
    }
    
    func test_part2() {
        XCTAssertEqual(2963, grid.dijkstra(start: .zero, end: Point(grid.columns * 5 - 1, grid.rows * 5 - 1), maxPoint: Point(grid.columns * 5, grid.rows * 5)))
    }
    
    func test_part1_aStar() {
        XCTAssertEqual(769, grid.aStar(start: .zero, end: Point(grid.columns - 1, grid.rows - 1)))
    }
    
    func test_part2_aStar() {
        XCTAssertEqual(2963, grid.aStar(start: .zero, end: Point(grid.columns * 5 - 1, grid.rows * 5 - 1), maxPoint: Point(grid.columns * 5, grid.rows * 5)))
    }
}
