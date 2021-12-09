import XCTest
import InputReader
import Year2021

class Day8Tests: XCTestCase {
    
    let input = Input("Day8.input", Year2021.bundle).lines
    let day = Day8()

    func test_part1() throws {
//        measure {
        XCTAssertEqual(342, try! day.part1(input))
//        }
    }
    
    func test_part2() throws {
        measure {
        XCTAssertEqual(1068933, try! day.part2(input))
        }
    }
    
    func test_part2b() throws {
        measure {
        XCTAssertEqual(1068933, try! day.part2b(input))
        }
    }
    
    func test_parsing() throws {
        let grid = try day.parse(input)
        XCTAssertEqual(200, grid.rows)
        XCTAssertEqual(14, grid.columns)
    }
    
    func test_example() throws {
        let input = """
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
""".lines
        XCTAssertEqual(26, try day.part1(input))
    }
    
    func test_example2() throws {
        let input = """
acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf
""".lines
        XCTAssertEqual(5353, try! day.part2(input))
    }
}
