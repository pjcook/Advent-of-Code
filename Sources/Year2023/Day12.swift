import Foundation
import StandardLibraries

public struct Day12 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let survey = parse(input)
        return survey.reduce(0) { $0 + $1.numberOfConfigurations() }
    }
    
    public func part2(_ input: [String]) -> Int {
        let survey = parse2(input)
        return survey.reduce(0) { $0 + $1.numberOfConfigurations() }
    }
    
    public struct SurveyEntry {
        public let report: String
        public let contiguousGroups: [Int]
        
        init(report: String, contiguousGroups: [Int]) {
            self.report = report
            self.contiguousGroups = contiguousGroups
        }
        
        public init(_ input: String) {
            let components = input.components(separatedBy: CharacterSet(arrayLiteral: " ", ","))
            self.report = components[0]
            self.contiguousGroups = components[1...].map({ Int(String($0))! })
        }
    }
}

extension Day12.SurveyEntry {
    public func calculateOptions(input: String) -> [String] {
        var results = Set<String>()
        var toProcess = [(report, contiguousGroups, 0)]
        
        while let (nextReport, remainingGroups, currentIndex) = toProcess.popLast() {
            let currentGroup = remainingGroups.first!
            var index = currentIndex
            var newReport = nextReport
            while index < nextReport.count {
                if nextReport[index] == "." {
                    index += 1
                    continue
                }
                
                if canFitGroup(report: nextReport, startIndex: index, length: currentGroup) {
                    var newReport2 = newReport
                    for i in (index..<index+currentGroup) {
                        newReport[i] = "#"
                    }
                    
                    if remainingGroups.count > 1 {
                        toProcess.append((newReport, Array(remainingGroups[1...]), index + currentGroup))
                        
                        if newReport2[index] == "?" {
                            newReport2[index] = "."
                        }
                        toProcess.append((newReport2, remainingGroups, index + 1))
                        break
                    } else if isValid(report: newReport) {
                        results.insert(newReport)
                        break
                    } else {
                        break
                    }
                } else {
                    if newReport[index] == "?" {
                        newReport[index] = "."
                    }
                    index += 1
                }
            }
        }
        
        return Array(results)
    }
    
    public func numberOfConfigurations() -> Int {
        var results = Set<String>()
        results.insert(report)
        
        // calculate all options
        outerloop: for i in (0..<report.count) {
            let reports = results
            results.removeAll()
            
            for var report in reports {
                if report[i] == "?" {
                    report[i] = "."
                    results.insert(report)

                    report[i] = "#"
                    results.insert(report)
                } else {
                    results = reports
                    continue outerloop
                }
            }
        }
        
        return results.reduce(0) { $0 + (isValid(report: $1) ? 1 : 0) }
    }
    
    public func isValid(report: String) -> Bool {
        report.components(separatedBy: ".").map({ $0.count }).filter({ $0 > 0 }) == contiguousGroups
    }
    
    public func canFitGroup(report: String, startIndex: Int, length: Int) -> Bool {
        guard startIndex + length - 1 < report.count else { return false }
        let nextCharsFit = report[startIndex..<startIndex + length].reduce(true) { $0 && ["?", "#"].contains($1) }
        var nextAfterValid = true
        if startIndex + length < report.count {
            nextAfterValid = ["?", "."].contains(report[startIndex + length])
        }
        var previousValid = true
        if startIndex > 0 {
            previousValid = ["?", "."].contains(report[startIndex - 1])
        }
        return nextCharsFit && nextAfterValid && previousValid
    }
}

extension Day12 {
    func parse(_ input: [String]) -> [SurveyEntry] {
        input.map(SurveyEntry.init)
    }
    
    func parse2(_ input: [String]) -> [SurveyEntry] {
        var results = [SurveyEntry]()
        for line in input {
            let components = line.components(separatedBy: CharacterSet(arrayLiteral: " ", ","))
            let report = components[0] + components[0] + components[0] + components[0] + components[0]
            let groups = components[1...].map({ Int(String($0))! })
            let contiguousGroups = groups + groups + groups + groups + groups
            results.append(SurveyEntry(report: report, contiguousGroups: contiguousGroups))
        }
        return results
    }
}
