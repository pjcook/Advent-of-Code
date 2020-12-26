import XCTest
import InputReader
import Year2020

class Day25Tests: XCTestCase {
    let day = Day25()

    func test_part1() {
        XCTAssertEqual(4968512, day.part1(cardKey: 10604480, doorKey: 4126658))
    }
    
    func test_part1_chris() {
        XCTAssertEqual(4968512, day.part1_chris(cardKey: 10604480, doorKey: 4126658))
    }
    
    func test_part1_example() {
        let cardPublicKey = 5764801
        let doorPublicKey = 17807724
        let encryptionKey = day.part1_chris(cardKey: cardPublicKey, doorKey: doorPublicKey)
        XCTAssertEqual(14897079, encryptionKey)
    }
}
