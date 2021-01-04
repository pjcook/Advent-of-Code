import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day10Tests: XCTestCase {
    let input = Input("Day10.input", Year2018.bundle).lines
    
    func test_part1() {
        let day = Day10()
        _ = day.part1(input, lineHeight: 10)
//        XCTAssertEqual(398048, day.solve(71307, players: 458))
    }
    
    func test_parse() {
        let day = Day10()
        let data = day.parse(input)
        XCTAssertEqual(328, data.count)
    }
    
    func test_point_multiplication() {
        let point = Point(x: 3, y: 9)
        let velocity = Point(x: 1, y: -2)
        let vel2 = velocity * 3
        XCTAssertEqual(Point(x: 3, y: -6), vel2)
        let position = point + vel2
        XCTAssertEqual(Point(x: 6, y: 3), position)
    }
    
    func test_part1_example1() {
        let input = """
        position=< 9,  1> velocity=< 0,  2>
        position=< 7,  0> velocity=<-1,  0>
        position=< 3, -2> velocity=<-1,  1>
        position=< 6, 10> velocity=<-2, -1>
        position=< 2, -4> velocity=< 2,  2>
        position=<-6, 10> velocity=< 2, -2>
        position=< 1,  8> velocity=< 1, -1>
        position=< 1,  7> velocity=< 1,  0>
        position=<-3, 11> velocity=< 1, -2>
        position=< 7,  6> velocity=<-1, -1>
        position=<-2,  3> velocity=< 1,  0>
        position=<-4,  3> velocity=< 2,  0>
        position=<10, -3> velocity=<-1,  1>
        position=< 5, 11> velocity=< 1, -2>
        position=< 4,  7> velocity=< 0, -1>
        position=< 8, -2> velocity=< 0,  1>
        position=<15,  0> velocity=<-2,  0>
        position=< 1,  6> velocity=< 1,  0>
        position=< 8,  9> velocity=< 0, -1>
        position=< 3,  3> velocity=<-1,  1>
        position=< 0,  5> velocity=< 0, -1>
        position=<-2,  2> velocity=< 2,  0>
        position=< 5, -2> velocity=< 1,  2>
        position=< 1,  4> velocity=< 2,  1>
        position=<-2,  7> velocity=< 2, -2>
        position=< 3,  6> velocity=<-1, -1>
        position=< 5,  0> velocity=< 1,  0>
        position=<-6,  0> velocity=< 2,  0>
        position=< 5,  9> velocity=< 1, -2>
        position=<14,  7> velocity=<-2,  0>
        position=<-3,  6> velocity=< 2, -1>
        """.lines
        let day = Day10()
        _ = day.part1(input, lineHeight: 8)
    }
}
