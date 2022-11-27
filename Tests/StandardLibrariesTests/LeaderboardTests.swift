import XCTest
import StandardLibraries

class LeaderboardTests: XCTestCase {

    func test_loadJson() throws {
        let url = Bundle.module.url(forResource: "Leaderboard", withExtension: "json")!
        let json = try Data(contentsOf: url)
        let api = try JSONDecoder().decode(API.Leaderboard.self, from: json)
        let leaderboard = Leaderboard(api: api)
        
        XCTAssertEqual(695454, leaderboard.ownerID)
        XCTAssertEqual(2020, leaderboard.event)
        XCTAssertEqual(32, leaderboard.members.count)
        
        let member = leaderboard.members.first(where: { $0.name == "PJ" })
        XCTAssertNotNil(member)
        XCTAssertEqual(697952, member?.id)
        XCTAssertEqual(30, member?.stars)
        XCTAssertEqual(861, member?.localScore)
        XCTAssertEqual(0, member?.globalScore)
        XCTAssertEqual(Date(timeIntervalSince1970: 1608013382 / 1000), member?.lastStarDateTime)
        XCTAssertEqual(15, member?.levels.count)
        
        let day = member?.levels.first(where: { $0.id == 1 })
        XCTAssertNotNil(day)
        XCTAssertEqual(Date(timeIntervalSince1970: 1606800297 / 1000), day?.star1)
        XCTAssertEqual(Date(timeIntervalSince1970: 1606800483 / 1000), day?.star2)
    }

}
