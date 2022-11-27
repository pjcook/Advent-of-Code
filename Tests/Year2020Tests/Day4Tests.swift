import XCTest
import InputReader
import Year2020

class Day4Tests: XCTestCase {
    let input = Input("Day4.input", .module).lines
    
    func test_part1() {
        let day = Day4()
        let count = day.validate(input: input, validate: Day4.validateBasic)
        XCTAssertEqual(213, count)
    }
    
    func test_part2() {
        let day = Day4()
        let count = day.validate(input: input, validate: Day4.validate)
        XCTAssertEqual(147, count)
    }
    
    func test_part2_v2() {
        let day = Day4_v2()
        let count = day.validate2(input: input)
        XCTAssertEqual(147, count)
    }
    
    func test_part2_v3() {
        let day = Day4_v2()
        let count = day.validate3(input: input, regexes: Day4_v2.regexes)
        XCTAssertEqual(147, count)
    }
    
    func test_part2_v4_part1() {
        let day = Day4_v2()
        let part1 = day.validate4(input: input, regex: Day4_v2.part1Regex)
        XCTAssertEqual(213, part1)
    }
    
    func test_part2_v4_part2() {
        let day = Day4_v2()
        let part2 = day.validate4(input: input, regex: Day4_v2.masterRegex)
        XCTAssertEqual(147, part2)
    }
    
    func test_failing_regex() {
        let day = Day4_v2()
        let input1 = "hcl:#bdb95d byr:1935 eyr:2023 ecl:blu iyr:2011 cid:90 hgt:64cm pid:155167914"
        let input2 = "byr:1972 hgt:169cm hcl:#888785 cid:75 iyr:2015 eyr:2021 ecl:oth pid:7889059161"
        let input3 = "byr:1962 hgt:167in ecl:brn hcl:#c0946f iyr:2014 pid:488520708 eyr:2027 cid:271"
        
        XCTAssertFalse(day.validatePassport2(passport: input1, regexes: Day4_v2.regexes))
        XCTAssertFalse(day.validatePassport2(passport: input2, regexes: Day4_v2.regexes))
        XCTAssertFalse(day.validatePassport2(passport: input3, regexes: Day4_v2.regexes))
        XCTAssertFalse(day.validatePassport(passport: input1))
        XCTAssertFalse(day.validatePassport(passport: input2))
        XCTAssertFalse(day.validatePassport(passport: input3))
    }
    
    func test_numberOfBlankLines() {
        let blankLines = input.reduce(0) { $0 + ($1.isEmpty ? 1 : 0) }
        XCTAssertEqual(278, blankLines)
    }
    
    func test_regex() {
        let day = Day4_v2()
        XCTAssertTrue(day.validatePassport2(passport: "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980 hcl:#623a2f", regexes: Day4_v2.regexes))
        XCTAssertTrue(day.validatePassport2(passport: "eyr:2029 ecl:blu cid:129 byr:1989 iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm", regexes: Day4_v2.regexes))
        XCTAssertTrue(day.validatePassport2(passport: "hcl:#888785 hgt:164cm byr:2001 iyr:2015 cid:88 pid:545766238 ecl:hzl eyr:2022", regexes: Day4_v2.regexes))
        XCTAssertTrue(day.validatePassport2(passport: "iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719", regexes: Day4_v2.regexes))
        XCTAssertFalse(day.validatePassport2(passport: "eyr:1972 cid:100 hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926", regexes: Day4_v2.regexes))
        XCTAssertFalse(day.validatePassport2(passport: "iyr:2019 hcl:#602927 eyr:1967 hgt:170cm ecl:grn pid:012533040 byr:1946", regexes: Day4_v2.regexes))
        XCTAssertFalse(day.validatePassport2(passport: "hcl:dab227 iyr:2012 ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277", regexes: Day4_v2.regexes))
        XCTAssertFalse(day.validatePassport2(passport: "hgt:59cm ecl:zzz eyr:2038 hcl:74454a iyr:2023 pid:3556412378 byr:2007", regexes: Day4_v2.regexes))
        XCTAssertFalse(day.validatePassport2(passport: "byr:2007", regexes: Day4_v2.regexes))
    }
    
    func test_part2_validPassports() {
        let input = """
        pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
        hcl:#623a2f

        eyr:2029 ecl:blu cid:129 byr:1989
        iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

        hcl:#888785
        hgt:164cm byr:2001 iyr:2015 cid:88
        pid:545766238 ecl:hzl
        eyr:2022

        iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
        """.lines
        let day = Day4()
        let count = day.validate(input: input, validate: Day4.validate)
        XCTAssertEqual(4, count)
    }
    
    func test_part2_invalidPassports() {
        let input = """
        eyr:1972 cid:100
        hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

        iyr:2019
        hcl:#602927 eyr:1967 hgt:170cm
        ecl:grn pid:012533040 byr:1946

        hcl:dab227 iyr:2012
        ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

        hgt:59cm ecl:zzz
        eyr:2038 hcl:74454a iyr:2023
        pid:3556412378 byr:2007
        """.lines
        let day = Day4()
        let count = day.validate(input: input, validate: Day4.validate)
        XCTAssertEqual(0, count)
    }
    
    func test_part2_validation_byr() {
        XCTAssertTrue(Day4.validate(field: "byr", value: "1920"))
        XCTAssertTrue(Day4.validate(field: "byr", value: "2002"))
        XCTAssertTrue(Day4.validate(field: "byr", value: "1999"))
        XCTAssertTrue(Day4.validate(field: "byr", value: "2000"))
        XCTAssertFalse(Day4.validate(field: "byr", value: "1919"))
        XCTAssertFalse(Day4.validate(field: "byr", value: "2003"))
    }
    
    func test_part2_validation_byr_regex() {
        let regex = Day4_v2.byrRegex
        
        let input = [
            "byr:1920":true,
            "byr:2002":true,
            "byr:1999":true,
            "byr:2000":true,
            "byr:1919":false,
            "byr:2003":false,
        ]
        
        for f in input {
            let range = NSRange(location: 0, length: f.key.utf16.count)
            XCTAssertEqual(f.value, regex.firstMatch(in: f.key, options: [], range: range) != nil, f.key)
        }
    }
    
    func test_part2_validation_hgt() {
        XCTAssertTrue(Day4.validate(field: "hgt", value: "59in"))
        XCTAssertTrue(Day4.validate(field: "hgt", value: "76in"))
        XCTAssertTrue(Day4.validate(field: "hgt", value: "62in"))
        XCTAssertTrue(Day4.validate(field: "hgt", value: "190cm"))
        XCTAssertTrue(Day4.validate(field: "hgt", value: "150cm"))
        XCTAssertTrue(Day4.validate(field: "hgt", value: "193cm"))
        XCTAssertFalse(Day4.validate(field: "hgt", value: "190in"))
        XCTAssertFalse(Day4.validate(field: "hgt", value: "58in"))
        XCTAssertFalse(Day4.validate(field: "hgt", value: "77in"))
        XCTAssertFalse(Day4.validate(field: "hgt", value: "149cm"))
        XCTAssertFalse(Day4.validate(field: "hgt", value: "194cm"))
        XCTAssertFalse(Day4.validate(field: "hgt", value: "64cm"))
        XCTAssertFalse(Day4.validate(field: "hgt", value: "167in"))
        XCTAssertFalse(Day4.validate(field: "hgt", value: "190"))
    }
    
    func test_part2_validation_hgt_regex() {
        let regex = Day4_v2.hgtRegex
        
        let input = ["hgt:59in": true,
                     "hgt:76in": true,
                     "hgt:62in": true,
                     "hgt:190cm": true,
                     "hgt:150cm": true,
                     "hgt:193cm": true,
                     "hgt:190in": false,
                     "hgt:58in": false,
                     "hgt:77in": false,
                     "hgt:149cm": false,
                     "hgt:194cm": false,
                     "hgt:186cm": true,
                     "hgt:190": false,
                     "hgt:64cm": false,
                     "hgt:167in": false,
        ]
        
        for f in input {
            let range = NSRange(location: 0, length: f.key.utf16.count)
            XCTAssertEqual(f.value, regex.firstMatch(in: f.key, options: [], range: range) != nil, f.key)
        }
    }
    
    func test_part2_validation_hcl() {
        XCTAssertTrue(Day4.validate(field: "hcl", value: "#fffffd"))
        XCTAssertTrue(Day4.validate(field: "hcl", value: "#18171d"))
        XCTAssertTrue(Day4.validate(field: "hcl", value: "#cfa07d"))
        XCTAssertTrue(Day4.validate(field: "hcl", value: "#888785"))
        XCTAssertFalse(Day4.validate(field: "hcl", value: "fffffd"))
        XCTAssertFalse(Day4.validate(field: "hcl", value: "#fffgfd"))
        XCTAssertTrue(Day4.validate(field: "hcl", value: "#bdb95d"))
        XCTAssertTrue(Day4.validate(field: "hcl", value: "#888785"))
        XCTAssertTrue(Day4.validate(field: "hcl", value: "#c0946f"))
    }
    
    func test_part2_validation_hcl_regex() {
        let regex = Day4_v2.hclRegex
        
        
        let input = [
            "hcl:#fffffd":true,
            "hcl:#18171d":true,
            "hcl:#cfa07d":true,
            "hcl:#888785":true,
            "hcl:fffffd":false,
            "hcl:#fffgfd":false,
            "hcl:#bdb95d":true,
            "hcl:#c0946f":true,
        ]
        
        for f in input {
            let range = NSRange(location: 0, length: f.key.utf16.count)
            XCTAssertEqual(f.value, regex.firstMatch(in: f.key, options: [], range: range) != nil, f.key)
        }
    }
    
    func test_part2_validation_pid() {
        XCTAssertTrue(Day4.validate(field: "pid", value: "626107466"))
        XCTAssertTrue(Day4.validate(field: "pid", value: "346059944"))
        XCTAssertTrue(Day4.validate(field: "pid", value: "432183209"))
        XCTAssertTrue(Day4.validate(field: "pid", value: "100000000"))
        XCTAssertTrue(Day4.validate(field: "pid", value: "000000000"))
        XCTAssertTrue(Day4.validate(field: "pid", value: "000000123"))
        XCTAssertFalse(Day4.validate(field: "pid", value: "#518780"))
        XCTAssertFalse(Day4.validate(field: "pid", value: "97123249"))
        XCTAssertFalse(Day4.validate(field: "pid", value: "4321832094"))
        XCTAssertFalse(Day4.validate(field: "pid", value: "7889059161"))
    }
    
    func test_part2_validation_pid_regex() {
        let regex = Day4_v2.pidRegex
        
        
        let input = [
            "pid:626107466":true,
            "pid:346059944":true,
            "pid:432183209":true,
            "pid:100000000":true,
            "pid:000000000":true,
            "pid:000000123":true,
            "pid:518780":false,
            "pid:97123249":false,
            "pid:4321832094":false,
            "pid:7889059161":false,
        ]
        
        for f in input {
            let range = NSRange(location: 0, length: f.key.utf16.count)
            XCTAssertEqual(f.value, regex.firstMatch(in: f.key, options: [], range: range) != nil, f.key)
        }
    }
}
