//
//  Day4.swift
//  Year2018
//
//  Created by PJ COOK on 06/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

let reposeDateTimeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter
}()

struct ReposeLineData {
    enum LineDataType: Equatable {
        case beginShift(Int)
        case awake
        case asleep
        
        var id: Int {
            switch self {
            case .beginShift(let id): return id
            default: return -1
            }
        }
    }
    
    let date: Date
    let content: String
    let dataType: LineDataType
    
    var minutes: Int {
        Calendar.current.dateComponents([.minute], from: date).minute ?? -1
    }
    
    init(_ input: String) throws {
        var input = input
        _ = input.removeFirst()
        var d = ""
        for _ in (0..<16) {
            d += String(input.removeFirst())
        }

        guard let date = reposeDateTimeFormatter.date(from: d) else { throw Errors.dateContersionFailed }
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

extension ReposeLineData: CustomStringConvertible {
    var description: String {
        var output = reposeDateTimeFormatter.string(from: date)
        output += " \(dataType)"
        return output
    }
}

extension ReposeLineData.LineDataType: CustomStringConvertible {
    var description: String {
        switch self {
        case .asleep: return "asleep"
        case .awake: return "awake"
        case .beginShift(let id): return "guard #\(id)"
        }
    }
}

struct Guard {
    let id: Int
    var sleepTimes: [SleepTime]
    
    var totalSleep: Int {
        var sleep = 0
        
        sleepTimes.forEach {
            let startMin = Calendar.current.dateComponents([.minute], from: $0.start).minute!
            let endMin = Calendar.current.dateComponents([.minute], from: $0.end).minute!
            sleep += endMin - startMin
        }
        
        return sleep
    }
    
    
    /// Return sleepiest minute and count
    var sleepiestMinute: (Int, Int) {
        var minutes = Array(repeating: 0, count: 60)
        
        sleepTimes.forEach {
            let startMin = Calendar.current.dateComponents([.minute], from: $0.start).minute!
            let endMin = Calendar.current.dateComponents([.minute], from: $0.end).minute!
            for i in startMin..<endMin {
                minutes[i] = minutes[i] + 1
            }
        }
        
        var index = 0
        var maxValue = 0
        for (i, value) in minutes.enumerated() {
            if value > maxValue {
                index = i
                maxValue = value
            }
        }
        
        return (index, minutes[index])
    }
}

struct SleepTime {
    let start: Date
    let end: Date
}

extension Guard: CustomStringConvertible {
    var description: String {
        var output = ""
        var times = sleepTimes
        var currentMonth = 0
        var currentDay = 0
        var lastMinute = 0
        
        while !times.isEmpty {
            let st = times.removeFirst()
            let components1 = Calendar.current.dateComponents([.month, .day, .minute], from: st.start)
            let components2 = Calendar.current.dateComponents([.month, .day, .minute], from: st.end)
            
            if currentDay == 0 || currentMonth != components1.month! || currentDay != components1.day! {
                output += String(repeating: ".", count: 60-lastMinute)
                output += "\n"
                currentMonth = components1.month!
                currentDay = components1.day!
                output += "\(currentMonth)-\(currentDay) "
                lastMinute = 0
            }
            
            output += String(repeating: ".", count: components1.minute!-lastMinute)
            output += String(repeating: "#", count: components2.minute!-components1.minute!)
            
            lastMinute = components2.minute!
        }
        
        output += String(repeating: ".", count: 60-lastMinute)
        output += "\n"
        
        return output
    }
}
