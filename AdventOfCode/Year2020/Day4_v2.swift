import Foundation
import StandardLibraries

public struct Day4_v2 {
    public init() {}
    
    public static var regexes: [NSRegularExpression] { [
        Day4_v2.pidRegex,
        Day4_v2.byrRegex,
        Day4_v2.iyrRegex,
        Day4_v2.hgtRegex,
        Day4_v2.hclRegex,
        Day4_v2.eclRegex,
        Day4_v2.eyrRegex,
        ]
    }

    public static let pidRegex = try! NSRegularExpression(pattern: "(\\bpid:[0-9]{9}\\b){1}", options: .caseInsensitive)
    public static let byrRegex = try! NSRegularExpression(pattern: "(\\bbyr:(19[2-9][0-9]|199[0-9]|200[0-2])){1}", options: .caseInsensitive)
    public static let iyrRegex = try! NSRegularExpression(pattern: "(\\biyr:(201[0-9]|2020)){1}", options: .caseInsensitive)
    public static let hgtRegex = try! NSRegularExpression(pattern: "(\\bhgt:((59|6[0-9]|7[0-6])in|(1[5-8][0-9]|19[0-3])cm)){1}", options: .caseInsensitive)
    public static let hclRegex = try! NSRegularExpression(pattern: "(\\bhcl:#[0-9a-f]{6}){1}", options: .caseInsensitive)
    public static let eclRegex = try! NSRegularExpression(pattern: "(\\becl:(amb|blu|brn|gry|grn|hzl|oth)){1}", options: .caseInsensitive)
    public static let eyrRegex = try! NSRegularExpression(pattern: "(\\beyr:(202[0-9]|2030)){1}", options: .caseInsensitive)

    public static let masterRegex = try! NSRegularExpression(pattern: "((\\bpid:[0-9]{9}\\b){1}|(\\bbyr:(19[2-9][0-9]|199[0-9]|200[0-2])){1}|(\\biyr:(201[0-9]|2020)){1}|(\\bhgt:((59|6[0-9]|7[0-6])in|(1[5-8][0-9]|19[0-3])cm)){1}|(\\bhcl:#[0-9a-f]{6}){1}|(\\becl:(amb|blu|brn|gry|grn|hzl|oth)){1}|(\\beyr:(202[0-9]|2030)){1})", options: .caseInsensitive)
    
    public static let part1Regex = try! NSRegularExpression(pattern: "((\\bpid:){1}|(\\bbyr:){1}|(\\biyr:){1}|(\\bhgt:){1}|(\\bhcl:){1}|(\\becl:){1}|(\\beyr:){1})", options: .caseInsensitive)

    public func validate2(input: [String]) -> Int {
        return input
            .split(whereSeparator: { $0.isEmpty })
            .map { $0.joined(separator: " ") }
            .filter { validatePassport(passport: $0) }.count
    }
    
    public func validate3(input: [String], regexes: [NSRegularExpression]) -> Int {
        return input
            .split(whereSeparator: { $0.isEmpty })
            .map { $0.joined(separator: " ") }
            .filter { validatePassport2(passport: $0, regexes: regexes) }.count
    }
    
    public func validate4(input: [String], regex: NSRegularExpression) -> Int {
        return input
            .split(whereSeparator: { $0.isEmpty })
            .map { $0.joined(separator: " ") }
            .filter { validatePassport3(passport: $0, regex: regex) }.count
    }
    
    public func validatePassport(passport: String) -> Bool {
        let requiredFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
        let passport = passport.trimmingCharacters(in: .whitespacesAndNewlines)
        var dict = [String: String]()
        passport
            .split(separator: " ")
            .forEach {
                let components = $0.split(separator: ":")
                dict[String(components[0])] = String(components[1])
            }
        return Day4.validate(dict, requiredFields)
    }
    
    public func validatePassport2(passport: String, regexes: [NSRegularExpression]) -> Bool {
        let range = NSRange(location: 0, length: passport.utf16.count)
        for regex in regexes {
            if regex.firstMatch(in: passport, options: [], range: range) == nil {
                return false
            }
        }
        return true
    }
    
    public func validatePassport3(passport: String, regex: NSRegularExpression) -> Bool {
        let range = NSRange(location: 0, length: passport.utf16.count)
        let results = regex.matches(in: passport, options: [], range: range)
        return results.count == 7
    }
}
