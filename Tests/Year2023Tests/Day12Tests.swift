import XCTest
import InputReader
import Year2023

class Day12Tests: XCTestCase {
    
    let input = Input("Day12.input", Bundle.module).lines
    let day = Day12()

    func test_part1() {
//        measure {
        XCTAssertEqual(7490, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
""".lines
        XCTAssertEqual(21, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(1, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
""".lines
        XCTAssertEqual(525152, day.part2(input))
    }
    
    func test_surveyEntry_init() {
        let survey = Day12.SurveyEntry("???.### 1,1,3")
        XCTAssertEqual(survey.report, "???.###")
        XCTAssertEqual(survey.contiguousGroups, [1,1,3])
    }
    
    func test_isValid() {
        let survey = Day12.SurveyEntry("???.### 1,1,3")
        XCTAssertTrue(survey.isValid(report: "#.#.###"))
        XCTAssertFalse(survey.isValid(report: "???.###"))
        XCTAssertFalse(survey.isValid(report: "#.#.#?#"))
    }
    
    func test_canFitGroup() {
        let survey = Day12.SurveyEntry("???.### 1,1,3")
        XCTAssertTrue(survey.canFitGroup(report: "???.###", startIndex: 0, length: 1))
        XCTAssertTrue(survey.canFitGroup(report: "???.###", startIndex: 1, length: 1))
        XCTAssertTrue(survey.canFitGroup(report: "???.###", startIndex: 2, length: 1))
        XCTAssertTrue(survey.canFitGroup(report: "#.#.???", startIndex: 4, length: 3))
        XCTAssertTrue(survey.canFitGroup(report: "#.#.?#?", startIndex: 4, length: 3))
        XCTAssertTrue(survey.canFitGroup(report: "#.#.?##", startIndex: 4, length: 3))

        XCTAssertFalse(survey.canFitGroup(report: "???.###", startIndex: 1, length: 3))
        XCTAssertFalse(survey.canFitGroup(report: "#.#.???", startIndex: 5, length: 3))
    }
    
    func test_numberOfConfigurations() {
        XCTAssertEqual(Day12.SurveyEntry("???.### 1,1,3").numberOfConfigurations(), 1)
        XCTAssertEqual(Day12.SurveyEntry(".??..??...?##. 1,1,3").numberOfConfigurations(), 4)
        XCTAssertEqual(Day12.SurveyEntry("?#?#?#?#?#?#?#? 1,3,1,6").numberOfConfigurations(), 1)
        XCTAssertEqual(Day12.SurveyEntry("????.#...#... 4,1,1").numberOfConfigurations(), 1)
        XCTAssertEqual(Day12.SurveyEntry("????.######..#####. 1,6,5").numberOfConfigurations(), 4)
        XCTAssertEqual(Day12.SurveyEntry("?###???????? 3,2,1").numberOfConfigurations(), 10)
    }
    
    func test_calculateOptions1() {
        let survey = Day12.SurveyEntry("?###???????? 3,2,1")
        let options = survey.calculateOptions()
        XCTAssertEqual(options, 10)
    }
    
    func test_calculateOptions2() {
        let survey = Day12.SurveyEntry("???.###????.###????.###????.###????.### 1,1,3,1,1,3,1,1,3,1,1,3,1,1,3")
        let options = survey.calculateOptions()
        XCTAssertEqual(options, 1)
    }
    
    func test_calculateOptions3() {
        let survey = Day12.SurveyEntry(".??..??...?##.?.??..??...?##.?.??..??...?##.?.??..??...?##.?.??..??...?##. 1,1,3,1,1,3,1,1,3,1,1,3,1,1,3")
        let options = survey.calculateOptions()
        XCTAssertEqual(options, 1)
    }
}

/*
 ?###???????? 3,2,1
 
 
 */
