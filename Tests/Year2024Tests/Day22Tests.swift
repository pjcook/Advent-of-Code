import XCTest
import InputReader
import Year2024

class Day22Tests: XCTestCase {
    
    let input = Input("Day22.input", Bundle.module).integers
    let day = Day22()

    func test_part1() {
//        measure {
        XCTAssertEqual(18941802053, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = [1,
                      10,
                      100,
                      2024,
        ]
        XCTAssertEqual(37327623, day.part1(input))
    }
    
    func test_part1_calculateSecrets() {
        XCTAssertEqual(15887950, day.calculateSecret(123, at: 1))
        XCTAssertEqual(16495136, day.calculateSecret(123, at: 2))
        XCTAssertEqual(527345, day.calculateSecret(123, at: 3))
        XCTAssertEqual(704524, day.calculateSecret(123, at: 4))
    }
    
    func test_part1_mix() {
        XCTAssertEqual(37, day.mix(42, 15))
        XCTAssertEqual(37, day.mix(15, 42))
    }
    
    func test_part1_prune() {
        XCTAssertEqual(16113920, day.prune(100000000))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(2218, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = [1,
                     2,
                     3,
                     2024,
        ]
        XCTAssertEqual(23, day.part2(input))
    }
    
    func test_part2_seq() {
        let list = day.calculateSecrets(1, 2000).map({ Int(String(String($0).last!))! })
        var dxSeq: [Int] = [0]
        var i = 1
        var current = list[0]
        while i < list.count {
            let next = list[i]
            dxSeq.append(next - current)
            current = next
            i += 1
        }
        for (a, b) in zip(list, dxSeq) {
            print(a, b)
        }
    }
}
