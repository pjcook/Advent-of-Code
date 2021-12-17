import XCTest
import InputReader
import Year2021

class Day16Tests: XCTestCase {
    
    let input = Input("Day16.input", Year2021.bundle).input
    let day = Day16()

    func test_part1() {
//        measure {
        XCTAssertEqual(1007, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(834151779165, day.part2(input))
//        }
    }
    
    func test_parsing() {
        XCTAssertEqual(5464, day.convertHexInputToBinary(input).count)
    }
    
    func test_example_parsing() {
        var values = day.convertHexInputToBinary("D2FE28")
        print(values)
        print(values.count % 3)
        print(values.count / 3)
        let packet = day.readPacketHeader(&values, depth: 1)!
        print(packet)
        XCTAssertEqual(6, packet.version)
        XCTAssertEqual(4, packet.typeID)
        XCTAssertEqual(2021, packet.valueCount())
    }
    
    func test_examples_part1() {
        XCTAssertEqual(16, day.part1("8A004A801A8002F478"))
        XCTAssertEqual(12, day.part1("620080001611562C8802118E34"))
        XCTAssertEqual(23, day.part1("C0015000016115A2E0802F182340"))
        XCTAssertEqual(31, day.part1("A0016C880162017C3686B18A3D4780"))
    }
}
