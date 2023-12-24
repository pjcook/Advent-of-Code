import XCTest
import InputReader
import StandardLibraries
import Year2023

class Day24Tests: XCTestCase {
    
    let input = Input("Day24.input", Bundle.module).lines
    let day = Day24()

    func test_part1() {
//        measure {
        XCTAssertEqual(25810, day.part1(input, minValue: 200000000000000, maxValue: 400000000000000))
//        }
    }
    
    func test_part1_example() {
        let input = """
19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3
""".lines
        XCTAssertEqual(2, day.part1(input, minValue: 7, maxValue: 27))
    }
    
    func test_part1_example1() {
        let a1 = Point(19,13)
        let a2 = Point(17,14)
        let b1 = Point(20,19)
        let b2 = Point(21,14)
        if let (x,y) = Point.intersectionOfLines(a1: a1, a2: a2, b1: b1, b2: b2) {
            print("X",x,"Y",y)
        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(652666650475950, day.part2(input))
//        }
    }
}
