import XCTest
import InputReader
import Year2020

class Day25Tests: XCTestCase {
    let day = Day25()

    func test_part1() {
        measure {
        XCTAssertEqual(4968512, day.part1(cardKey: 4126658, doorKey: 10604480))
        }
    }
    
    func test_part1_chris() {
        measure {
        XCTAssertEqual(4968512, day.part1_chris(cardKey: 4126658, doorKey: 10604480))
        }
    }
    
    func test_part1_example() {
        let cardPublicKey = 5764801
        let doorPublicKey = 17807724
        let encryptionKey = day.part1_chris(cardKey: cardPublicKey, doorKey: doorPublicKey)
        XCTAssertEqual(14897079, encryptionKey)
    }
}
