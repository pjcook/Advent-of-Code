import XCTest
import InputReader
import Year2024

class Day23Tests: XCTestCase {
    
    let input = Input("Day23.input", Bundle.module).lines
    let day = Day23()

    func test_part1() {
//        measure {
        XCTAssertEqual(1218, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn
""".lines
        XCTAssertEqual(7, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual("ah,ap,ek,fj,fr,jt,ka,ln,me,mp,qa,ql,zg", day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn
""".lines
        XCTAssertEqual("co,de,ka,ta", day.part2(input))
    }
}
