import XCTest
import InputReader
import Year2015

class Day20Tests: XCTestCase {
    
    let day = Day20()

    func test_part1() {
        XCTAssertEqual(831600, day.part1(36000000))
    }
    
    func test_part1_example() {
        var i = 0
        let a = 856800
        var lowest = Int.max
        for count in (0...a).reversed() {
            i += 1
            var newResult = 0
            let range: [Int] = Array(1...max(1,count/2)) + [count]
            for i in range {
                if count % i == 0 {
                    newResult += i * 10
                }
            }
            if newResult >= 36000000 {
                print(count, newResult, newResult >= 36000000)
                lowest = min(lowest, count)
            }
            if lowest - count > 50000 {
                break
            }
        }
        XCTAssertEqual(831600, lowest)
    }
    
    func test_part2() {
        XCTAssertEqual(884520, day.part2(36000000))
    }
    
//    func test_example() {
//        XCTAssertEqual(1, day.part1(10))
//        XCTAssertEqual(2, day.part1(30))
//        XCTAssertEqual(3, day.part1(40))
//        XCTAssertEqual(4, day.part1(70))
//        XCTAssertEqual(4, day.part1(60))
//        XCTAssertEqual(6, day.part1(120))
//        XCTAssertEqual(6, day.part1(80))
//        XCTAssertEqual(8, day.part1(150))
//        XCTAssertEqual(8, day.part1(130))
//    }
}
