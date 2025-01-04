import XCTest
import InputReader
import Year2017

class Day16Tests: XCTestCase {
    
    let input = Input("Day16.input", Bundle.module).input
    let day = Day16()

    func test_part1() {
//        measure {
        XCTAssertEqual("nlciboghjmfdapek", day.part1(input, list: "abcdefghijklmnop"))
//        }
    }
    
    func test_part1_example() {
//        measure {
        XCTAssertEqual("baedc", day.part1("s1,x3/4,pe/b", list: "abcde"))
        XCTAssertEqual("ceadb", day.part1("s1,x3/4,pe/b", list: "baedc"))
//        }
    }
    
    func test_part2() {
//        measure {
        // eagidkbohjfpnmlc
        // nlciboghjmfdapek
        // njcihakofgmbpeld
        // nlciboghmkedpfja
        // nmcihpaoegkbfjld
        XCTAssertEqual("nlciboghmkedpfja", day.part2(input, list: "abcdefghijklmnop", count: 1000000000))
//        }
    }
    
    func test_part2_example() {
//        measure {
        XCTAssertEqual("ceadb", day.part2("s1,x3/4,pe/b", list: "abcde", count: 6))
//        }
    }
}
