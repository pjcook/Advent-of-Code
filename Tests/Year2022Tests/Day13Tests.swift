import XCTest
import InputReader
import Year2022

class Day13Tests: XCTestCase {
    
    let input = Input("Day13.input", Bundle.module).lines
    let day = Day13()

    func test_part1() throws {
//        measure {
        XCTAssertEqual(5720, try! day.part1(input))
//        }
    }
    
    func test_part2() throws {
//        measure {
        XCTAssertEqual(23504, try! day.part2(input))
//        }
    }
}

extension Day13Tests {
    func test_part1_parsing() throws {
        let result = try day.parse("[[[],4],4,4,4]")
        XCTAssertEqual(4, result.count)
        XCTAssertTrue(result[0] is [Any])
        XCTAssertTrue((result[0] as! [Any])[0] is [Any])
        XCTAssertTrue(((result[0] as! [Any])[0] as! [Any]).isEmpty)
        print(result)
        print()
        print(((result[0] as! [Any])[0] as! [Any]))
        print(((result[0] as! [Any])[1] as! Int))
        print(result[1])
        print(result[2])
        print(result[3])
    }
    
    func test_compare1() throws {
        let line1 = try day.parse("[1,1,3,1,1]")
        let line2 = try day.parse("[1,1,5,1,1]")
        let result = day.process(list1: line1, list2: line2)
        XCTAssertEqual(.rightOrder, result)
    }
    
    func test_compare2() throws {
        let line1 = try day.parse("[[1],[2,3,4]]")
        let line2 = try day.parse("[[1],4]")
        let result = day.process(list1: line1, list2: line2)
        XCTAssertEqual(.rightOrder, result)
    }
    
    func test_compare3() throws {
        let line1 = try day.parse("[9]")
        let line2 = try day.parse("[[8,7,6]]")
        let result = day.process(list1: line1, list2: line2)
        XCTAssertEqual(.wrongOrder, result)
    }
    
    func test_compare4() throws {
        let line1 = try day.parse("[[4,4],4,4]")
        let line2 = try day.parse("[[4,4],4,4,4]")
        let result = day.process(list1: line1, list2: line2)
        XCTAssertEqual(.rightOrder, result)
    }
    
    func test_compare5() throws {
        let line1 = try day.parse("[]")
        let line2 = try day.parse("[3]")
        let result = day.process(list1: line1, list2: line2)
        XCTAssertEqual(.rightOrder, result)
    }
    
    func test_compare6() throws {
        let line1 = try day.parse("[[[]]]")
        let line2 = try day.parse("[[]]")
        let result = day.process(list1: line1, list2: line2)
        XCTAssertEqual(.wrongOrder, result)
    }
    
    func test_compare7() throws {
        let line1 = try day.parse("[1,[2,[3,[4,[5,6,7]]]],8,9]")
        let line2 = try day.parse("[1,[2,[3,[4,[5,6,0]]]],8,9]")
        let result = day.process(list1: line1, list2: line2)
        XCTAssertEqual(.wrongOrder, result)
    }
    
    func test_compare8() throws {
        let line1 = try day.parse("[[[0,0,0]]]")
        let line2 = try day.parse("[2]")
        let result = day.process(list1: line1, list2: line2)
        XCTAssertEqual(.rightOrder, result)
    }

    func test_compare9() throws {
        let line1 = try day.parse("[[1,[4],4,2]]")
        let line2 = try day.parse("[[],[8,[6],1,3],[[]],[[9,8],[[]]]]")
        let result = day.process(list1: line1, list2: line2)
        XCTAssertEqual(.wrongOrder, result)
    }
}

extension Day13Tests {
    func test_part1_example() throws {
        let input = """
[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
""".lines
        let day = Day13()
        XCTAssertEqual(13, try day.part1(input))
    }
    
    func test_part2_example() throws {
        let input = """
[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
""".lines
        let day = Day13()
        XCTAssertEqual(140, try day.part2(input))
    }
}
