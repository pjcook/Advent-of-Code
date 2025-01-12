//
//  Day12.swift
//  Year2019
//
//  Created by PJ COOK on 11/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import StandardLibraries

extension Vector {
    public var sumOfAbsoluteValues: Int {
        return abs(x) + abs(y) + abs(z)
    }
}

public func parseMoonInput(_ input: String) -> Vector {
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

public func parseMoonInput(_ input: [String]) -> [Vector] {
    var moons = [Vector]()
    for item in input {
        moons.append(parseMoonInput(item))
    }
    return moons
}

public class Moon: Hashable, CustomDebugStringConvertible {
    public let startPosition: Vector
    public var position: Vector
    public var velocity = Vector.zero
    public var otherMoons = [Moon]()
    public var nextVelocity = Vector.zero
    
    public init(_ startPosition: Vector) {
        self.startPosition = startPosition
        position = startPosition
    }
    
    public func calculateNextVelocity() {
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
    
    public func calculateVelocity(a: Int, b: Int) -> Int {
        if a > b { return -1 }
        if a < b { return 1 }
        return 0
    }
    
    public func applyNextVelocity() {
        position = position + nextVelocity
        velocity = nextVelocity
        nextVelocity = .zero
    }
    
    public var debugDescription: String {
        return "\(position):\(velocity)\n"
    }
    
    public static func == (lhs: Moon, rhs: Moon) -> Bool {
        lhs.startPosition == rhs.startPosition
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(startPosition)
    }
}

public func processPositions(moons: [Moon], numberOfSteps steps: Int) -> Int {
    for _ in 0..<steps {
        _ = moons.map { $0.calculateNextVelocity() }
        _ = moons.map { $0.applyNextVelocity() }
    }
    return moons.reduce(0) { $0 + ($1.position.sumOfAbsoluteValues * $1.velocity.sumOfAbsoluteValues) }
}

public struct SetData: Hashable, Equatable {
    public let position: Int
    public let velocity: Int
}

fileprivate func calculateSetData(_ moons: [Moon], _ xDict: inout [Moon : SetData], _ yDict: inout [Moon : SetData], _ zDict: inout [Moon : SetData], _ xSet: inout Set<[Moon : SetData]>, _ ySet: inout Set<[Moon : SetData]>, _ zSet: inout Set<[Moon : SetData]>) {
    moons.forEach {
        xDict[$0] = SetData(position: $0.position.x, velocity: $0.velocity.x)
        yDict[$0] = SetData(position: $0.position.y, velocity: $0.velocity.y)
        zDict[$0] = SetData(position: $0.position.z, velocity: $0.velocity.z)
    }
    
    xSet.insert(xDict)
    ySet.insert(yDict)
    zSet.insert(zDict)
}

public func findRepeatingOrbits(moons: [Moon], numberOfSteps steps: Int) -> Int {
    var xSet = Set<[Moon: SetData]>()
    var ySet = Set<[Moon: SetData]>()
    var zSet = Set<[Moon: SetData]>()
    
    var xDict = [Moon: SetData]()
    var yDict = [Moon: SetData]()
    var zDict = [Moon: SetData]()
    
    calculateSetData(moons, &xDict, &yDict, &zDict, &xSet, &ySet, &zSet)
    
    var xSetCount: Int?
    var ySetCount: Int?
    var zSetCount: Int?
    
    while xSetCount == nil || ySetCount == nil || zSetCount == nil {
        let xCount = xSet.count
        let yCount = ySet.count
        let zCount = zSet.count
        
        _ = moons.map { $0.calculateNextVelocity() }
        _ = moons.map { $0.applyNextVelocity() }
        
        calculateSetData(moons, &xDict, &yDict, &zDict, &xSet, &ySet, &zSet)
        
        if xCount == xSet.count { xSetCount = xCount }
        if yCount == ySet.count { ySetCount = yCount }
        if zCount == zSet.count { zSetCount = zCount }
    }
    
    guard let xCount = xSetCount, let yCount = ySetCount, let zCount = zSetCount else { return -1 }
    
    return lowestCommonMultiple(xCount, lowestCommonMultiple(yCount, zCount))
}
