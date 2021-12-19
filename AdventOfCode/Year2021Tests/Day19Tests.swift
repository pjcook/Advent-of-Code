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
        XCTAssertEqual(26, scanners[0].beacons.count)
        XCTAssertEqual(325, scanners[0].distances.count)
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
        let scanners = day.parse(input)
        XCTAssertEqual(2, scanners.count)
        
        for scanner in scanners {
            var scanner = scanner
            draw([scanner])
            
            // Z
            scanner = scanner.rotateZ()
            draw([scanner])
            scanner = scanner.rotateZ()
            draw([scanner])
            scanner = scanner.rotateZ()
            draw([scanner])
            scanner = scanner.rotateZ()
            draw([scanner])
            
            // Y
            scanner = scanner.rotateY()
            draw([scanner])
            scanner = scanner.rotateY()
            draw([scanner])
            scanner = scanner.rotateY()
            draw([scanner])
            scanner = scanner.rotateY()
            draw([scanner])
            
            // X
            scanner = scanner.rotateX()
            draw([scanner])
            scanner = scanner.rotateX()
            draw([scanner])
            scanner = scanner.rotateX()
            draw([scanner])
            scanner = scanner.rotateX()
            draw([scanner])
        }
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
        var scanners = day.parse(input)
        XCTAssertEqual(2, scanners.count)
        
        draw(scanners)

    }
    
    public func draw(_ scanners: [Day19.Scanner]) {
        for scanner in scanners {
            let (minCoords, maxCoords) = scanner.beacons.minMax()
            let dx = maxCoords.x - minCoords.x
            let dy = maxCoords.y - minCoords.y
            let d = max(dx, dy)+2
            let items = Set(scanner.beacons.map({ Point($0.x, $0.y) }))
            draw(items, min: Point(-d, -d), max: Point(d,d))
        }
    }
    
    public func draw(_ tiles: Set<Point>, min: Point, max: Point) {
        for y in (min.y...max.y) {
            var line = ""
            for x in (min.x...max.x) {
                if y == 0 && x == 0 {
                    line.append("🔴")
                } else {
                    line.append(tiles.contains(Point(x: x, y: y)) ? "⚪️" : "⚫️")
                }
            }
            print(line)
        }
        print()
    }
}
