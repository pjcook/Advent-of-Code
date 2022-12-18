import XCTest
import InputReader
import StandardLibraries
import Year2022

class Day18Tests: XCTestCase {
    
    let input = Input("Day18.input", Bundle.module).lines
    let day = Day18()

    func test_part1() {
//        measure {
        XCTAssertEqual(4192, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(2520, day.part2(input))
//        }
    }
}

extension Day18Tests {
    public func test_part1_example() {
        let input = """
2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5
""".lines
        XCTAssertEqual(64, day.part1(input))
    }
    
    public func test_part2_example() {
        let input = """
2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5
""".lines
        XCTAssertEqual(58, day.part2(input))
    }
    
    public func test_part2_example3() {
        var input = [String]()
        var ignore = Set<Vector>()
        
        for z in (2...4) {
            for y in (2...4) {
                for x in (2...4) {
                    ignore.insert(Vector(x: x, y: y, z: z))
                }
            }
        }
        
        for z in (1...5) {
            for y in (1...5) {
                for x in (1...5) {
                    if !ignore.contains(Vector(x: x, y: y, z: z)) {
                        input.append("\(x),\(y),\(z)")
                    }
                }
            }
        }
        
        input.append("3,4,3")
        input.append("3,2,3")
        input.append("2,3,3")
        input.append("4,3,3")
        input.append("3,3,4")
        input.append("3,3,2")

        XCTAssertEqual(150, day.part2(input))
    }
}
