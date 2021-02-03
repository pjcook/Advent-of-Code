import Foundation
import StandardLibraries

public struct Day23 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        var items = parse(input)
        items.sort(by: { $0.radius > $1.radius })
        let largest = items.first!
        return items.filter({ $0.vector.distance(to: largest.vector) <= largest.radius }).count
    }
    
    public func part2(_ input: [String]) -> Int {
        let bots = parse(input)
        
        var (minX, maxX) = bots.map { $0.vector.x }.extremes()
        var (minY, maxY) = bots.map { $0.vector.y }.extremes()
        var (minZ, maxZ) = bots.map { $0.vector.z }.extremes()
        
        var gridSize = maxX - minX
        var best: Vector?
        while gridSize > 0 {
            var maxCount = 0
            
            var x = minX
            while x < maxX {
                var y = minY
                while y < maxY {
                    var z = minZ
                    while z < maxZ {
                        var count = 0
                        let vector = Vector(x: x, y: y, z: z)
                        for bot in bots {
                            let distance = bot.vector.distance(to: vector)
                            if distance - bot.radius < gridSize {
                                count += 1
                            }
                        }
                        
                        if maxCount < count {
                            maxCount = count
                            best = vector
                        } else if maxCount == count {
                            if best == nil || vector.distance(to: .zero) < best!.distance(to: .zero) {
                                best = vector
                            }
                        }
                        
                        z += gridSize
                    }
                    
                    y += gridSize
                }
                
                x += gridSize
            }
            
            minX = best!.x - gridSize
            maxX = best!.x + gridSize
            minY = best!.y - gridSize
            maxY = best!.y + gridSize
            minZ = best!.z - gridSize
            maxZ = best!.z + gridSize
            
            gridSize = gridSize / 2
        }
        
        return best!.distance(to: .zero)
    }
}

extension Day23 {
    func parse(_ input: [String]) -> [Item] {
        return input.map { try! Item($0) }
    }
}

struct Item: Hashable {
    static let regex = try! RegularExpression(pattern: #"pos=<([-\d]*),([-\d]*),([-\d]*)>,.r=([-\d]*)"#)
    
    let vector: Vector
    let radius: Int
    
    let min: Int
    let max: Int
    let distanceToZero: Int
    let range: ClosedRange<Int>
    
    init(_ input: String) throws {
        let matches = try Self.regex.match(input)
        let x = try matches.integer(at: 0)
        let y = try matches.integer(at: 1)
        let z = try matches.integer(at: 2)
        let r = try matches.integer(at: 3)
        
        vector = Vector(x: x, y: y, z: z)
        radius = r
        distanceToZero = vector.distance(to: .zero)
        min = distanceToZero - radius
        max = distanceToZero + radius
        range = (min...max)
    }
}
