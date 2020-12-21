import XCTest
import InputReader
import Year2020

class Day20Tests: XCTestCase {
    let input = Input("Day20.input", Year2020.bundle).lines
    let day = Day20()

    func test_part1() {
        measure {
        let parsed = try! day.parse(input)
        XCTAssertEqual(8425574315321, day.part1(parsed))
        }
    }
    
    func test_part2() {
        measure {
        let parsed = try! day.parse(input)
        XCTAssertEqual(1841, day.part2(parsed))
        }
    }
    
    func test_part2_chris_input_file() {
        let input = Input("Day20_Chris.input", Year2020.bundle).lines
        let parsed = try! day.parse(input)
        XCTAssertEqual(2489, day.part2(parsed))
    }
    
    func test_countHashes() {
        let parsed = try! day.parse(input)
        var hashCount = 0

        for tile in parsed {
            for line in tile.edgeless {
                for c in line {
                    if c == "#" {
                        hashCount += 1
                    }
                }
            }
        }
        
        XCTAssertEqual(2201, hashCount)
    }
    
    func test_part2_example() {
        let input = """
        Tile 2311:
        ..##.#..#.
        ##..#.....
        #...##..#.
        ####.#...#
        ##.##.###.
        ##...#.###
        .#.#.#..##
        ..#....#..
        ###...#.#.
        ..###..###

        Tile 1951:
        #.##...##.
        #.####...#
        .....#..##
        #...######
        .##.#....#
        .###.#####
        ###.##.##.
        .###....#.
        ..#.#..#.#
        #...##.#..

        Tile 1171:
        ####...##.
        #..##.#..#
        ##.#..#.#.
        .###.####.
        ..###.####
        .##....##.
        .#...####.
        #.##.####.
        ####..#...
        .....##...

        Tile 1427:
        ###.##.#..
        .#..#.##..
        .#.##.#..#
        #.#.#.##.#
        ....#...##
        ...##..##.
        ...#.#####
        .#.####.#.
        ..#..###.#
        ..##.#..#.

        Tile 1489:
        ##.#.#....
        ..##...#..
        .##..##...
        ..#...#...
        #####...#.
        #..#.#.#.#
        ...#.#.#..
        ##.#...##.
        ..##.##.##
        ###.##.#..

        Tile 2473:
        #....####.
        #..#.##...
        #.##..#...
        ######.#.#
        .#...#.#.#
        .#########
        .###.#..#.
        ########.#
        ##...##.#.
        ..###.#.#.

        Tile 2971:
        ..#.#....#
        #...###...
        #.#.###...
        ##.##..#..
        .#####..##
        .#..####.#
        #..#.#..#.
        ..####.###
        ..#.#.###.
        ...#.#.#.#

        Tile 2729:
        ...#.#.#.#
        ####.#....
        ..#.#.....
        ....#..#.#
        .##..##.#.
        .#.####...
        ####.#.#..
        ##.####...
        ##..#.##..
        #.##...##.

        Tile 3079:
        #.#.#####.
        .#..######
        ..#.......
        ######....
        ####.#..#.
        .#...#.##.
        #.#####.##
        ..#.###...
        ..#.......
        ..#.###...
        """.lines
        let parsed = try! day.parse(input)
        XCTAssertEqual(273, day.part2(parsed))
    }
    
    func test_parsing() throws {
        let parsed = try day.parse(input)
        XCTAssertEqual(144, parsed.count)
    }
    
    func test_rotate() throws {
        let parsed = try day.parse(input)
        let tile = parsed.first!
        let rotated = tile.rotate
        
        print(tile.data)
        print(rotated.data)
    }
    
    func test_seaMonsterSearch() throws {
//      let input = "#.O.##.OO#.#.OO.##.OOO##"
        let input = "#.#.##.###.#.##.##.#####"
        let seaMonster = Day20.SeaMonster()
        let match = try seaMonster.regex.match(input)
        XCTAssertEqual("#.##.###.#.##.##.###", try match.string(at: 0))
    }
    
    func test_regex() throws {
        let input = "#.....#...###....##....####..#.#..##.##.......#.#.#..###...##...####......#.....##.....#.#..#..."
        let seaMonster = Day20.SeaMonster()
        let match = seaMonster.regex.matches(in: input)
        XCTAssertEqual(2, match.count)
    }
}
