import XCTest
import InputReader
import Year2021

class Day23Tests: XCTestCase {
    
    let input = Input("Day23.input", Year2021.bundle).lines
    let day = Day23()

    func test_part1() {
        XCTAssertEqual(15358, day.solve(board_mine_part1()))
    }

    func test_part2() {
        XCTAssertEqual(51436, day.solve(board_mine_part2()))
    }

//    func test_part1_chris() {
//        XCTAssertEqual(16244, day.solve(board_chris_part1()))
//    }
//
//    func test_part2_chris() {
//        XCTAssertEqual(43226, day.solve(board_chris_part2()))
//    }
//
//    func test_part1_chris_cornford() {
//        XCTAssertEqual(19059, day.solve(board_cornford_part1()))
//    }
//
//    func test_part2_chris_cornford() {
//        XCTAssertEqual(48541, day.solve(board_cornford_part2(), printHistory: true))
//    }

    func test_distanceFrom_home_position() {
        let board = board_mine_part1()
        let options = day.moveFromRoom(room: board.room(.B), board: board)
        XCTAssertEqual(5, options[0].score)
    }
    
    func test_distanceFrom_home_position_home() {
        let board = board_mine_test1()
        let options = day.moveFromRoom(room: board.room(.A), board: board)
        XCTAssertEqual(9000, options[0].score)
        XCTAssertTrue(options[0].room(.D).solved)
        day.draw(options[0], level: 1)
    }
    
    func test_distanceFrom_position_home_no_options() {
        let board = board_mine_test1()
        
        let option = day.moveFromCorridor(position: 1, board: board)
        XCTAssertNil(option)
    }
    
    func test_full_journey() {
        let board = board_mine_part1()
        
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
        let board = board_chris_part1()
        
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
    func move(from: Day23.Tile, to: Int, day: Day23) -> Day23.Board {
        day.moveFromRoom(room: self.room(from), board: self, to: to).first!
    }
    
    func move(from: Int, day: Day23) -> Day23.Board {
        day.moveFromCorridor(position: from, board: self)!
    }
}

extension Day23Tests {
    func board_mine_part1() -> Day23.Board {
        let roomA = Day23.Room(id: .A, tiles: [.D, .C])
        let roomB = Day23.Room(id: .B, tiles: [.C, .A])
        let roomC = Day23.Room(id: .C, tiles: [.A, .B])
        let roomD = Day23.Room(id: .D, tiles: [.B, .D])
        let positions: [Day23.Tile] = [.free,.free,.free,.free,.free,.free,.free,.free,.free,.free,.free]
        return Day23.Board(rooms: [roomA, roomB, roomC, roomD], positions: positions, score: 0)
    }
    
    func board_mine_part2() -> Day23.Board {
        let roomA = Day23.Room(id: .A, tiles: [.D, .D, .D, .C])
        let roomB = Day23.Room(id: .B, tiles: [.C, .B, .C, .A])
        let roomC = Day23.Room(id: .C, tiles: [.A, .A, .B, .B])
        let roomD = Day23.Room(id: .D, tiles: [.B, .C, .A, .D])
        let positions: [Day23.Tile] = [.free,.free,.free,.free,.free,.free,.free,.free,.free,.free,.free]
        return Day23.Board(rooms: [roomA, roomB, roomC, roomD], positions: positions, score: 0)
    }
    
    func board_cornford_part1() -> Day23.Board {
        let roomA = Day23.Room(id: .A, tiles: [.D, .D])
        let roomB = Day23.Room(id: .B, tiles: [.A, .C])
        let roomC = Day23.Room(id: .C, tiles: [.A, .B])
        let roomD = Day23.Room(id: .D, tiles: [.B, .C])
        let positions: [Day23.Tile] = [.free,.free,.free,.free,.free,.free,.free,.free,.free,.free,.free]
        return Day23.Board(rooms: [roomA, roomB, roomC, roomD], positions: positions, score: 0)
    }
    
    func board_cornford_part2() -> Day23.Board {
        let roomA = Day23.Room(id: .A, tiles: [.D, .D, .D, .D])
        let roomB = Day23.Room(id: .B, tiles: [.A, .B, .C, .C])
        let roomC = Day23.Room(id: .C, tiles: [.A, .A, .B, .B])
        let roomD = Day23.Room(id: .D, tiles: [.B, .C, .A, .C])
        let positions: [Day23.Tile] = [.free,.free,.free,.free,.free,.free,.free,.free,.free,.free,.free]
        return Day23.Board(rooms: [roomA, roomB, roomC, roomD], positions: positions, score: 0)
    }
    
    func board_mine_test1() -> Day23.Board {
        let roomA = Day23.Room(id: .A, tiles: [.D, .free])
        let roomB = Day23.Room(id: .B, tiles: [.B, .B])
        let roomC = Day23.Room(id: .C, tiles: [.C, .C])
        let roomD = Day23.Room(id: .D, tiles: [.D, .free])
        let positions: [Day23.Tile] = [.A, .A,.free,.free,.free,.free,.free,.free,.free,.free,.free]
        return Day23.Board(rooms: [roomA, roomB, roomC, roomD], positions: positions, score: 0)
    }
    
    func board_chris_part1() -> Day23.Board {
        let roomA = Day23.Room(id: .A, tiles: [.B, .D])
        let roomB = Day23.Room(id: .B, tiles: [.C, .D])
        let roomC = Day23.Room(id: .C, tiles: [.A, .B])
        let roomD = Day23.Room(id: .D, tiles: [.C, .A])
        let positions: [Day23.Tile] = [.free,.free,.free,.free,.free,.free,.free,.free,.free,.free,.free]
        return Day23.Board(rooms: [roomA, roomB, roomC, roomD], positions: positions, score: 0)
    }
    
    func board_chris_part2() -> Day23.Board {
        let roomA = Day23.Room(id: .A, tiles: [.B, .D, .D, .D])
        let roomB = Day23.Room(id: .B, tiles: [.C, .B, .C, .D])
        let roomC = Day23.Room(id: .C, tiles: [.A, .A, .B, .B])
        let roomD = Day23.Room(id: .D, tiles: [.C, .C, .A, .A])
        let positions: [Day23.Tile] = [.free,.free,.free,.free,.free,.free,.free,.free,.free,.free,.free]
        return Day23.Board(rooms: [roomA, roomB, roomC, roomD], positions: positions, score: 0)
    }
}
