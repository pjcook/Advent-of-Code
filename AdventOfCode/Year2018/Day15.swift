import Foundation
import StandardLibraries

public struct Day15 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let board = parse(input)
        board.play()
        board.results()
        return board.score
    }
    
    public func parse(_ input: [String]) -> Board {
        var tiles = [Point:Tile]()
        var players = Set<Player>()
        var x = 0
        for y in (0..<input.count) {
            let line = input[y]
            x = line.count
            for x in (0..<line.count) {
                let point = Point(x: x, y: y)
                let tile = Tile(rawValue: line[x])!
                tiles[point] = tile
                if [.elf, .goblin].contains(tile) {
                    players.insert(Player(race: Player.Race(rawValue: line[x])!, position: point))
                }
            }
        }
        
        return Board(tiles, Point(x: x, y: input.count), players)
    }
    
    public class Board {
        private var size: Point
        private var tiles: [Point:Tile]
        private var players: Set<Player>
        private var playing = false
        private var turns = 0
        
        public init(_ tiles: [Point:Tile], _ size: Point, _ players: Set<Player>) {
            self.tiles = tiles
            self.size = size
            self.players = players
        }
        
        public func play() {
            guard !playing else { return }
//            draw(tiles)
            var loop = true
            while loop {
                let playingRound = players.sorted(by: { $0.position.x < $1.position.x }).sorted(by: { $0.position.y < $1.position.y })
                var fullRound = true
                for player in playingRound {
                    guard let player = players.first(where: { $0.id == player.id }) else { continue }
                    let (updatedPlayer, complete) = update(player)
                    players.update(with: updatedPlayer)
                    if !complete {
                        fullRound = false
                        break
                    }
                }
                if fullRound {
                    turns += 1
                }
                print(turns)
                draw(tiles)
//                results()
                let elfCount = players.filter({ $0.race == .elf }).count
                loop = players.count != elfCount && elfCount != 0
            }
        }
        
        public func results() {
            print("Turns:", turns)
            for player in players {
                print(player.race == .elf ? "Elf" : "Gob", player.health, player.position)
            }
        }
        
        private func floorTiles(in board: [Point:Tile]) -> Set<Point> {
            return Set(board.filter { $0.value == .floor }.map { $0.key })
        }
        
        private func floorTiles(in options: Set<Point>, positions: [Point]) -> Set<Point> {
            return positions.reduce(into: Set<Point>()) { (result, position) in
                result = Player
                    .adjacent
                    .map({ $0 + position })
                    .compactMap({ options.contains($0) ? $0 : nil })
                    .reduce(into: result, { $0.insert($1) })
            }
        }
        
        private func findValidAttacks(_ player: Player) -> [Player] {
            let attackTile = player.race == .elf ? Tile.goblin : Tile.elf
            return Player
                .adjacent
                .map({ $0 + player.position })
                .compactMap({ tiles[$0] == attackTile ? $0 : nil })
                .compactMap({ point in
                    return players.first(where: { $0.position == point })
                })
        }
        
        public func update(_ player: Player) -> (Player, Bool) {
//            print(player.race == .elf ? "Elf" : "Gob", player.position)
            var player = player
            var board = tiles
            var options = floorTiles(in: board)
            let validMoves = floorTiles(in: options, positions: [player.position])
            
            let enemies = players.filter({ $0.race == player.race.opposite })
            if enemies.isEmpty {
                return (player, false)
            }
            var validAttacks = findValidAttacks(player)
            
            // if cannot attach && valid moves try to move
            if validAttacks.isEmpty, !validMoves.isEmpty {
                var inRange = floorTiles(in: options, positions: enemies.map { $0.position })
                
                // plot reachable paths
                var i = 1
                var moves = [Point:Int]()
                var minMoves = Int.max
                while !options.isEmpty && !inRange.isEmpty && i < minMoves {
                    for point in inRange {
                        board[point] = .move
                        moves[point] = min(moves[point, default: Int.max], i)
                        if validMoves.contains(point) && i < minMoves {
                            minMoves = i
                        }
                    }
                    options = floorTiles(in: board)
                    inRange = floorTiles(in: options, positions: inRange.map { $0 })
                    i = i+1
//                    draw(board, moves: moves)
                }
                
                // find nearest
                if let movement =
                    validMoves
                    .sorted(by: { $0.x < $1.x })
                    .sorted(by: { $0.y < $1.y })
                    .filter({ moves[$0] != nil })
                    .sorted(by: { moves[$0]! < moves[$1]! })
                    .first {
                    tiles[player.position] = .floor
                    tiles[movement] = player.race == .elf ? .elf : .goblin
                    player.position = movement
                }
            }
            
            // attack if possible
            validAttacks = findValidAttacks(player)
                .sorted(by: { $0.position.x < $1.position.x })
                .sorted(by: { $0.position.y < $1.position.y })
                .sorted(by: { $0.health < $1.health })

            if var first = validAttacks.first {
                first.health -= player.attack
                players.update(with: first)
                if first.health <= 0 {
                    tiles[first.position] = .floor
                    players.remove(first)
                }
            }
            
            return (player, true)
        }
        
        public var score: Int {
            return players.reduce(0) { $0 + $1.health } * turns
        }
        
        public func draw(_ tiles: [Point:Tile]) {
            for y in (0..<size.y) {
                var line = ""
                for x in (0..<size.x) {
                    let point = Point(x: x, y: y)
                    line.append(tiles[point, default: Tile.wall].rawValue)
                }
                print(line)
            }
            print()
        }
        
        public func draw(_ tiles: [Point:Tile], moves: [Point:Int]) {
            for y in (0..<size.y) {
                var line = ""
                for x in (0..<size.x) {
                    let point = Point(x: x, y: y)
                    if let value = moves[point] {
                        line.append(value < 10 ? String(value) : "X")
                    } else {
                        line.append(tiles[point, default: Tile.wall].rawValue)
                    }
                }
                print(line)
            }
            print()
        }
    }
    
    public struct Player: Hashable {
        public enum Race: String {
            case goblin = "G"
            case elf = "E"
            
            var opposite: Race {
                return self == .goblin ? .elf : .goblin
            }
        }
        public let id = UUID().uuidString
        public let race: Race
        public var health: Int
        public let attack: Int
        public var position: Point
        
        public init(race: Race, position: Point, health: Int = 200, attack: Int = 3) {
            self.race = race
            self.position = position
            self.health = health
            self.attack = attack
        }
        
        public static let adjacent = [
            Point(x: 1, y: 0),
            Point(x: -1, y: 0),
            Point(x: 0, y: 1),
            Point(x: 0, y: -1)
        ]
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        public static func == (lhs: Player, rhs: Player) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    public enum Tile: String {
        case wall = "#"
        case floor = "."
        case goblin = "G"
        case elf = "E"
        case move = "M"
    }
}
