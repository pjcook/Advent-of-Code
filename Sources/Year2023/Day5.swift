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
            let validSeedToSoilRanges = mapRanges.maps.first!
                .filter({
                    ($0.sourceRangeStart..<$0.sourceRangeStart+$0.rangeLength).overlaps(startSeedNumber..<startSeedNumber+rangeLength)
                })
            
            let seedValues = validSeedToSoilRanges.map { max($0.sourceRangeStart, startSeedNumber) }
            let result = mapRanges.lowestLocation(seeds: seedValues)
            smallestDistance = min(result, smallestDistance)
        }
        
        return smallestDistance
    }
    
    public func part2brute(_ input: [String]) -> Int {
        let mapRanges = parse(input)
        var smallestDistance = Int.max
        
        for (startSeedNumber, rangeLength) in mapRanges.seedRanges {
            let result = mapRanges.lowestLocation(seeds: (startSeedNumber...startSeedNumber+(rangeLength-1)))
            smallestDistance = min(result, smallestDistance)
        }
        
        return smallestDistance
    }
    
    public struct MapRange {
        public let destinationRangeStart: Int
        public let sourceRangeStart: Int
        public let rangeLength: Int
        
        public func destination(input: Int) -> Int? {
            guard sourceRangeStart <= input, input < (sourceRangeStart + rangeLength) else { return nil }
            return destinationRangeStart + (input - sourceRangeStart)
        }
    }
    
    public struct MapRanges {
        public let seeds: [Int]
        public let maps: [[MapRange]]
        
        public var seedRanges: [(Int,Int)] {
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
        
        public func destination(for map: [MapRange], input: Int) -> Int {
            map
                .first(where: { $0.destination(input: input) != nil })?
                .destination(input: input) ?? input
        }
        
        func destination(seed: Int) -> Int {
            var result = seed
            for map in maps {
                result = destination(for: map, input: result)
            }
            return result
        }
        
        public func locations(seeds: [Int]) -> [Int] {
            var results = [Int]()

            for seed in seeds {
                results.append(destination(seed: seed))
            }
            
            return results
        }
        
        public func lowestLocation(seeds: [Int]) -> Int {
            var lowest = Int.max

            for seed in seeds {
                lowest = min(destination(seed: seed), lowest)
            }
            
            return lowest
        }
    }
    
    public enum RangeType: String, CaseIterable {
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
    public func parse(_ input: [String]) -> MapRanges {
        var results = [RangeType: [MapRange]]()
        var rangeName = ""
        var ranges = [MapRange]()
        var seeds = [Int]()
        
        for line in input {
            guard !line.isEmpty else {
                if !rangeName.isEmpty {
                    results[RangeType(rawValue: rangeName)!] = ranges.sorted(by: { $0.sourceRangeStart < $1.sourceRangeStart })
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
        
        var maps = [[MapRange]]()
        for rangeType in RangeType.allCases {
            maps.append(results[rangeType]!)
        }
        return MapRanges(seeds: seeds, maps: maps)
    }
}

// unused code
extension Day5 {
    public func divideAndConquer(start: Int, length: Int, mapRanges: MapRanges) -> Int {
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
}

extension Day5.MapRanges {
    public func lowestLocation(seeds: ClosedRange<Int>) -> Int {
        var lowest = Int.max

        for seed in seeds {
            lowest = min(destination(seed: seed), lowest)
        }
        
        return lowest
    }
}
