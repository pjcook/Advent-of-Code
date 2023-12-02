import Foundation
import StandardLibraries

public struct Day2 {
    public init() {}
    
    public struct CubeGameLimits {
        public let red: Int
        public let green: Int
        public let blue: Int
        
        public init(red: Int, green: Int, blue: Int) {
            self.red = red
            self.green = green
            self.blue = blue
        }
    }
    
    public func part1(_ input: [String], limits: CubeGameLimits) -> Int {
        let results = parse(input)
        var sum = 0
        
        for result in results {
            guard
                limits.red >= result.maxRed,
                limits.green >= result.maxGreen,
                limits.blue >= result.maxBlue
            else { continue }
            sum += result.id
        }
        
        return sum
    }
    
    public func part2(_ input: [String]) -> Int {
        let results = parse(input)
        var sum = 0
        
        for result in results {
            let power = result.maxRed * result.maxGreen * result.maxBlue
            sum += power
        }
        
        return sum
    }
}

extension Day2 {
    struct CubeBagGameResult {
        let id: Int
        let entries: [CubeBagSelection]
        
        var maxRed: Int {
            findMax(cubeType: .red)
        }
        
        var maxGreen: Int {
            findMax(cubeType: .green)
        }
        
        var maxBlue: Int {
            findMax(cubeType: .blue)
        }
        
        private func findMax(cubeType: CubeType) -> Int {
            entries
                .filter({ $0.cubeType == cubeType })
                .sorted(by: { $0.numberOfCubes > $1.numberOfCubes })
                .first?
                .numberOfCubes ?? 0
        }
    }
    
    struct CubeBagSelection {
        let cubeType: CubeType
        let numberOfCubes: Int
        
        init(_ input: String) {
            let components = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
            self.numberOfCubes = Int(components[0])!
            self.cubeType = CubeType(rawValue: components[1])!
        }
    }
    
    enum CubeType: String {
        case red, green, blue
    }
    
    func parse(_ input: [String]) -> [CubeBagGameResult] {
        var results = [CubeBagGameResult]()
        
        for line in input {
            let components = line.components(separatedBy: CharacterSet(arrayLiteral: ":", ",", ";"))
            let selections = components[1...].map(CubeBagSelection.init)
            let gameComponents = components[0].components(separatedBy: " ")
            let gameResult = CubeBagGameResult(id: Int(gameComponents[1])!, entries: selections)
            results.append(gameResult)
        }
        
        return results
    }
}
