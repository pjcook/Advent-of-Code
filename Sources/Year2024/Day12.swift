import Foundation
import StandardLibraries

public struct Day12 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let survey = parse(input)
        return survey.reduce(0) { $0 + $1.calculateOptions() }
    }
    
    public func part2(_ input: [String]) -> Int {
        let survey = parse2(input)
        return survey.reduce(0) { $0 + $1.calculateOptions() }
    }
    
    public func part1Paulson(_ input: [String]) -> Int {
        let survey = parse(input)
        let jp = JonathanPaulsonDay12()
        return survey.reduce(0) {
            $0 + jp.beginScore(dots: $1.report, blocks: $1.contiguousGroups, i: 0, bi: 0, current: 0)
        }
    }
    
    public func part2Paulson(_ input: [String]) -> Int {
        let survey = parse2(input)
        let jp = JonathanPaulsonDay12()
        return survey.reduce(0) {
            $0 + jp.beginScore(dots: $1.report, blocks: $1.contiguousGroups, i: 0, bi: 0, current: 0)
        }
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

extension Day12 {
    class JonathanPaulsonDay12 {
        /// Thanks and credit to Jonathan Paulson. Converted from his Python solution
        /// https://github.com/jonathanpaulson/AdventOfCode/blob/master/2023/12.py

        struct Key: Hashable {
            let i: Int
            let bi: Int
            let current: Int
        }
        var lookup = [Key: Int]()
        
        func beginScore(dots: String, blocks: [Int], i: Int, bi: Int, current: Int) -> Int {
            lookup.removeAll()
            return calculateScore(dots: dots, blocks: blocks, i: i, bi: bi, current: current)
        }

        /// # i == current position within dots
        /// # bi == current position within blocks
        /// # current == length of current block of '#'
        /// # state space is len(dots) * len(blocks) * len(dots)
        private func calculateScore(dots: String, blocks: [Int], i: Int, bi: Int, current: Int) -> Int {
            let key = Key(i: i, bi: bi, current: current)
            if let value = lookup[key] {
                return value
            }
            
            if i == dots.count {
                if bi == blocks.count && current == 0 {
                    return 1
                } else if bi == blocks.count-1 && blocks[bi] == current {
                    return 1
                } else {
                    return 0
                }
            }
            
            var ans = 0
            for c in [".", "#"] {
                if dots[i] == c || dots[i] == "?" {
                    if c == "." && current == 0 {
                        ans += calculateScore(dots: dots, blocks: blocks, i: i+1, bi: bi, current: 0)
                    } else if c == "." && current > 0 && bi < blocks.count && blocks[bi] == current {
                        ans += calculateScore(dots: dots, blocks: blocks, i: i+1, bi: bi+1, current: 0)
                    } else if c == "#" {
                        ans += calculateScore(dots: dots, blocks: blocks, i: i+1, bi: bi, current: current+1)
                    }
                }
            }
            lookup[key] = ans
            return ans
        }
    }
}

extension Day12.SurveyEntry {
    public func calculateOptions() -> Int {
        var result = 0
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
                            toProcess.append((newReport2, remainingGroups, index + 1))
                        }
                        break
                    } else {
                        if isValid(report: newReport.replacingOccurrences(of: "?", with: ".")) {
                            result += 1
                        }
                        
                        if newReport2[index] == "?" {
                            newReport2[index] = "."
                            toProcess.append((newReport2, remainingGroups, index + 1))
                        }
                        
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
        
        return result
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
            let report = components[0] + "?" + components[0] + "?" + components[0] + "?" + components[0] + "?" + components[0]
            let groups = components[1...].map({ Int(String($0))! })
            let contiguousGroups = groups + groups + groups + groups + groups
            results.append(SurveyEntry(report: report, contiguousGroups: contiguousGroups))
        }
        return results
    }
}
