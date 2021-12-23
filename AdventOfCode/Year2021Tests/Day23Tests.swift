import XCTest
import InputReader
import Year2021

class Day23Tests: XCTestCase {
    
    let input = Input("Day23.input", Year2021.bundle).lines
    let day = Day23()

    func test_part1() {
        XCTAssertEqual(15358, day.part1(input))
    }
    
    func test_part1_chris() {
        XCTAssertEqual(16244, day.part1_chris(input))
    }
    
    func test_part2() {
        XCTAssertEqual(51436, day.part2(input))
    }
    
    func test_part2_chris() {
        XCTAssertEqual(43226, day.part2_chris(input))
    }
    
    func test_distanceFrom_home_position() {
        let roomA = Day23.Room(id: .A, tiles: [Day23.Tile(id: "D1", tileType: .D), Day23.Tile(id: "C1", tileType: .C)])
        let roomB = Day23.Room(id: .B, tiles: [Day23.Tile(id: "C2", tileType: .C), Day23.Tile(id: "A1", tileType: .A)])
        let roomC = Day23.Room(id: .C, tiles: [Day23.Tile(id: "A2", tileType: .A), Day23.Tile(id: "B1", tileType: .B)])
        let roomD = Day23.Room(id: .D, tiles: [Day23.Tile(id: "B2", tileType: .B), Day23.Tile(id: "D2", tileType: .D)])
        let positions: [Day23.Tile] = [.free,.free,.free,.free,.free,.free,.free,.free,.free,.free,.free]
        let board = Day23.Board(rooms: [roomA, roomB, roomC, roomD], positions: positions, score: 0)
        
        let options = day.moveFromRoom(room: board.room(.B), board: board)
        XCTAssertEqual(5, options[0].score)
    }
    
    func test_distanceFrom_home_position_home() {
        let roomA = Day23.Room(id: .A, tiles: [Day23.Tile(id: "D1", tileType: .D), .free])
        let roomB = Day23.Room(id: .B, tiles: [Day23.Tile(id: "B1", tileType: .B), Day23.Tile(id: "B2", tileType: .B)])
        let roomC = Day23.Room(id: .C, tiles: [Day23.Tile(id: "C1", tileType: .C), Day23.Tile(id: "C2", tileType: .C)])
        let roomD = Day23.Room(id: .D, tiles: [Day23.Tile(id: "D2", tileType: .D), .free])
        let positions: [Day23.Tile] = [Day23.Tile(id: "A1", tileType: .A), Day23.Tile(id: "A2", tileType: .A),.free,.free,.free,.free,.free,.free,.free,.free,.free]
        let board = Day23.Board(rooms: [roomA, roomB, roomC, roomD], positions: positions, score: 0)
        
        let options = day.moveFromRoom(room: board.room(.A), board: board)
        XCTAssertEqual(9000, options[0].score)
        XCTAssertTrue(options[0].room(.D).solved)
        day.draw(options[0], level: 1)
    }
    
    func test_distanceFrom_position_home_no_options() {
        let roomA = Day23.Room(id: .A, tiles: [Day23.Tile(id: "D1", tileType: .D), .free])
        let roomB = Day23.Room(id: .B, tiles: [Day23.Tile(id: "B1", tileType: .B), Day23.Tile(id: "B2", tileType: .B)])
        let roomC = Day23.Room(id: .C, tiles: [Day23.Tile(id: "C1", tileType: .C), Day23.Tile(id: "C2", tileType: .C)])
        let roomD = Day23.Room(id: .D, tiles: [Day23.Tile(id: "D2", tileType: .D), .free])
        let positions: [Day23.Tile] = [Day23.Tile(id: "A1", tileType: .A), Day23.Tile(id: "A2", tileType: .A),.free,.free,.free,.free,.free,.free,.free,.free,.free]
        let board = Day23.Board(rooms: [roomA, roomB, roomC, roomD], positions: positions, score: 0)
        
        let option = day.moveFromCorridor(position: 1, board: board)
        XCTAssertNil(option)
    }
    
    func test_full_journey() {
        let roomA = Day23.Room(id: .A, tiles: [Day23.Tile(id: "D1", tileType: .D), Day23.Tile(id: "C1", tileType: .C)])
        let roomB = Day23.Room(id: .B, tiles: [Day23.Tile(id: "C2", tileType: .C), Day23.Tile(id: "A1", tileType: .A)])
        let roomC = Day23.Room(id: .C, tiles: [Day23.Tile(id: "A2", tileType: .A), Day23.Tile(id: "B1", tileType: .B)])
        let roomD = Day23.Room(id: .D, tiles: [Day23.Tile(id: "B2", tileType: .B), Day23.Tile(id: "D2", tileType: .D)])
        let positions: [Day23.Tile] = [.free,.free,.free,.free,.free,.free,.free,.free,.free,.free,.free]
        let board = Day23.Board(rooms: [roomA, roomB, roomC, roomD], positions: positions, score: 0)
        
        let board1 = board.move(from: .B, to: 0, day: day)
        XCTAssertEqual(5, board1.score)
        
        let board2 = board1.move(from: .C, to: 7, day: day)
        XCTAssertEqual(25, board2.score)
        
        let board3 = board2.move(from: .C, to: 1, day: day)
        XCTAssertEqual(32, board3.score)
        
        let board4 = board3.move(from: .B, to: 1, day: day)
        XCTAssertEqual(632, board4.score)
        
        let board5 = board4.move(from: .A, to: 1, day: day)
        XCTAssertEqual(1232, board5.score)
        
        let board6 = board5.move(from: 7, day: day)
        XCTAssertEqual(1282, board6.score)
        
        let board7 = board6.move(from: .D, to: 9, day: day)
        XCTAssertEqual(3282, board7.score)
        
        let board8 = board7.move(from: .D, to: 9, day: day)
        XCTAssertEqual(3352, board8.score)
        
        let board9 = board8.move(from: 9, day: day)
        XCTAssertEqual(6352, board9.score)
        
        let board10 = board9.move(from: .A, to: 9, day: day)
        XCTAssertEqual(15352, board10.score)
        
        let board11 = board10.move(from: 1, day: day)
        XCTAssertEqual(15355, board11.score)
        
        let board12 = board11.move(from: 0, day: day)
        XCTAssertEqual(15358, board12.score)
    }
    
    func test_full_journey_chris() {
        let roomA = Day23.Room(id: .A, tiles: [Day23.Tile(id: "B1", tileType: .B), Day23.Tile(id: "D1", tileType: .D)])
        let roomB = Day23.Room(id: .B, tiles: [Day23.Tile(id: "C1", tileType: .C), Day23.Tile(id: "D2", tileType: .D)])
        let roomC = Day23.Room(id: .C, tiles: [Day23.Tile(id: "A1", tileType: .A), Day23.Tile(id: "B2", tileType: .B)])
        let roomD = Day23.Room(id: .D, tiles: [Day23.Tile(id: "C2", tileType: .C), Day23.Tile(id: "A2", tileType: .A)])
        let positions: [Day23.Tile] = [.free,.free,.free,.free,.free,.free,.free,.free,.free,.free,.free]
        let board = Day23.Board(rooms: [roomA, roomB, roomC, roomD], positions: positions, score: 0)
        
        let board1 = board.move(from: .C, to: 3, day: day)
        let board2 = board1.move(from: .D, to: 10, day: day)
        let board3 = board2.move(from: .C, to: 9, day: day)
        let board4 = board3.move(from: .D, to: 1, day: day)
        let board5 = board4.move(from: .B, to: 1, day: day)
        let board6 = board5.move(from: .B, to: 0, day: day)
        let board7 = board6.move(from: 3, day: day)
        let board8 = board7.move(from: .A, to: 9, day: day)
        let board9 = board8.move(from: .A, to: 0, day: day)
        let board10 = board9.move(from: 9, day: day)
        let board11 = board10.move(from: 10, day: day)
        XCTAssertEqual(16246, board11.score)
        day.draw(board11, level: 1)
    }
}

extension Day23.Board {
    func move(from: Day23.TileType, to: Int, day: Day23) -> Day23.Board {
        day.moveFromRoom(room: self.room(from), board: self, to: to).first!
    }
    
    func move(from: Int, day: Day23) -> Day23.Board {
        day.moveFromCorridor(position: from, board: self)!
    }
}
