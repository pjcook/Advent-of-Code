import XCTest
import InputReader
import Year2015

class Day8Tests: XCTestCase {
    
    let input = Input("Day8.input", .module).lines
    let day = Day8()

    func test_part1() throws {
        XCTAssertEqual(1350, try day.part1(input))
    }
    
    func test_part2() throws {
        XCTAssertEqual(2085, try day.part2(input))
    }
    
    func test_examples() throws {
        let a = "\"\""
        let b = "\"abc\""
        let c = "\"aaa\\\"aaa\""
        let d = "\"\\x27\""
        let e = "\"\\x27\\x27\""
        let f = "\"\\x27\\x28\""
        let g = "\"\\x27\\x88\""
        
        XCTAssertEqual(2, a.count)
        XCTAssertEqual(5, b.count)
        XCTAssertEqual(10, c.count)
        XCTAssertEqual(6, d.count)
        XCTAssertEqual(10, e.count)
        XCTAssertEqual(10, f.count)
        XCTAssertEqual(10, g.count)
        XCTAssertEqual(0, try day.parse(a).count)
        XCTAssertEqual(3, try day.parse(b).count)
        XCTAssertEqual(7, try day.parse(c).count)
        XCTAssertEqual(1, try day.parse(d).count)
        XCTAssertEqual(2, try day.parse(e).count)
        XCTAssertEqual(2, try day.parse(f).count)
        XCTAssertEqual(2, try day.parse(g).count)
        XCTAssertEqual("", try day.parse(a))
        XCTAssertEqual("abc", try day.parse(b))
        XCTAssertEqual("aaa\"aaa", try day.parse(c))
        XCTAssertEqual("'", try day.parse(d))
        XCTAssertEqual("''", try day.parse(e))
        XCTAssertEqual("'(", try day.parse(f))
        XCTAssertEqual("'\(day.hex2ascii(input: "88"))", try day.parse(g))
        let result = day.hex2ascii(input: "88")
        print(result, result.count)
    }
    
    func test_examples2() throws {
        let input = """
        ""
        "abc"
        "aaa\\\"aaa"
        "\\x27"
        """.components(separatedBy: "\n")
        XCTAssertEqual(12, try day.part1(input))
    }
    
    func test_examples2_part2() throws {
        let input = """
        ""
        "abc"
        "aaa\\\"aaa"
        "\\x27"
        """.components(separatedBy: "\n")
        XCTAssertEqual(19, try day.part2(input))
    }
    
    func test_examples3() throws {
        var totalCodeSize = 0
        var totalMemorySize = 0
        for line in input {
            let codeSize = line.count
            let code = try day.parse(line)
            let memorySize = code.count
            print(line, codeSize, memorySize, code)
            totalCodeSize += codeSize
            totalMemorySize += memorySize
        }
        print(totalCodeSize, totalMemorySize, totalCodeSize - totalMemorySize)
    }
    
    func test_examples4() throws {
        let input = """
        "rjjkfh\\x78cf\\x2brgceg\\\"jmdyas\\\"\\xlv\\xb6p"
        """.components(separatedBy: "\n")
        let parsed = try day.parse(input[0])
        XCTAssertEqual(26, parsed.count)
        XCTAssertEqual(16, try day.part1(input))
        print(input[0], parsed)
    }
}
