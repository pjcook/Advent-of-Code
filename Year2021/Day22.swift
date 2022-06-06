import Foundation
import StandardLibraries

public struct Day22 {
    public init() {}
        
    public func solve(_ input: [String]) -> Int {
        var cubes = [Cube]()
        for line in input {
            let state = line.hasPrefix("on") ? true : false
            let cube = convertToCube(line)
            var newCubes = [Cube]()

            for c1 in cubes {
                if cube.contains(c1) {
                    // Cube contains existing cube:
                } else if cube.overlapping(with: c1) {
                    let nonOverlapping = cube.dissect(with: c1)
                    newCubes.append(contentsOf: nonOverlapping)
                } else {
                    // Existing cube not overlapped:
                    newCubes.append(c1)
                }
            }
            
            if state {
                // Add new ON cube:
                newCubes.append(cube)
            }

            cubes = newCubes
        }
        
        // Calculating answer:
        return cubes.reduce(0, { $0 + $1.area })
    }
    
    private func convertToCube(_ line: String) -> Cube {
        let splits = line.split(separator: " ")[1].split(separator: ",").map { $0.dropFirst(2) }
        let x = splits[0].components(separatedBy: "..")
        let y = splits[1].components(separatedBy: "..")
        let z = splits[2].components(separatedBy: "..")
        
        let minX = min(Int(String(x[0]))!, Int(String(x[1]))!)
        let maxX = max(Int(String(x[0]))!, Int(String(x[1]))!)+1
        let minY = min(Int(String(y[0]))!, Int(String(y[1]))!)
        let maxY = max(Int(String(y[0]))!, Int(String(y[1]))!)+1
        let minZ = min(Int(String(z[0]))!, Int(String(z[1]))!)
        let maxZ = max(Int(String(z[0]))!, Int(String(z[1]))!)+1
        
        return Cube(min: Vector(x: minX,y: minY,z: minZ), max: Vector(x: maxX,y: maxY,z: maxZ))
    }
    
    public func naive_part1(_ input: [String]) -> Int {
        var cube = [Vector: Bool]()
        var i = 0
        for line in input {
            i += 1
            print(i)
            let state = line.hasPrefix("on") ? true : false
            
            let splits = line.split(separator: " ")[1].split(separator: ",").map { $0.dropFirst(2) }
            let x = splits[0].components(separatedBy: "..")
            let y = splits[1].components(separatedBy: "..")
            let z = splits[2].components(separatedBy: "..")
            
            let minX = min(Int(String(x[0]))!, Int(String(x[1]))!)
            let maxX = max(Int(String(x[0]))!, Int(String(x[1]))!)
            let minY = min(Int(String(y[0]))!, Int(String(y[1]))!)
            let maxY = max(Int(String(y[0]))!, Int(String(y[1]))!)
            let minZ = min(Int(String(z[0]))!, Int(String(z[1]))!)
            let maxZ = max(Int(String(z[0]))!, Int(String(z[1]))!)
            
            for x in (minX...maxX) {
                for y in (minY...maxY) {
                    for z in (minZ...maxZ) {
                        let vector = Vector(x: x,y: y,z: z)
                        if state {
                            cube[vector] = state
                        } else if cube[vector] != nil {
                            cube.removeValue(forKey: vector)
                        }
                    }
                }
            }
        }
        return cube.values.filter { $0 == true }.count
    }
}
