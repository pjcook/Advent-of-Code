import Foundation
import StandardLibraries

public struct Day17 {
    /*
     - If a cube is active and exactly 2 or 3 of its neighbors are also active, the cube remains active. Otherwise, the cube becomes inactive.
     - If a cube is inactive but exactly 3 of its neighbors are active, the cube becomes active. Otherwise, the cube remains inactive.
     */
    
    public init() {}
    
    public enum State: String {
        case active = "#"
        case inActive = "."
    }
    
    public func parse(_ input: [String]) -> [Vector: State] {
        var data = [Vector:State]()
        let count = input.count
        let half = count / 2
        for y in 0..<count {
            for x in 0..<count {
                data[Vector(x: x - half, y: y - half, z: 0)] = State(rawValue: String(input[y][x]))
            }
        }
        return data
    }
    
    public func padData(_ input: [Vector: State]) -> [Vector: State] {
        var newItems = Set<Vector>()
        for item in input {
            for x in Vector.adjacent {
                let v = item.key + x
                if input[v] == nil {
                    newItems.insert(v)
                }
            }
        }
        
        var output = input
        for v in newItems {
            output[v] = .inActive
        }
        
        return output
    }
    
    public func part1(_ input: [String]) -> Int {
        let cycles = 6
        var data = parse(input)
        
        for _ in 1...cycles {
//            draw(data, length: input.count + cycle + 1, cycle: cycle)
            data = padData(data)
            var updated = data
            for item in data {
                let activeCount = item.key.findActive(data)
                switch item.value {
                case .active:
                    updated[item.key] = [2,3].contains(activeCount) ? .active : .inActive
                case .inActive:
                    updated[item.key] = activeCount == 3 ? .active : .inActive
                }
            }
            data = updated
        }
        
        return data.values.filter({ $0 == .active }).count
    }
}

extension Vector {
    func findActive(_ input: [Vector: Day17.State]) -> Int {
        return Vector.adjacent.filter { input[self + $0] == .active }.count
    }
}

extension Day17 {
    public func draw(_ input: [Vector: State], length: Int, cycle: Int) {
        print("Cycle", cycle)
        let half = length / 2
        for z in 0..<length {
            print("z", z - half)
            for y in 0..<length {
                var line = ""
                for x in 0..<length {
                    let vector = Vector(x: x - half, y: y - half, z: z - half)
                    line += input[vector]?.rawValue ?? "?"
                }
                print(line)
            }
            print("")
        }
    }
}

public struct Day17Part2 {
    public init() {}
    public func parse(_ input: [String]) -> [WeirdVector:Day17.State] {
        var data = [WeirdVector:Day17.State]()
        let count = input.count
        let half = count / 2
        for y in 0..<count {
            for x in 0..<count {
                data[WeirdVector(w: 0, z: 0, y: y - half, x: x - half)] = Day17.State(rawValue: String(input[y][x]))
            }
        }
        return data
    }
    
    public func padData(_ input: [WeirdVector: Day17.State]) -> [WeirdVector: Day17.State] {
        var newItems = Set<WeirdVector>()
        for item in input {
            for x in WeirdVector.adjacent {
                let v = item.key + x
                if input[v] == nil {
                    newItems.insert(v)
                }
            }
        }
        
        var output = input
        for v in newItems {
            output[v] = .inActive
        }
        
        return output
    }
        
    public func part2(_ input: [String]) -> Int {
        let cycles = 6
        var data = parse(input)
        for _ in 1...cycles {
            data = padData(data)
            var updated = data
            for item in data {
                let activeCount = item.key.findActive(data)
                switch item.value {
                case .active:
                    updated[item.key] = [2,3].contains(activeCount) ? .active : .inActive
                case .inActive:
                    updated[item.key] = activeCount == 3 ? .active : .inActive
                }
            }
            data = updated
        }
        
        return data.values.filter({ $0 == .active }).count
    }
    
    public struct WeirdVector: Hashable {
        public let w: Int
        public let z: Int
        public let y: Int
        public let x: Int
        
        public init(w: Int, z: Int, y: Int, x: Int) {
            self.w = w
            self.z = z
            self.y = y
            self.x = x
        }
        
        func findActive(_ input: [WeirdVector: Day17.State]) -> Int {
            return WeirdVector.adjacent.filter { input[self + $0] == .active }.count
        }
        
        static var adjacent: Set<WeirdVector> = {
            var items = Set<WeirdVector>()
            for w in (-1...1) {
                for z in (-1...1) {
                    for y in (-1...1) {
                        for x in (-1...1) {
                            items.insert(WeirdVector(w: w, z: z, y: y, x: x))
                        }
                    }
                }
            }
            items.remove(.zero)
            return items
        }()
        
        static let zero = WeirdVector(w: 0, z: 0, y: 0, x: 0)
        
        static func + (lhs: WeirdVector, rhs: WeirdVector) -> WeirdVector {
            return WeirdVector(w: lhs.w + rhs.w, z: lhs.z + rhs.z, y: lhs.y + rhs.y, x: lhs.x + rhs.x)
        }
    }
}
