import XCTest
import InputReader
import StandardLibraries
import Year2021

class Day19Tests: XCTestCase {
    
    let input = Input("Day19.input", Year2021.bundle).lines
    let day = Day19()

    func test_part1() {
        XCTAssertEqual(0, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(0, day.part2(input))
    }
    
    func test_parsing() {
        let scanners = day.parse(input)
        XCTAssertEqual(39, scanners.count)
        XCTAssertEqual(26, scanners[0].faces.first!.count)
//        XCTAssertEqual(325, scanners[0].distances.count)
    }
    
    func test_example() {
        let input = """
--- scanner 0 ---
0,2,0
4,1,0
3,3,0

--- scanner 1 ---
-1,-1,0
-5,0,0
-2,1,0
""".lines
        XCTAssertEqual(0, day.part1(input))
    }
    
    func test_example2() {
        let input = """
--- scanner 0 ---
-1,-1,1
-2,-2,2
-3,-3,3
-2,-3,1
5,6,-4
8,0,7

--- scanner 0 ---
1,-1,1
2,-2,2
3,-3,3
2,-1,3
-5,4,-6
-8,-7,0

--- scanner 0 ---
-1,-1,-1
-2,-2,-2
-3,-3,-3
-1,-3,-2
4,6,5
-7,0,8

--- scanner 0 ---
1,1,-1
2,2,-2
3,3,-3
1,3,-2
-4,-6,5
7,0,8

--- scanner 0 ---
1,1,1
2,2,2
3,3,3
3,1,2
-6,-4,-5
0,7,-8
""".lines
        let scanners = day.parse(input)
        XCTAssertEqual(5, scanners.count)
        
        for scanner in scanners {
            day.draw(scanner.faces.first!)
        }

    }
}
