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

public struct ReposeLineData {
    public enum LineDataType: Equatable {
        case beginShift(Int)
        case awake
        case asleep
        
        public var id: Int {
            switch self {
            case .beginShift(let id): return id
            default: return -1
            }
        }
    }
    
    public let date: ComponentizedDate
    public let content: String
    public let dataType: LineDataType
    
    public var minutes: Int {
        date.minutes
    }
    
    public init(_ input: String) throws {
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
    public var description: String {
        var output = reposeDateTimeFormatter.string(from: date.date)
        output += " \(dataType)"
        return output
    }
}

extension ReposeLineData.LineDataType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .asleep: return "asleep"
        case .awake: return "awake"
        case .beginShift(let id): return "guard #\(id)"
        }
    }
}

public struct Guard {
    public let id: Int
    public var sleepTimes: [SleepTime]
    
    public init(id: Int, sleepTimes: [SleepTime]) {
        self.id = id
        self.sleepTimes = sleepTimes
    }
    
    public var totalSleep: Int {
        sleepTimes.reduce(0) { $0 + ($1.end.minutes - $1.start.minutes) }
    }
    
    
    /// Return sleepiest minute and count
    public var sleepiestMinute: (Int, Int) {
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

public struct SleepTime {
    public let start: ComponentizedDate
    public let end: ComponentizedDate
    public init(start: ComponentizedDate, end: ComponentizedDate) {
        self.start = start
        self.end = end
    }
}

extension Guard: CustomStringConvertible {
    public var description: String {
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
