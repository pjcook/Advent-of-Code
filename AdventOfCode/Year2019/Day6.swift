//
//  Day6.swift
//  Year2019
//
//  Created by PJ COOK on 06/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
typealias PlanetID = String

extension PlanetID {
    static let centerOfMass = PlanetID("COM")
    static let you = PlanetID("YOU")
    static let santa = PlanetID("SAN")
}

struct UniversalOrbitMap {
    private var orbits: [PlanetID:PlanetID] = [:]
    var totalOrbits: Int {
        return orbits.reduce(0) { $0 + countOrbitChain($1.key) }
    }
    
    init(_ data: [String]) {
        var orbits = [PlanetID:PlanetID]()
        for value in data {
            let items = value.split(separator: ")").map { PlanetID($0) }
            let item0 = items[0]
            let item1 = items[1]
            
            orbits[item1] = item0
        }
        self.orbits = orbits
    }
    
    func distance(of: PlanetID, to: PlanetID) -> Int {
        let chain1 = chain(of)
        let chain2 = chain(to)
        var count = 0
        for i in 0..<min(chain1.count, chain2.count) {
            if chain1[i] == chain2[i] {
                count += 1
            } else {
                break
            }
        }
        return chain1.count - count + chain2.count - count - 2
    }
    
    func distanceZip(of: PlanetID, to: PlanetID) -> Int {
        let chain1 = chain(of)
        let chain2 = chain(to)
        var count = 0
        
        for (item1, item2) in zip(chain1, chain2) {
            if item1 == item2 { count += 1 }
            else { break }
        }
        
        return chain1.count - count + chain2.count - count - 2
    }
    
    private func countOrbitChain(_ id: PlanetID) -> Int {
        if id == PlanetID.centerOfMass {
            return 0
        } else if let ancestor = orbits[id] {
            return countOrbitChain(ancestor) + 1
        } else {
            return 0
        }
    }
    
    private func chain(_ id: PlanetID) -> [PlanetID] {
        if id == PlanetID.centerOfMass {
            return [id]
        } else if let ancestor = orbits[id] {
            return chain(ancestor) + [id]
        } else {
            return [id]
        }
    }
}
