import Foundation
import StandardLibraries

public struct Day5 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let mapRanges = parse(input)
        return mapRanges.lowestLocation(seeds: mapRanges.seeds)
    }
    
    public func part2(_ input: [String]) -> Int {
        let mapRanges = parse(input)

        var smallestDistance = Int.max
        for (startSeedNumber, rangeLength) in mapRanges.seedRanges {
            let validSeedToSoilRanges = mapRanges.ranges[.seedToSoil]!
                .filter({
                    ($0.sourceRangeStart...$0.sourceRangeStart+$0.rangeLength).overlaps(startSeedNumber...startSeedNumber+rangeLength)
                })
            
            let seedValues = validSeedToSoilRanges.map { max($0.sourceRangeStart, startSeedNumber) }
            let result = mapRanges.lowestLocation(seeds: seedValues)
            smallestDistance = min(result, smallestDistance)
        }
        
        return smallestDistance
    }

    func divideAndConquer(start: Int, length: Int, mapRanges: MapRanges) -> Int {
        var startSeedNumber = start
        var rangeLength = length
        
        while rangeLength > 5000 {
            let halfRange = rangeLength / 2
            let quarterRange = halfRange / 2
            let lower = mapRanges.lowestLocation(seeds: [startSeedNumber + quarterRange])
            let upper = mapRanges.lowestLocation(seeds: [startSeedNumber + halfRange + quarterRange])
            
            rangeLength = halfRange
            if upper < lower {
                startSeedNumber = startSeedNumber + halfRange
            }
        }
        
        let result = mapRanges.lowestLocation(seeds: (startSeedNumber...startSeedNumber+rangeLength))
        return result
    }
    
    public func test(_ input: [String], seeds: [Int]) -> Int {
        let mapRanges = parse(input)
        return mapRanges.lowestLocation(seeds: seeds)
    }
    
    struct MapRange {
        let destinationRangeStart: Int
        let sourceRangeStart: Int
        let rangeLength: Int
        
        func destination(input: Int) -> Int? {
            guard (sourceRangeStart..<sourceRangeStart + rangeLength).contains(input) else { return nil }
            return destinationRangeStart + (input - sourceRangeStart)
        }
    }
    
    struct MapRanges {
        let seeds: [Int]
        let ranges: [RangeType: [MapRange]]
        
        var seedRanges: [(Int,Int)] {
            var index = 0
            var results = [(Int,Int)]()
            while index < seeds.count {
                let startSeedNumber = seeds[index]
                let range = seeds[index+1]
                index += 2
                results.append((startSeedNumber, range))
            }
            return results
        }
        
        func destination(for rangeType: RangeType, input: Int) -> Int {
            for range in self.ranges[rangeType]! {
                if let result = range.destination(input: input) {
                    return result
                }
            }
            return input
        }
        
        func locations(seeds: [Int]) -> [Int] {
            var results = [Int]()

            for seed in seeds {
                var result = seed
                for rangeType in RangeType.allCases {
                    result = destination(for: rangeType, input: result)
                }
                results.append(result)
            }
            
            return results
        }
        
        func lowestLocation(seeds: [Int]) -> Int {
            var lowest = Int.max

            for seed in seeds {
                var result = seed
                for rangeType in RangeType.allCases {
                    result = destination(for: rangeType, input: result)
                }
                
                if result < lowest {
                    lowest = result
                }
            }
            
            return lowest
        }
        
        func lowestLocation(seeds: ClosedRange<Int>) -> Int {
            var lowest = Int.max

            for seed in seeds {
                var result = seed
                for rangeType in RangeType.allCases {
                    result = destination(for: rangeType, input: result)
                }
                
                if result < lowest {
                    lowest = result
                }
            }
            
            return lowest
        }
    }
    
    enum RangeType: String, CaseIterable {
        case seedToSoil = "seed-to-soil"
        case soilToFertilizer = "soil-to-fertilizer"
        case fertilizerToWater = "fertilizer-to-water"
        case waterToLight = "water-to-light"
        case lightToTemperature = "light-to-temperature"
        case temperatureToHumidity = "temperature-to-humidity"
        case humidityToLocation = "humidity-to-location"
    }
}

extension Day5 {
    func parse(_ input: [String]) -> MapRanges {
        var results = [RangeType: [MapRange]]()
        var rangeName = ""
        var ranges = [MapRange]()
        var seeds = [Int]()
        
        for line in input {
            guard !line.isEmpty else {
                if !rangeName.isEmpty {
                    results[RangeType(rawValue: rangeName)!] = ranges
                }
                ranges = []
                continue
            }
            
            let components = line.components(separatedBy: " ")
            if let destinationRangeStart = Int(components[0]) {
                let sourceRangeStart = Int(components[1])!
                let rangeLength = Int(components[2])!
                let range = MapRange(destinationRangeStart: destinationRangeStart, sourceRangeStart: sourceRangeStart, rangeLength: rangeLength)
                ranges.append(range)
            } else if components[0] == "seeds:" {
                seeds = components[1...].map({ Int($0)! })
            } else {
                rangeName = components[0]
            }
        }
        
        if !rangeName.isEmpty {
            results[RangeType(rawValue: rangeName)!] = ranges
        }
        
        return MapRanges(seeds: seeds, ranges: results)
    }
}
