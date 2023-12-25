import XCTest
import InputReader
import Year2023

class Day25Tests: XCTestCase {
    
    let input = Input("Day25.input", Bundle.module).lines
    let day = Day25()

    func test_part1() {
//        measure {
        XCTAssertEqual(559143, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        /* hfx/pzl, bvb/cmg, nvd/jqt */
        let input = """
jqt: rhn xhk nvd
rsh: frs pzl lsr
xhk: hfx
cmg: qnr nvd lhk bvb
rhn: xhk bvb hfx
bvb: xhk hfx
pzl: lsr hfx nvd
qnr: nvd
ntq: jqt hfx bvb xhk
nvd: lhk
lsr: lhk
rzs: qnr cmg lsr rsh
frs: qnr lhk lsr
""".lines
        XCTAssertEqual(54, day.part1(input))
    }
}
