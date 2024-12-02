import XCTest
import InputReader
import StandardLibraries
import Year2024

class Day15Tests: XCTestCase {
    
    let input = Input("Day15.input", Bundle.module).input
    let day = Day15()

    func test_part1() {
//        measure {
        XCTAssertEqual(521434, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        XCTAssertEqual("H".toAscii().first!, 72)
        XCTAssertEqual("H".toAscii().first! * 17, 1224)
        XCTAssertEqual(("H".toAscii().first! * 17) % 256, 200)
        
        XCTAssertEqual("A".toAscii().first!, 65)
        XCTAssertEqual("S".toAscii().first!, 83)
        XCTAssertEqual("H".toAscii().first!, 72)
        
        XCTAssertEqual("HASH".toAscii().reduce(0) { (($0 + $1) * 17) % 256 }, 52)
        XCTAssertEqual("rn=1".toAscii().reduce(0) { (($0 + $1) * 17) % 256 }, 30)
        
        XCTAssertEqual(day.part1("rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"), 1320)
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(248279, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        XCTAssertEqual(day.part2("rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"), 145)
    }
}
