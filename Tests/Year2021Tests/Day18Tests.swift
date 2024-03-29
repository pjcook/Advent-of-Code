import XCTest
import InputReader
import Year2021

class Day18Tests: XCTestCase {
    
    let input = Input("Day18.input", .module).lines
    let day = Day18()

    /*
     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     !!!  IMPORTANT - GO LOOK IN THE Day19Testsb file instead  !!!
     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     */
    
    
    func test_part1() {
        XCTAssertEqual(6963, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(0, day.part2(input))
    }
    
    func test_cleaning() {
//        day.parse("[1,2]")
//        day.parse("[[1,9],[8,5]]")
//        day.parse("[[[[1,2],[3,4]],[[5,6],[7,8]]],9]")
        _ = day.parse("[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]")
    }
    
    func test_examples() {
        XCTAssertEqual(143, day.solve("[[1,2],[[3,4],5]]"))
        XCTAssertEqual(1384, day.solve("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"))
        XCTAssertEqual(445, day.solve("[[[[1,1],[2,2]],[3,3]],[4,4]]"))
        XCTAssertEqual(791, day.solve("[[[[3,0],[5,3]],[4,4]],[5,5]]"))
        XCTAssertEqual(1137, day.solve("[[[[5,0],[7,4]],[5,5]],[6,6]]"))
        XCTAssertEqual(3488, day.solve("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"))
        XCTAssertEqual(4140, day.solve("[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]"))
    }
    
    func test_checking() {
//        XCTAssertEqual("[[[[0,9],2],3],4]", process("[[[[[9,8],1],2],3],4]"))
//        XCTAssertEqual("[7,[6,[5,[7,0]]]]", process("[7,[6,[5,[4,[3,2]]]]]"))
//        XCTAssertEqual("[[6,[5,[7,0]]],3]", process("[[6,[5,[4,[3,2]]]],1]"))
//        XCTAssertEqual("[[3,[2,[8,0]]],[9,[5,[7,0]]]]", process("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]"))
//        XCTAssertEqual("[[3,[2,[8,0]]],[9,[5,[7,0]]]]", process("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]"))
//
//        XCTAssertEqual("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]", process("[[[[4,3],4],4],[7,[[8,4],9]]]", "[1,1]"))
        
        XCTAssertEqual("[[[[4,0],[5,4]],[[7,7],[6,0]]],[[7,[5,5]],[[0,[6,6]],[7,0]]]]", process("[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]", "[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]"))
//        XCTAssertEqual("[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]", process("[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]", "[2,9]"))
    }
    
    func process(_ input: String) -> String {
        let pair = day.parse(input)!
        _ = pair.check()
        return pair.description
    }
    
    func process(_ input1: String, _ input2: String) -> String {
        let pair = Day18.Pair(
            left: day.parse(input1)!,
            right: day.parse(input2)!
        )
        _ = pair.check()
        return pair.description
    }
    
    func test_example_main() {
        let input = """
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
""".lines
        XCTAssertEqual(5433, day.part1(input))
    }
}
