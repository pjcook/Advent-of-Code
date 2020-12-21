//
//  Day3.swift
//  Year2018
//
//  Created by PJ COOK on 06/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

struct FabricClaim {
    let id: Int
    let x: Int
    let y: Int
    let width: Int
    let height: Int
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

func parseFabricClaim(_ input: String) throws -> FabricClaim {
    let parts = input.split(separator: " ")
    guard parts.count == 4, let id = Int(parts[0].dropFirst()) else { throw Errors.invalidFabricCode }
    let coords = parts[2].dropLast().split(separator: ",")
    let dimensions = parts[3].split(separator: "x")
    
    guard
        let x = Int(coords[0]),
        let y = Int(coords[1]),
        let width = Int(dimensions[0]),
        let height = Int(dimensions[1])
    else { throw Errors.invalidFabricCode }
    
    return FabricClaim(id: id, x: x, y: y, width: width, height: height)
}

func parseFabricClaims(_ input: [String]) throws -> [Int : FabricClaim] {
    var claims = [Int : FabricClaim]()
    _ = try input.map {
        let claim = try parseFabricClaim($0)
        claims[claim.id] = claim
    }
    return claims
}

func mapClaimData(_ claims: [Int : FabricClaim]) throws -> [CGPoint:[Int]] {
    var map = [CGPoint:[Int]]()
    
    for claim in claims.values {
        for x in claim.x ..< claim.x + claim.width {
            for y in claim.y ..< claim.y + claim.height {
                let point = CGPoint(x: x, y: y)
                var list = map[point, default: []]
                list.append(claim.id)
                map[point] = list
            }
        }
    }
    
    return map
}

func mapClaims(_ input: [String]) throws -> Int {
    let claims = try parseFabricClaims(input)
    let map = try mapClaimData(claims)
    return map.reduce(0) { $0 + ($1.value.count > 1 ? 1 : 0) }
}

func findUniqueClaim(_ input: [String]) throws -> Int {
    let claims = try parseFabricClaims(input)
    let map = try mapClaimData(claims)
    let singleTiles = map.filter { $0.value.count == 1 }
    var singleTileData = [Int:Int]()
    singleTiles.forEach {
        guard let id = $0.value.first else { return }
        singleTileData[id] = (singleTileData[id, default: 0]) + 1
    }
    
    for (id, count) in singleTileData {
        guard let claim = claims[id] else { continue }
        if claim.height * claim.width == count { return id }
    }
    
    throw Errors.noUniqueClaimFound
}
