import XCTest
import InputReader
import Year2020

class Day21Tests: XCTestCase {
    let input = Input("Day21.input", Year2020.bundle).lines
    let day = Day21()

    func test_part1() throws {
        XCTAssertEqual(2542, try day.part1(input))
    }
    
    func test_part2() throws {
        XCTAssertEqual("hkflr,ctmcqjf,bfrq,srxphcm,snmxl,zvx,bd,mqvk", try day.part2(input))
    }
    
    func test_part2_example() throws {
        let input = """
        mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
        trh fvjkl sbzzf mxmxvkd (contains dairy)
        sqjhc fvjkl (contains soy)
        sqjhc mxmxvkd sbzzf (contains fish)
        """.lines
        XCTAssertEqual("mxmxvkd,sqjhc,fvjkl", try day.part2(input))
    }
}
