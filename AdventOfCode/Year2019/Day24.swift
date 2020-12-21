//
//  Day24.swift
//  Year2019
//
//  Created by PJ COOK on 01/01/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import Foundation

/*
.###.
##...
...##
.#.#.
#.#.#
 */

struct Info {
    let alive: Bool
    let value: Int
}

var data = [Point:Info]()
func day24Part1() -> Int {
    var results = [Int:Bool]()

    data = [
        Point(x:0,y:0):Info(alive: false, value: 1), Point(x:1,y:0):Info(alive: true, value: 2), Point(x:2,y:0):Info(alive: true, value: 4), Point(x:3,y:0):Info(alive: true, value: 8), Point(x:4,y:0):Info(alive: false, value: 16),
        Point(x:0,y:1):Info(alive: true, value: 32), Point(x:1,y:1):Info(alive: true, value: 64), Point(x:2,y:1):Info(alive: false, value: 128), Point(x:3,y:1):Info(alive: false, value: 256), Point(x:4,y:1):Info(alive: false, value: 512),
        Point(x:0,y:2):Info(alive: false, value: 1024), Point(x:1,y:2):Info(alive: false, value: 2048), Point(x:2,y:2):Info(alive: false, value: 4096), Point(x:3,y:2):Info(alive: true, value: 8192), Point(x:4,y:2):Info(alive: true, value: 16384),
        Point(x:0,y:3):Info(alive: false, value: 32768), Point(x:1,y:3):Info(alive: true, value: 65536), Point(x:2,y:3):Info(alive: false, value: 131072), Point(x:3,y:3):Info(alive: true, value: 262144), Point(x:4,y:3):Info(alive: false, value: 524288),
        Point(x:0,y:4):Info(alive: true, value: 1048576), Point(x:1,y:4):Info(alive: false, value: 2097152), Point(x:2,y:4):Info(alive: true, value: 4194304), Point(x:3,y:4):Info(alive: false, value: 8388608), Point(x:4,y:4):Info(alive: true, value: 16777216),
    ]
    
    var result = 0
    var found = false
    repeat {
        updateData()
        result = calculateResult()
        found = results[result, default: false]
        results[result] = true
    } while !found
    
    return result
}

func snapshotValue(_ point: Point) -> Bool {
    guard let info = data[point] else { return false }
    return info.alive
}

func isAlive(_ point: Point, _ info: Info) -> Bool {
    var count = 0
    count += snapshotValue(point + Direction.N.point) ? 1 : 0
    count += snapshotValue(point + Direction.E.point) ? 1 : 0
    count += snapshotValue(point + Direction.S.point) ? 1 : 0
    count += snapshotValue(point + Direction.W.point) ? 1 : 0
    switch info.alive {
        case true:
        return count == 1
        case false:
        return [1,2].contains(count)
    }
}

func updateData() {
    var newData = [Point:Info]()
    _ = data.map {
        let info = Info(alive: isAlive($0.key, $0.value), value: $0.value.value)
        newData[$0.key] = info
    }
    data = newData
}

func calculateResult() -> Int {
    return data.reduce(0) { $0 + (
        $1.value.alive ? $1.value.value : 0
        ) }
}

// 22372462 - default result
// 28717468 - part 1
