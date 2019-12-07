//
//  Day4.swift
//  Year2018
//
//  Created by PJ COOK on 06/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

let reposeDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter
}()

struct ReposeLineData {
    enum LineDataType: Equatable {
        case beginShift(Int)
        case awake
        case asleep
    }
    
    let date: Date
    let content: String
    let dataType: LineDataType
    
    init(_ input: String) throws {
        var input = input
        _ = input.removeFirst()
        var d = ""
        for _ in (0..<16) {
            d += String(input.removeFirst())
        }

        guard let date = reposeDateFormatter.date(from: d) else { throw Errors.dateContersionFailed }
        self.date = date
        _ = input.removeFirst()
        _ = input.removeFirst()
        content = input
        
        let elements = content.split(separator: " ")
        switch elements[0].lowercased() {
        case "guard":
            var id = elements[1]
            _ = id.removeFirst()
            guard let guardID = Int(id) else { throw Errors.invalidReposeLineDataType }
            dataType = .beginShift(guardID)
        case "falls": dataType = .asleep
        case "wakes": dataType = .awake
        default:
            throw Errors.invalidReposeLineDataType
        }
    }
}

enum Wakefulness {
    case awake
    case asleep
}

struct ReposeItem {
    let date: Date
    let state: Wakefulness
}

struct ReposeData {
    let id: Int
    let data: [ReposeItem]
}

func parseReposeRecords(_ input: [String]) throws -> [ReposeData] {
    return []
}
