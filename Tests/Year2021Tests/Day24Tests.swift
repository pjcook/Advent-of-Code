import XCTest
import InputReader
import Year2021

class Day24Tests: XCTestCase {
    
    let input = Input("Day24.input", .module).lines
    let inputChris = Input("Day24_chris.input", .module).lines
    let day = Day24()

    func test_part1() {
//        measure {
        let triples = day.parse(input)
        let mappings = day.createMapping(triples)
        let bits = day.calculateMax(triples, mappings)
        XCTAssertEqual(0, day.validate(bits, triples: triples))
//        }
    }
    
    func test_part2() {
//        measure {
        let triples = day.parse(input)
        let mappings = day.createMapping(triples)
        let bits = day.calculateMin(triples, mappings)
        XCTAssertEqual(0, day.validate(bits, triples: triples))
//        }
    }
    
    func test_part1_chris() {
        let triples = day.parse(inputChris)
        let mappings = day.createMapping(triples)
        let bits = day.calculateMax(triples, mappings)
        XCTAssertEqual(0, day.validate(bits, triples: triples))
        print("max:", bits)
    }
    
    func test_part2_chris() {
        let triples = day.parse(inputChris)
        let mappings = day.createMapping(triples)
        let bits = day.calculateMin(triples, mappings)
        XCTAssertEqual(0, day.validate(bits, triples: triples))
        print("min:", bits)
    }
    
    func test_parse() {
        let triples = day.parse(input)
        XCTAssertEqual(1, triples[0].a)
        XCTAssertEqual(11, triples[0].b)
        XCTAssertEqual(5, triples[0].c)
        
        XCTAssertEqual(26, triples[5].a)
        XCTAssertEqual(-1, triples[5].b)
        XCTAssertEqual(2, triples[5].c)
        
        XCTAssertEqual(26, triples[11].a)
        XCTAssertEqual(-2, triples[11].b)
        XCTAssertEqual(14, triples[11].c)
    }
    
    func test_createMapping() {
        let triples = day.parse(input)
        let mappings = day.createMapping(triples)
        XCTAssertEqual(7, mappings.count)
        
        XCTAssertEqual(4, mappings[0].a)
        XCTAssertEqual(5, mappings[0].b)
    }
    
    func test_calculateMax() {
        let triples = day.parse(input)
        let mappings = day.createMapping(triples)
        let bits = day.calculateMax(triples, mappings)
        XCTAssertEqual([9,6,9,1,8,9,9,6,9,2,4,9,9,1], bits)
    }
    
    func test_calculateMin() {
        let triples = day.parse(input)
        let mappings = day.createMapping(triples)
        let bits = day.calculateMin(triples, mappings)
        XCTAssertEqual([9,1,8,1,1,2,4,1,9,1,1,6,4,1], bits)
    }
    
}
