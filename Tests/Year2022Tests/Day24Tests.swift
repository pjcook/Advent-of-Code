import XCTest
import InputReader
import Year2022

class Day24Tests: XCTestCase {
    
    let input = Input("Day24.input", Bundle.module).lines
    let day = Day24()

    func test_part1() {
//        measure {
        XCTAssertEqual(232, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(715, day.part2(input))
        // 735 high
//        }
    }
}

extension Day24Tests {
    func test_part1_example() {
        let input = """
#.######
#>>.<^<#
#.<..<<#
#>v.><>#
#<^v^^>#
######.#
""".lines
        XCTAssertEqual(18, day.part1(input))
    }
    
    func test_part2_example() {
        let input = """
#.######
#>>.<^<#
#.<..<<#
#>v.><>#
#<^v^^>#
######.#
""".lines
        XCTAssertEqual(54, day.part2(input))
    }
    
    func test_time_createSignature() {
        let grid = day.parse(input)
        measure {
            _ = day.calculateWindSignature(grid)
        }
    }
    
    func test_sets() {
        measure {
            var set = Set<String>()
            for _ in (0..<10000) {
                set.insert(UUID().uuidString)
            }
            XCTAssertFalse(set.contains("I'm not here"))
        }
    }
    
    func test_dictionary() {
        measure {
            var dict = [String:Int]()
            for i in (0..<10000) {
                dict[UUID().uuidString] = i
            }
            XCTAssertNil(dict["I'm not here"])
        }
    }

}
