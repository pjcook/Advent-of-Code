import XCTest
import InputReader
import Year2022

class Day11Tests: XCTestCase {
    
    let input = Input("Day11.input", Bundle.module).lines
    let day = Day11()

    func test_part1() {
//        measure {
        let monkeys = day.parse(input)
        XCTAssertEqual(62491, day.part1(monkeys))
//        }
    }
    
    func test_part2() {
//        measure {
        let monkeys = day.parse(input)
        XCTAssertEqual(17408399184, day.part2(monkeys))
//        }
    }
}

extension Day11Tests {
    func test_part1_example() {
        let input = """
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
""".lines
        let monkeys = day.parse(input)
        XCTAssertEqual(10605, day.part1(monkeys))
    }
    
    func test_part2_example() {
        let input = """
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
""".lines
        let monkeys = day.parse(input)
        XCTAssertEqual(2713310158, day.part2(monkeys))
    }
    
    func test_parse() {
        let input = """
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
""".lines
        let monkeys = day.parse(input)
        XCTAssertEqual(4, monkeys.count)
        XCTAssertEqual([79, 98], monkeys[0].list)
        XCTAssertEqual(Day11.Operation.multiply(19), monkeys[0].operation)
        XCTAssertEqual(23, monkeys[0].checkDivisor)
        XCTAssertEqual(2, monkeys[0].checkTrue)
        XCTAssertEqual(3, monkeys[0].checkFalse)
    }
}
