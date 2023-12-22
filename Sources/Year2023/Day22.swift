import Foundation
import StandardLibraries

// position.z is vertical axis
public struct Day22 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        var blocks = parse(input)
        blocks = makeFall(blocks)
        let (maxX, maxY, _) = findMaxXYZ(blocks: blocks)
        
        return blocks.reduce(0) {
            $0 + (canRemove(block: $1, blocks: blocks, maxX: maxX, maxY: maxY) ? 1 : 0)
        }
    }
    
    public func part2(_ input: [String]) -> Int {
        var blocks = parse(input)
        blocks = makeFall(blocks)
        return howManyWouldFall(blocks: blocks)
    }
}

extension Day22 {
    func howManyWouldFall(blocks: [Cube]) -> Int {
        var seen = [Cube: Int]()
        var queue = blocks.reversed()
        var result = 0
        
        for cube in queue {
            if let value = seen[cube] {
                result += value
                continue
            }
            
            let remaining = remove(block: cube, from: blocks)
            let count = countFall(remaining)
            seen[cube] = count
            result += count
        }
        
        return result
    }
    
    func findMaxXYZ(blocks: [Cube]) -> (Int, Int, Int) {
        var maxX = 0
        var maxY = 0
        var maxZ = 0
        for block in blocks {
            maxX = max(maxX, block.max.x)
            maxY = max(maxY, block.max.y)
            maxZ = max(maxY, block.max.z)
        }
        return (maxX, maxY, maxZ)
    }
    
    func createAreaOfEffect(minZ: Int, maxZ: Int, maxX: Int, maxY: Int) -> Cube {
        Cube(
            min: Vector(x: 0, y: 0, z: minZ),
            max: Vector(x: maxX, y: maxY, z: maxZ + 1)
        )
    }
    
    func remove(block: Cube, from blocks: [Cube]) -> [Cube] {
        var blocks = blocks
        blocks.remove(at: blocks.firstIndex(of: block)!)
        return blocks
    }
    
    func canRemove(block: Cube, blocks: [Cube], maxX: Int, maxY: Int) -> Bool {
        let areaOfEffect = createAreaOfEffect(minZ: block.min.z, maxZ: block.max.z, maxX: maxX, maxY: maxY)
        let fallingBlocks = blocks.filter {
            $0 != block && $0.overlapping(with: areaOfEffect)
        }
        
        for cube in fallingBlocks {
            let blocks2 = blocks.filter { ![block, cube].contains($0) }
            if canMoveDown(cube, blocks2) {
                return false
            }
        }
        
        return true
    }
    
    func countFall(_ blocks: [Cube]) -> Int {
        // position.z is vertical axis
        var count = 0
        var output = [Cube]()
        
        for var block in blocks.sorted(by: <) {
            var didMove = false
            while true {
                // if can move down decrement height
                if canMoveDown(block, output) {
                    didMove = true
                    block = block.move(Vector(x: 0, y: 0, z: -1))
                } else {
                    break
                }
            }
            count += (didMove ? 1 : 0)
            output.append(block)
        }
        
        return count
    }
    
    func makeFall(_ blocks: [Cube]) -> [Cube] {
        // position.z is vertical axis
        var output = [Cube]()
        
        for var block in blocks.sorted(by: <) {
            while true {
                // if can move down decrement height
                if canMoveDown(block, output) {
                    block = block.move(Vector(x: 0, y: 0, z: -1))
                } else {
                    break
                }
            }
            output.append(block)
        }
        
        return output
    }
    
    func canMoveDown(_ block: Cube, _ blocks: [Cube]) -> Bool {
        guard block.min.z > 0 else { return false }
        guard blocks.count > 0 else { return true }
        let block = block.move(Vector(x: 0, y: 0, z: -1))
        for cube in blocks {
            if block.overlapping(with: cube) {
                return false
            }
        }
        return true
    }
}

extension Cube {
    static func < (lhs: Cube, rhs: Cube) -> Bool {
        lhs.min.z < rhs.min.z
    }
}

extension Day22 {
    func parse(_ input: [String]) -> [Cube] {
        var blocks = [Cube]()
        
        for line in input {
            let components = line.components(separatedBy: CharacterSet(arrayLiteral: ",", "~")).map({ Int($0)! })
            let block = Cube(
                min: Vector(x: components[0], y: components[1], z: components[2]),
                max: Vector(x: components[3], y: components[4], z: components[5]))
            blocks.append(block)
        }
        
        return blocks
    }
}
