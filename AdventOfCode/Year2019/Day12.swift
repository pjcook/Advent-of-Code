//
//  Day12.swift
//  Year2019
//
//  Created by PJ COOK on 11/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

struct Vector: Hashable, CustomDebugStringConvertible {
    let x: Int
    let y: Int
    let z: Int
    
    static let zero = Vector(x: 0, y: 0, z: 0)
    
    static func + (lhs: Vector, rhs: Vector) -> Vector {
        return Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    
    var debugDescription: String {
        "x:\(x),y:\(y),z:\(z)"
    }
    
    var sumOfAbsoluteValues: Int {
        return abs(x) + abs(y) + abs(z)
    }
}

func parseMoonInput(_ input: String) -> Vector {
    var input = input
    _ = input.removeFirst()
    _ = input.removeLast()
    let parts = input.split(separator: ",")
    var values = [Int]()
    for part in parts {
        values.append(Int(String(part.split(separator: "=")[1])) ?? 0)
    }
    return Vector(x: values[0], y: values[1], z: values[2])
}

func parseMoonInput(_ input: [String]) -> [Vector] {
    var moons = [Vector]()
    for item in input {
        moons.append(parseMoonInput(item))
    }
    return moons
}

class Moon: Hashable, CustomDebugStringConvertible {
    let startPosition: Vector
    var position: Vector
    var velocity = Vector.zero
    var otherMoons = [Moon]()
    var nextVelocity = Vector.zero
    
    init(_ startPosition: Vector) {
        self.startPosition = startPosition
        position = startPosition
    }
    
    func calculateNextVelocity() {
        var x = 0
        var y = 0
        var z = 0
        
        for om in otherMoons {
            x += calculateVelocity(a: position.x, b: om.position.x)
            y += calculateVelocity(a: position.y, b: om.position.y)
            z += calculateVelocity(a: position.z, b: om.position.z)
        }
        
        nextVelocity = Vector(x: x, y: y, z: z) + velocity
    }
    
    func calculateVelocity(a: Int, b: Int) -> Int {
        if a > b { return -1 }
        if a < b { return 1 }
        return 0
    }
    
    func applyNextVelocity() {
        position = position + nextVelocity
        velocity = nextVelocity
        nextVelocity = .zero
    }
    
    var debugDescription: String {
        return "\(position):\(velocity)\n"
    }
    
    static func == (lhs: Moon, rhs: Moon) -> Bool {
        lhs.startPosition == rhs.startPosition
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(startPosition)
    }
}

fileprivate func calculateNextPositions(_ moons: inout [Vector], _ moonVelocities: inout [Vector], _ moonCount: Int) {
    let snapshot = moons
    let snapshotVelocity = moonVelocities
    for i in 0..<moonCount {
        let moon = snapshot[i]
        let otherMoons = snapshot.filter { $0 != moon }
        let velocity = calculateVelocity(moon: moon, otherMoons: otherMoons) + snapshotVelocity[i]
        moons[i] = moon + velocity
        moonVelocities[i] = velocity
    }
}

func findRepeatingOrbits(moons: [Vector], numberOfSteps steps: Int) -> Int {
    var moons = moons
    var moonVelocities = moons.map { _ in Vector.zero }
    let moonCount = moons.count
//    var history = [[moons,moonVelocities]]
    let history = [moons,moonVelocities]
    for i in 0..<steps {
        calculateNextPositions(&moons, &moonVelocities, moonCount)
//        if history.contains([moons,moonVelocities]) {
        if history == [moons,moonVelocities] {
            return i + 1
        }
//        history.append([moons, moonVelocities])
    }
    
    return -1
}

func findRepeatingOrbits3(moons: [Moon], numberOfSteps steps: Int) -> Int {
    var xs = Set<String>()
    var ys = Set<String>()
    var zs = Set<String>()
    var count = 0
    
    var prevX = xs.count
    var prevY = ys.count
    var prevZ = zs.count
    
    repeat {
        count += 1
        let x = 
        
        
        prevX = xs.count
        prevY = ys.count
        prevZ = zs.count
    } while xs.count != prevX && ys.count != prevY && zs.count != prevZ
    
    return count
}

func findRepeatingOrbits2(moons: [Moon], numberOfSteps steps: Int) -> Int {
    var hashes = [Int:Bool]()
    var history = [[Moon]]()
    for i in 0..<steps {
        _ = moons.map { $0.calculateNextVelocity() }
        _ = moons.map { $0.applyNextVelocity() }
        history.append(moons)
        let hashCount = hashes.count
        var hasher = Hasher()
        _ = moons.map {
            hasher.combine($0.position)
            hasher.combine($0.velocity)
        }
        hashes[hasher.finalize()] = true
        if hashCount == hashes.count {
            print(history)
            return i
        }
        if hashCount % 1000000 == 0 {
            print(hashCount)
        }
    }
    return -1
}

func processPositions2(moons: [Moon], numberOfSteps steps: Int) -> Int {
    for _ in 0..<steps {
        _ = moons.map { $0.calculateNextVelocity() }
        _ = moons.map { $0.applyNextVelocity() }
    }
    return moons.reduce(0) { $0 + ($1.position.sumOfAbsoluteValues * $1.velocity.sumOfAbsoluteValues) }
}

func processPositions(moons: [Vector], numberOfSteps steps: Int) -> Int {
    var moons = moons
    var moonVelocities = moons.map { _ in Vector.zero }
    let moonCount = moons.count
    for _ in 0..<steps {
        calculateNextPositions(&moons, &moonVelocities, moonCount)
    }
    
    return calculateTotalSystemEnergy(moons, moonVelocities)
}

func calculateTotalSystemEnergy(_ moons: [Vector], _ velocities: [Vector]) -> Int {
    var energy = 0
    for i in 0..<moons.count {
        energy += moons[i].sumOfAbsoluteValues * velocities[i].sumOfAbsoluteValues
    }
    return energy
}

func calculateVelocity(moon: Vector, otherMoons: [Vector]) -> Vector {
    var x = 0
    var y = 0
    var z = 0
    
    for om in otherMoons {
        x += calculateVelocity(a: moon.x, b: om.x)
        y += calculateVelocity(a: moon.y, b: om.y)
        z += calculateVelocity(a: moon.z, b: om.z)
    }
    
    return Vector(x: x, y: y, z: z)
}

func calculateVelocity(a: Int, b: Int) -> Int {
    if a > b { return -1 }
    if a < b { return 1 }
    return 0
}
