import XCTest
import InputReader
import StandardLibraries
@testable import Year2023

class Day5Tests: XCTestCase {
    
    let input = Input("Day5.input", Bundle.module).lines
    let day = Day5()

    func test_part1() {
//        measure {
        XCTAssertEqual(3374647, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(6082852, day.part2(input))
//        }
    }
    
    func test_rangeType_iterationOrder() {
        XCTAssertEqual(Day5.RangeType.allCases[0], .seedToSoil)
        XCTAssertEqual(Day5.RangeType.allCases[1], .soilToFertilizer)
        XCTAssertEqual(Day5.RangeType.allCases[2], .fertilizerToWater)
        XCTAssertEqual(Day5.RangeType.allCases[3], .waterToLight)
        XCTAssertEqual(Day5.RangeType.allCases[4], .lightToTemperature)
        XCTAssertEqual(Day5.RangeType.allCases[5], .temperatureToHumidity)
        XCTAssertEqual(Day5.RangeType.allCases[6], .humidityToLocation)
    }
    
    func test_part2_example() {
        XCTAssertEqual(46, day.part2(testInput))
    }
    
    func test_part2_example2() {
        XCTAssertEqual(82, day.test(testInput, seeds: [79]))
        XCTAssertEqual(83, day.test(testInput, seeds: [80]))
        XCTAssertEqual(84, day.test(testInput, seeds: [81]))
        XCTAssertEqual(46, day.test(testInput, seeds: [82]))
        XCTAssertEqual(47, day.test(testInput, seeds: [83]))
        
        XCTAssertEqual(46, day.test(testInput, seeds: [79,80,81,82,83,84,85,86,87,88,89,90,91,92]))
        XCTAssertEqual(56, day.test(testInput, seeds: [55,56,57,58,59,60,61,62,63,64,64,65,66]))
    }
    
    func test_stuff2() {
        let mapRanges = day.parse(input)
        //let result = day.divideAndConquer(start: 485_317_202, length: 73_175_807, mapRanges: mapRanges)
        
        print(
            mapRanges.ranges[.seedToSoil]!
                .filter({
                    ($0.sourceRangeStart...$0.sourceRangeStart+$0.rangeLength).overlaps(485_317_202...485_317_202+73_175_807)
                })
        )
        
        // 485_317_202 +  73_175_807 = 558_493_009
        // 377_104_678 + 167_790_244 = 544_894_922
        // 544_894_922 +  55_279_380 = 600_174_302
        
        // 10533961
//        print(result)

        // 3493343155
        // 3493443255
        // 3503443255
        // 2677653796
        // 2677353796
        
        // 10533961
        // 6082852  > 544_894_922
        // 11082852 > 549_894_922
        // 16082852 > 554_894_922
        print(mapRanges.locations(seeds: [544_894_923]))
    }
    
    func test_stuff() {
        var smallestDistance = Int.max
        let mapRanges = day.parse(input)
        for (startSeedNumber, rangeLength) in mapRanges.seedRanges {
            let validSeedToSoilRanges = mapRanges.ranges[.seedToSoil]!
                .filter({
                    ($0.sourceRangeStart...$0.sourceRangeStart+$0.rangeLength).overlaps(startSeedNumber...startSeedNumber+rangeLength)
                })
            
            let seedValues = validSeedToSoilRanges.map { $0.sourceRangeStart }
            let result = mapRanges.lowestLocation(seeds: seedValues)
            smallestDistance = min(result, smallestDistance)
        }
        XCTAssertEqual(6082852, smallestDistance)
    }
    
    let testInput = """
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
""".lines
}
