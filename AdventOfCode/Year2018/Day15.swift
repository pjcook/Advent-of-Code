import Foundation
import StandardLibraries

public struct Day15 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let board = parse(input)
        board.play()
//        board.results()
        return board.score
    }
    
    public func part2(_ input: [String]) -> Int {
        var elfAttackPower = 3

        outerloop: while true {
            elfAttackPower += 1
//            print("Attack power", elfAttackPower)

            let board = parse(input)
            let originalElfCount = board.players.filter({ $0.race == .elf }).count
            
            for player in board.players where player.race == .elf {
                player.attack = elfAttackPower
            }

            board.playPart2()
            
            if originalElfCount == board.players.filter({ $0.race == .elf }).count {
                return board.score
            }
        }
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
                    let race = Player.Race(rawValue: line[x])!
                    players.insert(Player(race: race, position: point))
                }
            }
        }
        
        return Board(tiles, Point(x: x, y: input.count), players)
    }
    
    public class Board {
        private var size: Point
        private var tiles: [Point:Tile]
        var players: Set<Player>
        private var turns = 0
        
        public init(_ tiles: [Point:Tile], _ size: Point, _ players: Set<Player>) {
            self.tiles = tiles
            self.size = size
            self.players = players
        }
        
        public func play() {
            var loop = true
            while loop {
                let playingRound = players
                    .sorted(by: { $0.position.x < $1.position.x })
                    .sorted(by: { $0.position.y < $1.position.y })
                var fullRound = true
                for player in playingRound {
                    guard let player = players.first(where: { $0.id == player.id }) else { continue }
                    if !update(player) {
                        fullRound = false
                        break
                    }
                }
                if fullRound {
                    turns += 1
                }
                let elfCount = players.filter({ $0.race == .elf }).count
                loop = players.count != elfCount && elfCount != 0
            }
        }
        
        public func playPart2() {
            let originalElfCount = players.filter({ $0.race == .elf }).count

            var loop = true
            while loop {
                let playingRound = players
                    .sorted(by: { $0.position.x < $1.position.x })
                    .sorted(by: { $0.position.y < $1.position.y })
                var fullRound = true
                for player in playingRound {
                    guard let player = players.first(where: { $0.id == player.id }) else { continue }
                    if !update(player) {
                        fullRound = false
                        break
                    }
                }
                if fullRound {
                    turns += 1
                }
                let elfCount = players.filter({ $0.race == .elf }).count
                if originalElfCount != elfCount {
                    loop = false
                    continue
                }
//                draw(tiles)
                loop = players.count != elfCount && elfCount != 0
            }
        }
        
        public func update(_ player: Player) -> Bool {
            let player = player
            let options = floorTiles(in: tiles)
            let validMoves = floorTiles(in: options, positions: [player.position])
            
            let enemies = players.filter({ $0.race == player.race.opposite })
            if enemies.isEmpty {
                return false
            }
            var validAttacks = findValidAttacks(player)
            
            // if cannot attack && valid moves try to move
            if validAttacks.isEmpty, !validMoves.isEmpty {
                // plot reachable paths
                var steps = [(Point,Int)]()
                var routes = [Point:Point]()
                let enemyPoints = Set(enemies.map { $0.position })
                steps.append((player.position, 0))
                var finishedSearching = false
                var maxSteps = Int.max
                route: while !steps.isEmpty {
                    let (current, stepCount) = steps.removeFirst()
                    if stepCount > maxSteps { continue }
                    var pendingMoves = [Point]()

                    for additive in Player.adjacent {
                        let point = current + additive
                        
                        // check if enemy in range
                        if enemyPoints.contains(point) {
                            if stepCount < maxSteps {
                                maxSteps = stepCount
                            }
                            finishedSearching = true
                            if routes[point] == nil {
                                routes[point] = current
                            }
                            continue route
                        }
                        
                        if tiles[point] == .floor && routes[point] == nil && point != player.position {
                            pendingMoves.append(point)
                        }
                    }
                    
                    if !finishedSearching {
                        for point in pendingMoves {
                            if routes[point] == nil {
                                routes[point] = current
                                steps.append((point, stepCount + 1))
                            }
                        }
                    }
                }
                
                if let destination =
                    routes
                    .filter({ enemyPoints.contains($0.key) })
                    .sorted(by: { $0.key.x < $1.key.x })
                    .sorted(by: { $0.key.y < $1.key.y })
                    .first {
                    var point = destination.key
                    while true {
                        let next = routes[point]!
                        if next != player.position {
                            point = next
                        } else {
                            break
                        }
                    }
                    tiles[player.position] = .floor
                    tiles[point] = player.race == .elf ? .elf : .goblin
                    player.position = point
                }
            }
            
            // attack if possible
            validAttacks = findValidAttacks(player)
                .sorted(by: { $0.position.x < $1.position.x })
                .sorted(by: { $0.position.y < $1.position.y })
                .sorted(by: { $0.health < $1.health })

            if let first = validAttacks.first {
                first.health -= player.attack
                if first.health <= 0 {
                    tiles[first.position] = .floor
                    players.remove(first)
                }
            }
            
            return true
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
        
        public func results() {
            print("Turns:", turns)
            for player in players {
                print(player.race == .elf ? "Elf" : "Gob", player.health, player.position)
            }
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
    
    public class Player: Hashable {
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
        public var attack: Int
        public var position: Point
        
        public init(race: Race, position: Point, health: Int = 200, attack: Int = 3) {
            self.race = race
            self.position = position
            self.health = health
            self.attack = attack
        }
        
        public static let adjacent = [
            Point(x: 0, y: -1),
            Point(x: -1, y: 0),
            Point(x: 1, y: 0),
            Point(x: 0, y: 1)
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
