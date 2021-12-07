import XCTest
import InputReader
import Year2021

class Day6Tests: XCTestCase {
    
    let input = Input("Day6.input", Year2021.bundle).delimited(",", cast: { Int($0)! })
    let day = Day6()

    func test_part1() {
        measure {
        XCTAssertEqual(354564, day.part2(input, days: 80))
        }
    }
    
    func test_part2() {
        measure {
        XCTAssertEqual(1609058859115, day.part2(input, days: 256))
        }
    }
    
    func test_part2b() {
        measure {
        XCTAssertEqual(1609058859115, day.part2b(input, days: 256))
        }
    }
    
    func test_example() {
        XCTAssertEqual(26, day.part1([3,4,3,1,2], days: 18))
        XCTAssertEqual(5934, day.part1([3,4,3,1,2], days: 80))
        XCTAssertEqual(26984457539, day.part1([3,4,3,1,2], days: 256))
    }
    
    func test_example2() {
        XCTAssertEqual(26, day.part2([3,4,3,1,2], days: 18))
//        XCTAssertEqual(5934, day.part2([3,4,3,1,2], days: 80))
//        XCTAssertEqual(26984457539, day.part2([3,4,3,1,2], days: 256))
    }
    
    func test_example3() {
        XCTAssertEqual(26, day.part2b([3,4,3,1,2], days: 18))
        XCTAssertEqual(5934, day.part2b([3,4,3,1,2], days: 80))
        XCTAssertEqual(26984457539, day.part2b([3,4,3,1,2], days: 256))
    }
    
    func test_circularArray() {
        let array = CircluarArray([1,2,3])
        
        XCTAssertEqual(0, array.currentIndex)
        
        array.increment()
        XCTAssertEqual(1, array.currentIndex)
//        XCTAssertEqual(2, array.values[array.currentIndex])
        
        XCTAssertEqual(2, array.index(byAdding: 4))
    }
}
