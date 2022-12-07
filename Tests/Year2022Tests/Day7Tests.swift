import XCTest
import InputReader
import Year2022

class Day7Tests: XCTestCase {
    
    let input = Input("Day7.input", Bundle.module).lines
    let day = Day7()

    func test_part1() {
//        measure {
        XCTAssertEqual(1583951, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(214171, day.part2(input))
//        }
    }
}

extension Day7Tests {
    func test_parse() throws {
        let result = day.parse(input)
        print(result)
    }
    
    func test_parse_example() throws {
        let input = """
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
""".lines
        let result = day.parse(input)
        print(result.contents.map { $0.name })
    }
    
    func test_part1_example() throws {
        let input = """
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
""".lines
        XCTAssertEqual(95437, day.part1(input))
    }
    
    func test_part2_example() throws {
        let input = """
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
""".lines
        XCTAssertEqual(24933642, day.part2(input))
    }
}
