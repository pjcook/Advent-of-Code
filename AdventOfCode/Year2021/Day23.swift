import Foundation
import StandardLibraries

public class Day23 {
    public init() {}

    public enum Tile: Int {
        case free = 0
        case A = 1
        case B = 10
        case C = 100
        case D = 1000
        
        public var roomEntrance: Int {
            switch self {
            case .A: return 2
            case .B: return 4
            case .C: return 6
            case .D: return 8
            default: abort()
            }
        }
        
        public var symbol: Character {
            switch self {
            case .free: return "."
            case .A: return "A"
            case .B: return "B"
            case .C: return "C"
            case .D: return "D"
            }
        }
    }
    
    public struct Room: Hashable {
        public let id: Tile
        public var tiles: [Tile]
        
        public init(id: Tile, tiles: [Tile]) {
            self.id = id
            self.tiles = tiles
        }
        
        public var canEnter: Bool {
            tiles.first(where: { ![id, .free].contains($0) }) == nil
        }
        
        public var solved: Bool {
            tiles.first(where: { $0 != id }) == nil
        }
        
        public var isEmpty: Bool {
            tiles.first(where: { $0 != .free }) == nil
        }
        
        public static func == (lhs: Room, rhs: Room) -> Bool {
            lhs.id == rhs.id
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(tiles)
        }
    }
    
    public struct Board: Hashable {
        public let rooms: [Room]
        public let positions: [Tile]
        public let score: Int
        
        public init(rooms: [Room], positions: [Tile], score: Int) {
            self.rooms = rooms
            self.positions = positions
            self.score = score
        }
        
        public var solved: Bool {
            for room in rooms {
                if room.tiles.first(where: { $0 != room.id }) != nil {
                    return false
                }
            }
            return true
        }
        
        public func room(_ id: Tile) -> Room {
            rooms.first(where: { $0.id == id })!
        }
        
        public let tilesToStopOn = [0,1,3,5,7,9,10]
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(rooms.sorted(by: { $0.id.rawValue < $1.id.rawValue }))
            hasher.combine(positions)
        }
        
        public static func == (lhs: Board, rhs: Board) -> Bool {
            lhs.rooms == rhs.rooms && lhs.positions == rhs.positions
        }
    }
    
    public var minScore = Int.max
    public var completeBoards = [Board]()
    
    public func part1(_ input: [String]) -> Int {
        let roomA = Room(id: .A, tiles: [.D, .C])
        let roomB = Room(id: .B, tiles: [.C, .A])
        let roomC = Room(id: .C, tiles: [.A, .B])
        let roomD = Room(id: .D, tiles: [.B, .D])
        let positions: [Tile] = [.free,.free,.free,.free,.free,.free,.free,.free,.free,.free,.free]

        solve(Board(rooms: [roomA, roomB, roomC, roomD], positions: positions, score: 0), history: [])
        
        return minScore
    }
    
    public func part1_chris(_ input: [String]) -> Int {
        let roomA = Room(id: .A, tiles: [.B, .D])
        let roomB = Room(id: .B, tiles: [.C, .D])
        let roomC = Room(id: .C, tiles: [.A, .B])
        let roomD = Room(id: .D, tiles: [.C, .A])
        let positions: [Tile] = [.free,.free,.free,.free,.free,.free,.free,.free,.free,.free,.free]

        solve(Board(rooms: [roomA, roomB, roomC, roomD], positions: positions, score: 0), history: [])
        
        return minScore
    }
    
    public func part2(_ input: [String]) -> Int {
        let roomA = Room(id: .A, tiles: [.D, .D, .D, .C])
        let roomB = Room(id: .B, tiles: [.C, .B, .C, .A])
        let roomC = Room(id: .C, tiles: [.A, .A, .B, .B])
        let roomD = Room(id: .D, tiles: [.B, .C, .A, .D])
        let positions: [Tile] = [.free,.free,.free,.free,.free,.free,.free,.free,.free,.free,.free]

        solve(Board(rooms: [roomA, roomB, roomC, roomD], positions: positions, score: 0), history: [])
        
        return minScore
    }
    
    public func part2_chris(_ input: [String]) -> Int {
        let roomA = Room(id: .A, tiles: [.B, .D, .D, .D])
        let roomB = Room(id: .B, tiles: [.C, .B, .C, .D])
        let roomC = Room(id: .C, tiles: [.A, .A, .B, .B])
        let roomD = Room(id: .D, tiles: [.C, .C, .A, .A])
        let positions: [Tile] = [.free,.free,.free,.free,.free,.free,.free,.free,.free,.free,.free]

        solve(Board(rooms: [roomA, roomB, roomC, roomD], positions: positions, score: 0), history: [])
        
        return minScore
    }
    
    public func solve(_ board: Board, history: [Board]) {
        guard !board.solved else {
            if board.score < minScore {
                minScore = board.score
//                print(minScore)
//                
//                if minScore <= 16438 {
//                    var level = 1
//                    for board in history {
//                        draw(board, level: level)
//                        level += 1
//                    }
//                }
            }
            return
        }
        guard board.score < minScore else { return }
        
        for nextBoard in availableMoves(board) {
            var newHistory = history
            newHistory.append(nextBoard)
            solve(nextBoard, history: newHistory)
        }
    }
    
    public func availableMoves(_ board: Board) -> [Board] {
        var boards = [Board]()
        
        // Check Corridor
        for i in (0..<board.positions.count) {
            if board.positions[i] != .free {
                if let possibleMove = moveFromCorridor(position: i, board: board) {
                    boards.append(possibleMove)
                }
            }
        }
        
        // Check Rooms
        for room in board.rooms {
            let possibleMoves = moveFromRoom(room: room, board: board)
            if !possibleMoves.isEmpty {
                boards.append(contentsOf: possibleMoves)
            }
        }
        
        return boards
    }
    
    public func moveFromCorridor(position: Int, board: Board) -> Board? {
        let tile = board.positions[position]
        if
            board.room(tile).canEnter,
            isRouteHomeClear(position, board: board)
        {
            let room = board.room(tile)
            let index = room.tiles.firstIndex(where: { $0 == .free })!
            let distance = abs(position - tile.roomEntrance) + room.tiles.count - index
            let newScore = board.score + distance * tile.rawValue
            var newRooms = board.rooms
            var newRoom = room
            newRoom.tiles[index] = tile
            newRooms[newRooms.firstIndex(of: room)!] = newRoom
            var newPositions = board.positions
            newPositions[position] = .free
            return Board(rooms: newRooms, positions: newPositions, score: newScore)
        }
        return nil
    }
    
    public func isRouteHomeClear(_ position: Int, board: Board) -> Bool {
        let home = board.positions[position].roomEntrance
        if home < position {
            return board.positions[(home..<position)].first { $0 != .free } == nil
        } else {
            return board.positions[(position+1...home)].first { $0 != .free } == nil
        }
    }
    
    public func isRouteFromHomeClear(_ position: Int, room: Room, board: Board) -> Bool {
        let home = room.id.roomEntrance
        let a = min(home, position)
        let b = max(home, position)
        return board.positions[(a..<b)].first { $0 != .free } == nil
    }
    
    public func moveFromRoom(room: Room, board: Board, to forcedTestPosition: Int? = nil) -> [Board] {
        guard !room.solved, !room.isEmpty, !room.canEnter else { return [] }
        var boards = [Board]()
        
        var index = room.tiles.count - 1
        while index >= 0 {
            if room.tiles[index] != .free {
                break
            }
            index -= 1
        }
        
        let tile = room.tiles[index]
        // if can get home ONLY do that
        if board.room(tile).canEnter, isRouteFromHomeClear(room.id.roomEntrance, room: board.room(tile), board: board) {
            let newPositions = board.positions
            var newRooms = board.rooms
            var newCurrentRoom = room
            newCurrentRoom.tiles[index] = .free
            var nextRoom = board.room(tile)
            
            var nextIndex = 0
            while nextIndex < nextRoom.tiles.count {
                if nextRoom.tiles[nextIndex] == .free {
                    break
                }
                nextIndex += 1
            }
            nextRoom.tiles[nextIndex] = tile
            
            newRooms[newRooms.firstIndex(where: { $0.id == room.id })!] = newCurrentRoom
            newRooms[newRooms.firstIndex(where: { $0.id == nextRoom.id })!] = nextRoom
            let exitCount = room.tiles.count - 1 - index
            let entryCount = room.tiles.count - nextIndex
            let distance = abs(nextRoom.id.roomEntrance - room.id.roomEntrance) + 1 + exitCount + entryCount
            let newScore = board.score + distance * tile.rawValue
            boards.append(Board(rooms: newRooms, positions: newPositions, score: newScore))
            return boards
        }
        
        // this code was only for unit testing where I was manually setting the route to follow
        if let position = forcedTestPosition {
            let option = board.positions[position]
            if option == .free, isRouteFromHomeClear(position, room: room, board: board) {
                let newBoard = boardFor(position: position, index: index, tile: tile, room: room, board: board)
                boards.append(newBoard)
            } else {
                abort()
            }
            return boards
        }

        for position in board.tilesToStopOn {
            let option = board.positions[position]
            if option == .free, isRouteFromHomeClear(position, room: room, board: board) {
                let newBoard = boardFor(position: position, index: index, tile: tile, room: room, board: board)
                boards.append(newBoard)
            }
        }
        
        return boards
    }
    
    public func boardFor(position: Int, index: Int, tile: Tile, room: Room, board: Board) -> Board {
        var newPositions = board.positions
        newPositions[position] = tile
        var newRooms = board.rooms
        var newRoom = room
        newRoom.tiles[index] = .free
        newRooms[newRooms.firstIndex(of: room)!] = newRoom
        let distance = abs(position - room.id.roomEntrance) + 1 + room.tiles.count - 1 - index
        let newScore = board.score + distance * tile.rawValue
        let newBoard = Board(rooms: newRooms, positions: newPositions, score: newScore)
        return newBoard
    }
    
    public func draw(_ board: Board, level: Int) {
        print("[\(level)] Score:", minScore, board.score, "board states checked:", completeBoards.count)
        print(String(repeating: "#", count: 13))
        var corridor = "#"
        for tile in board.positions {
            corridor.append(tile.symbol)
        }
        corridor.append("#")
        print(corridor)
        let roomA = board.room(.A)
        let roomB = board.room(.B)
        let roomC = board.room(.C)
        let roomD = board.room(.D)
        print("###\(roomA.tiles.last!.symbol)#\(roomB.tiles.last!.symbol)#\(roomC.tiles.last!.symbol)#\(roomD.tiles.last!.symbol)###")
        
        var i = roomA.tiles.count - 2
        while i >= 0 {
            print("  #\(roomA.tiles[i].symbol)#\(roomB.tiles[i].symbol)#\(roomC.tiles[i].symbol)#\(roomD.tiles[i].symbol)#")
            i -= 1
        }
        
        print("  #########")
        print()
    }
}
