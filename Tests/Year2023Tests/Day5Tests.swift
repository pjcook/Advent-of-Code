import XCTest
import InputReader
import StandardLibraries
import Year2023

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
        XCTAssertEqual(6_082_852, day.part2(input))
//        }
    }
    
//    func test_part2_bruteForce() {
//        // 1074 seconds
//        // 992
//        // 216
////        measure {
//        XCTAssertEqual(6_082_852, day.part2brute(input))
////        }
//    }
    
//    func test_parse_speed() {
//        measure {
//            let mapRanges = day.parse(testInput)
//        }
//    }
    
//    func test_part2_Chris() {
//        let input = Input("Day5_Chris.input", Bundle.module).lines
//        let mapRanges = day.parse(input)
//        let result = mapRanges.lowestLocation(seeds: (1599552892...1499552892+200291842))
//        XCTAssertEqual(37_806_486, result)
//    }
    
    func test_rangeType_iterationOrder() {
        XCTAssertEqual(Day5.RangeType.allCases[0], .seedToSoil)
        XCTAssertEqual(Day5.RangeType.allCases[1], .soilToFertilizer)
        XCTAssertEqual(Day5.RangeType.allCases[2], .fertilizerToWater)
        XCTAssertEqual(Day5.RangeType.allCases[3], .waterToLight)
        XCTAssertEqual(Day5.RangeType.allCases[4], .lightToTemperature)
        XCTAssertEqual(Day5.RangeType.allCases[5], .temperatureToHumidity)
        XCTAssertEqual(Day5.RangeType.allCases[6], .humidityToLocation)
    }
    
    func test_part1_example() {
        XCTAssertEqual(35, day.part1(testInput))
    }
    
    func test_part2_example() {
        let mapRanges = day.parse(testInput)
        var lowest = Int.max
        for seedRange in mapRanges.seedRanges {
            let result = mapRanges.lowestLocation(seeds: (seedRange.0...seedRange.0+seedRange.1))
            if result < lowest {
                lowest = result
            }
        }
        XCTAssertEqual(46, lowest)
    }
    
    func test_stuff4() {
        /*
        let mapRanges = day.parse(testInput)
        
        var seedValuesToTry = Set<Int>()
        for (startSeedNumber, rangeLength) in mapRanges.seedRanges {
            let validSeedToSoilRanges = mapRanges.ranges[.seedToSoil]!
                .filter({
                    ($0.sourceRangeStart..<$0.sourceRangeStart+$0.rangeLength).overlaps(startSeedNumber..<startSeedNumber+rangeLength)
                })
            
            for item in validSeedToSoilRanges {
                seedValuesToTry.insert(max(item.sourceRangeStart, startSeedNumber))
            }
        }
        print(seedValuesToTry)
        XCTAssertEqual(mapRanges.lowestLocation(seeds: Array(seedValuesToTry)), 46)
         */
    }

    func test_part2_example2() {
        let mapRanges = day.parse(testInput)
        XCTAssertEqual(82, mapRanges.lowestLocation(seeds: [79]))
        XCTAssertEqual(83, mapRanges.lowestLocation(seeds: [80]))
        XCTAssertEqual(84, mapRanges.lowestLocation(seeds: [81]))
        XCTAssertEqual(46, mapRanges.lowestLocation(seeds: [82]))
        XCTAssertEqual(47, mapRanges.lowestLocation(seeds: [83]))
        XCTAssertEqual(55, mapRanges.lowestLocation(seeds: [91]))
        
        XCTAssertEqual(86, mapRanges.lowestLocation(seeds: [55]))
        XCTAssertEqual(95, mapRanges.lowestLocation(seeds: [60]))
        XCTAssertEqual(59, mapRanges.lowestLocation(seeds: [65]))
        
        XCTAssertEqual(46, mapRanges.lowestLocation(seeds: [79,80,81,82,83,84,85,86,87,88,89,90,91]))
        XCTAssertEqual(56, mapRanges.lowestLocation(seeds: [55,56,57,58,59,60,61,62,63,64,64,65]))
    }
    
    func test_stuff3() {
//        var value = 6082852
        let value = 412_141_395
        // 377_104_678
        // 544_894_922
        // 558_493_009
        
        let mapRanges = day.parse(input)
        for item in mapRanges.maps.first! {
            guard item.sourceRangeStart <= value && item.sourceRangeStart + item.rangeLength >= value else { continue }
            print(item)
        }
    }
    
    func test_stuff2_chris() {
        // Answer: 37_806_486
        /*
        let input = Input("Day5_Chris.input", Bundle.module).lines
        let mapRanges = day.parse(input)
//        
//        print(mapRanges.lowestLocation(seeds: (1_499_552_892...1_499_552_892+200_291_842)))
        
         /*
        let result = day.divideAndConquer(start: 1_499_552_892, length: 200_291_842, mapRanges: mapRanges)
        print(result)
        
        print(
            mapRanges.seedRanges.filter({
                ($0.0..<$0.0+$0.1).contains(568494408)
            })
        )
        print()
        
        print(
            mapRanges.ranges[.seedToSoil]!
                .filter({
                    ($0.sourceRangeStart...$0.sourceRangeStart+$0.rangeLength).overlaps(1_499_552_892...1_499_552_892+200_291_842)
                })
        )
        // 773_420_016
        // 568_494_408
        // 586_838_162
        print(mapRanges.locations(seeds: [1_599_552_892]))
         */
         */
    }
    
    func test_stuff2() {
        let mapRanges = day.parse(input)
        //let result = day.divideAndConquer(start: 485_317_202, length: 73_175_807, mapRanges: mapRanges)
        
        print(
            mapRanges.maps.first!
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
            let validSeedToSoilRanges = mapRanges.maps.first!
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
