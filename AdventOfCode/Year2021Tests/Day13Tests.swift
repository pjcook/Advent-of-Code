import XCTest
import InputReader
import Year2021

class Day13Tests: XCTestCase {
    
    let input = Input("Day13.input", Year2021.bundle).lines
    let day = Day13()

    func test_part1() {
//        measure {
        XCTAssertEqual(678, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(95, day.part2(input))
//        }
        
        // printed output in console
//        ####..##..####.#..#.#....#..#.####.####.
//        #....#..#.#....#..#.#....#..#....#.#....
//        ###..#....###..####.#....####...#..###..
//        #....#....#....#..#.#....#..#..#...#....
//        #....#..#.#....#..#.#....#..#.#....#....
//        ####..##..#....#..#.####.#..#.####.#....
    }
    
    func test_parse() {
        let (points, folds) = day.parse(input)
        XCTAssertEqual(799, points.count)
        XCTAssertEqual(12, folds.count)
    }
    
    func test_example() {
        let input = """
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
""".lines
        XCTAssertEqual(17, day.part1(input))
        
        XCTAssertEqual(16, day.part2(input))
    }
}
