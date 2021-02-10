import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day25Tests: XCTestCase {
    let input = Input("Day25.input", Year2018.bundle).lines
    
    func test_part1() {
        let day = Day25()
        XCTAssertEqual(399, day.part1(input))
    }
    
    func test_part1_example1() {
        let input = """
        0,0,0,0
        3,0,0,0
        0,3,0,0
        0,0,3,0
        0,0,0,3
        0,0,0,6
        9,0,0,0
        12,0,0,0
        """.lines
        let day = Day25()
        XCTAssertEqual(2, day.part1(input))
    }
    
    func test_part1_example2() {
        let input = """
        -1,2,2,0
        0,0,2,-2
        0,0,0,-2
        -1,2,0,0
        -2,-2,-2,2
        3,0,2,-1
        -1,3,2,2
        -1,0,-1,0
        0,2,1,-2
        3,0,0,0
        """.lines
        let day = Day25()
        XCTAssertEqual(4, day.part1(input))
    }
    
    func test_part1_example3() {
        let input = """
        1,-1,0,1
        2,0,-1,0
        3,2,-1,0
        0,0,3,1
        0,0,-1,-1
        2,3,-2,0
        -2,2,0,0
        2,-2,0,-1
        1,-1,0,-1
        3,2,0,2
        """.lines
        let day = Day25()
        XCTAssertEqual(3, day.part1(input))
    }
    
    func test_part1_example4() {
        let input = """
        1,-1,-1,-2
        -2,-2,0,1
        0,2,1,3
        -2,3,-2,1
        0,2,3,-2
        -1,-1,1,-2
        0,-2,-1,0
        -2,2,3,-1
        1,2,2,0
        -1,-2,0,-2
        """.lines
        let day = Day25()
        XCTAssertEqual(8, day.part1(input))
    }
    
    func test_quads_in_collection() {
        let quad0 = Day25.Quad("0,0,0,0")
        let quad1 = Day25.Quad("3,0,0,0")
        let quad2 = Day25.Quad("0,3,0,0")
        let quad3 = Day25.Quad("0,0,3,0")
        let quad4 = Day25.Quad("0,0,0,3")
        let quad5 = Day25.Quad("0,0,0,6")
        let quad6 = Day25.Quad("9,0,0,0")
        let quad7 = Day25.Quad("12,0,0,0")
        
        let collection = [quad0, quad1, quad2, quad3, quad4, quad5, quad6, quad7]
        let col = Set(collection)
        
        XCTAssertEqual(2, collection.firstIndex(of: quad2))
        XCTAssertTrue(col.contains(quad3))
        XCTAssertEqual(quad2, Day25.Quad("0,3,0,0"))
        
        XCTAssertEqual(3, quad0.manhattan(quad1))
        XCTAssertEqual(3, quad0.manhattan(quad2))
        XCTAssertEqual(3, quad0.manhattan(quad3))
        XCTAssertEqual(3, quad0.manhattan(quad4))
        XCTAssertEqual(3, quad4.manhattan(quad5))
        XCTAssertFalse(quad5.manhattan(quad6) <= 3)
        XCTAssertEqual(3, quad6.manhattan(quad7))
    }
    
    func test_mapping_nodes() {
        let input = """
        0,0,0,0
        3,0,0,0
        0,3,0,0
        0,0,3,0
        0,0,0,3
        0,0,0,6
        9,0,0,0
        12,0,0,0
        """.lines
        let day = Day25()
        let nodes = day.parse(input)
        for node in nodes {
            for n in nodes {
                guard node != n else { continue }
                if node.manhattan(n) <= 3 {
                    node.children.insert(n)
                    n.parents.insert(node)
                }
            }
        }
        
        let tree1 = nodes[0].familyTree([])
        let tree2 = nodes[1].familyTree([])
        let tree3 = nodes[2].familyTree([])
        let tree4 = nodes[6].familyTree([])
        XCTAssertEqual(tree1, tree2)
        XCTAssertEqual(tree1, tree3)
        XCTAssertEqual(tree2, tree3)
        XCTAssertNotEqual(tree4, tree1)
        XCTAssertNotEqual(tree4, tree2)
        XCTAssertNotEqual(tree4, tree3)
    }
}
