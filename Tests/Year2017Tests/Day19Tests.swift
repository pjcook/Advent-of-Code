import XCTest
import InputReader
import Year2017

class Day19Tests: XCTestCase {
    
    let input = Input("Day19.input", Bundle.module, trimming: false).lines
    let day = Day19()

    func test_part1() {
//        measure {
        XCTAssertEqual("GINOWKYXH", day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
     |          
     |  +--+    
     A  |  C    
 F---|----E|--+ 
     |  |  |  D 
     +B-+  +--+ 
""".lines
        XCTAssertEqual("ABCDEF", day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(16636, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
     |          
     |  +--+    
     A  |  C    
 F---|----E|--+ 
     |  |  |  D 
     +B-+  +--+ 
""".lines
        XCTAssertEqual(38, day.part2(input))
    }
}
