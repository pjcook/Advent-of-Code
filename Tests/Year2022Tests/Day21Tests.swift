import XCTest
import InputReader
import Year2022

class Day21Tests: XCTestCase {
    
    let input = Input("Day21.input", Bundle.module).lines
    let day = Day21()

    func test_part1() {
//        measure {
        XCTAssertEqual(159591692827554, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(3509819803065, day.part2(input))
//        }
    }
}

extension Day21Tests {
    func test_part1_example() {
        let input = """
root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32
""".lines
        XCTAssertEqual(152, day.part1(input))
    }
    
    func test_part2_example() {
        let input = """
root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32
""".lines
        XCTAssertEqual(301, day.part2(input))
    }
}
