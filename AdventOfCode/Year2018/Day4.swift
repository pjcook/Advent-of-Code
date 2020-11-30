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
    
    let date: ComponentizedDate
    let content: String
    let dataType: LineDataType
    
    var minutes: Int {
        date.minutes
    }
    
    init(_ input: String) throws {
        var input = input
        _ = input.removeFirst()
        var d = ""
        for _ in (0..<16) {
            d += String(input.removeFirst())
        }

        guard let date = reposeDateTimeFormatter.date(from: d) else { throw Errors.dateContersionFailed }
        self.date = ComponentizedDate(date)
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
        var output = reposeDateTimeFormatter.string(from: date.date)
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
        sleepTimes.reduce(0) { $0 + ($1.end.minutes - $1.start.minutes) }
    }
    
    
    /// Return sleepiest minute and count
    var sleepiestMinute: (Int, Int) {
        var minutes = Array(repeating: 0, count: 60)

        sleepTimes.forEach {
            for i in $0.start.minutes..<$0.end.minutes {
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
    let start: ComponentizedDate
    let end: ComponentizedDate
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
            if currentDay == 0 || currentMonth != st.start.month || currentDay != st.start.day {
                output += String(repeating: ".", count: 60-lastMinute)
                output += "\n"
                currentMonth = st.start.month
                currentDay = st.start.day
                output += "\(currentMonth)-\(currentDay) "
                lastMinute = 0
            }
            
            output += String(repeating: ".", count: st.start.minutes-lastMinute)
            output += String(repeating: "#", count: st.end.minutes-st.start.minutes)
            
            lastMinute = st.end.minutes
        }
        
        output += String(repeating: ".", count: 60-lastMinute)
        output += "\n"
        
        return output
    }
}
