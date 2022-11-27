import XCTest
import InputReader
import Year2015

class Day14Tests: XCTestCase {
    
    let input = Input("Day14.input", .module).lines
    let day = Day14()

    func test_part1() throws {
//        measure {
        XCTAssertEqual(2640, try! day.part1(input, totalTime: 2503))
//        }
    }
    
    func test_part2() throws {
//        measure {
        XCTAssertEqual(1102, try! day.part2(input, totalTime: 2503))
//        }
    }
    
    func test_parsing() throws {
        let reindeer = try day.parse(input)
        guard let deer = reindeer.first else {
            XCTFail()
            return
        }
        // Dancer can fly 27 km/s for 5 seconds, but then must rest for 132 seconds.
        XCTAssertEqual("Dancer", deer.name)
        XCTAssertEqual(27, deer.speed)
        XCTAssertEqual(5, deer.time)
        XCTAssertEqual(132, deer.rest)
    }
    
    func test_examples() throws {
        let deer1 = try Day14.Reindeer("Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.")
        let deer2 = try Day14.Reindeer("Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.")
        XCTAssertEqual(1120, deer1.distance(in: 1000))
        XCTAssertEqual(1056, deer2.distance(in: 1000))
    }
}
