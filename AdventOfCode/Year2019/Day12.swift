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

func processPositions(moons: [Moon], numberOfSteps steps: Int) -> Int {
    for _ in 0..<steps {
        _ = moons.map { $0.calculateNextVelocity() }
        _ = moons.map { $0.applyNextVelocity() }
    }
    return moons.reduce(0) { $0 + ($1.position.sumOfAbsoluteValues * $1.velocity.sumOfAbsoluteValues) }
}

struct SetData: Hashable, Equatable {
    let position: Int
    let velocity: Int
}

func findRepeatingOrbits(moons: [Moon], numberOfSteps steps: Int) -> Int {
    var xSet = Set<[Moon: SetData]>()
    var ySet = Set<[Moon: SetData]>()
    var zSet = Set<[Moon: SetData]>()
    
    var xDict = [Moon: SetData]()
    var yDict = [Moon: SetData]()
    var zDict = [Moon: SetData]()
    
    moons.forEach {
        xDict[$0] = SetData(position: $0.position.x, velocity: $0.velocity.x)
        yDict[$0] = SetData(position: $0.position.y, velocity: $0.velocity.y)
        zDict[$0] = SetData(position: $0.position.z, velocity: $0.velocity.z)
    }
    
    xSet.insert(xDict)
    ySet.insert(yDict)
    zSet.insert(zDict)
    
    var xSetCount: Int?
    var ySetCount: Int?
    var zSetCount: Int?
    
    while xSetCount == nil || ySetCount == nil || zSetCount == nil {
        let xCount = xSet.count
        let yCount = ySet.count
        let zCount = zSet.count
        
        _ = moons.map { $0.calculateNextVelocity() }
        _ = moons.map { $0.applyNextVelocity() }
        
        moons.forEach {
            xDict[$0] = SetData(position: $0.position.x, velocity: $0.velocity.x)
            yDict[$0] = SetData(position: $0.position.y, velocity: $0.velocity.y)
            zDict[$0] = SetData(position: $0.position.z, velocity: $0.velocity.z)
        }
        
        xSet.insert(xDict)
        ySet.insert(yDict)
        zSet.insert(zDict)
        
        if xCount == xSet.count { xSetCount = xCount }
        if yCount == ySet.count { ySetCount = yCount }
        if zCount == zSet.count { zSetCount = zCount }
    }
    
    guard let xCount = xSetCount, let yCount = ySetCount, let zCount = zSetCount else { return -1 }
    
    return lowestCommonMultiple(xCount, lowestCommonMultiple(yCount, zCount))
}

func lowestCommonMultiple(_ value1: Int, _ value2: Int) -> Int {
    return (value1 * value2) / greatestCommonDivisor(value1, value2)
}

func greatestCommonDivisor(_ value1: Int, _ value2: Int) -> Int {
    var i = 0
    var j = max(value1, value2)
    var result = min(value1, value2)
    
    while result != 0 {
        i = j
        j = result
        result = i % j
    }
    
    return j
}
