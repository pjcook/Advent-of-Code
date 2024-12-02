import XCTest
import InputReader
import Year2024

class Day19Tests: XCTestCase {
    
    let input = Input("Day19.input", Bundle.module).lines
    let day = Day19()

    func test_part1() {
//        measure {
        XCTAssertEqual(472630, day.part1(input))
//        }
    }
    
    func test_part1_example1() {
        let input = """
px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013}
""".lines
        XCTAssertEqual(19114, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(116738260946855, day.part2(input))
//        }
    }
    
    func test_part2_example1() {
        let input = """
px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013}
""".lines
        XCTAssertEqual(167_409_079_868_000, day.part2(input))
//        103_964_800_000_000
//        65_635_200_000_000
    }
}

/*
 in{s<1351:px,qqz}
 px{a<2006:qkq,m>2090:A,rfg}
 qkq{x<1416:A,crn}
 rfg{s<537:gd,x>2440:R,A}
 qqz{s>2770:qs,m<1801:hdj,R}
 pv{a>1716:R,A}
 lnx{m>1548:A,A}
 qs{s>3448:A,lnx}
 crn{x>2662:A,R}
 gd{a>3333:R,R}
 hdj{m>838:A,pv}
 
 
 s<1351 && a<2006 && x<1416 [A] // [in, px, qkq]                            1350 * 2005 * 1415 * 4000 = 15,320,205,000,000
 s<1351 && a<2006 && x>2662 [A] // [in, px, qkq, crn]                       1350 * 2005 * (4000-2662) * 4000 = 14,486,526,000,000
 s<1351 && a>2005 && m>2090 [A] // [in, px]                                 1350 * (4000-2005) * (4000-2090) * 4000 = 20,576,430,000,000
 s<1351 && a>2005 && m<2091 && s>536 && x<2441 [A]     // [in, px, rfg]     (1350-536) * (4000-2005) * 2090 * 2440 = 8,281,393,428,000
 
 s>1350 && s>2770 [A]              // [in, qqz, qs]                         (4000-2770) * 4000 * 4000 * 4000 = 78,720,000,000,000
 s>1350 && s<2771 && m<1801 && m>838 [A]              // [in, qqz, hdj]     (2770-1350) * (1800 - 838) * 4000 * 4000 = 21,856,640,000,000
 s>1350 && s<2771 && m<839 && a<1717 [A]             // [in, qqz, hdj, pv]  (2770-1350) * 838 * 1716 * 4000 = 8,167,885,440,000
 
 15,320,205,000,000+14,486,526,000,000+20,576,430,000,000+8,281,393,428,000+78,720,000,000,000+21,856,640,000,000+8,167,885,440,000
 = 167,409,079,868,000
 = 167_409_079_868_000
 */
