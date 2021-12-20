import Foundation
import StandardLibraries

public struct Day20 {
    public init() {}
    
    public typealias Algorithm = [Int]
    
    public let light = "#"
    public let dark = "."
    
    public struct Photo {
        public let pixels: DictGrid<Int>
        public let outOfRangePixelsLit: Bool
        public init(pixels: DictGrid<Int>, outOfRangePixelsLit: Bool = false) {
            self.pixels = pixels
            self.outOfRangePixelsLit = outOfRangePixelsLit
        }
        
        public func enhance(_ algorithm: Algorithm) -> Photo {
            var items = [Point:Int]()
            let (minCoord, maxCoord) = pixels.elements.keys.minMax()
            
            for y in (minCoord.y-1...maxCoord.y+1) {
                for x in (minCoord.x-1...maxCoord.x+1) {
                    let point = Point(x,y)
                    var bits = ""
                    bits.append(String(isLit(minCoord: minCoord, maxCoord: maxCoord, point: point + Position.tl.point)))
                    bits.append(String(isLit(minCoord: minCoord, maxCoord: maxCoord, point: point + Position.t.point)))
                    bits.append(String(isLit(minCoord: minCoord, maxCoord: maxCoord, point: point + Position.tr.point)))
                    bits.append(String(isLit(minCoord: minCoord, maxCoord: maxCoord, point: point + Position.l.point)))
                    bits.append(String(isLit(minCoord: minCoord, maxCoord: maxCoord, point: point)))
                    bits.append(String(isLit(minCoord: minCoord, maxCoord: maxCoord, point: point + Position.r.point)))
                    bits.append(String(isLit(minCoord: minCoord, maxCoord: maxCoord, point: point + Position.bl.point)))
                    bits.append(String(isLit(minCoord: minCoord, maxCoord: maxCoord, point: point + Position.b.point)))
                    bits.append(String(isLit(minCoord: minCoord, maxCoord: maxCoord, point: point + Position.br.point)))

                    let index = Int(bits, radix: 2)!
                    if algorithm[index] == 1 {
                        items[point] = algorithm[index]
                    }
                }
            }
            
            return Photo(pixels: DictGrid(items, rows: pixels.rows, columns: pixels.columns, defaultValue: pixels.defaultValue), outOfRangePixelsLit: outOfRangePixelsLit ? algorithm[511] == 1 : algorithm[0] == 1)
        }
        
        public func isLit(minCoord: Point, maxCoord: Point, point: Point) -> Int {
            if point.x < minCoord.x || point.y < minCoord.y || point.x > maxCoord.x || point.y > maxCoord.y {
                return outOfRangePixelsLit ? 1 : 0
            } else {
                return pixels[point]
            }
        }
    }
    
    public func part1(_ input: [String]) -> Int {
        let (algorithm, photo) = parse(input)
        
        let enhancedPhoto1 = photo.enhance(algorithm)
        let enhancedPhoto2 = enhancedPhoto1.enhance(algorithm)

        return enhancedPhoto2.pixels.elements.count
    }
    
    public func part2(_ input: [String]) -> Int {
        let (algorithm, photo) = parse(input)
        var enhancedPhoto = photo
        for _ in (0..<50) {
            enhancedPhoto = enhancedPhoto.enhance(algorithm)
        }
        return enhancedPhoto.pixels.elements.count
    }
    
    public func parse(_ input: [String]) -> (Algorithm, Photo) {
        let algorithm = input[0].replacingOccurrences(of: "#", with: "1").replacingOccurrences(of: ".", with: "0").map({ Int(String($0))! })
        
        var items = [Point:Int]()
        var y = 0
        for i in (2..<input.count) {
            let line = input[i]
            for x in (0..<line.count) {
                if line[x] == "#" {
                    items[Point(x,y)] = 1
                }
            }
            
            y += 1
        }
        
        return (algorithm, Photo(pixels: DictGrid(items, rows: y, columns: input[2].count, defaultValue: 0)))
    }
}

public struct DictGrid<T: Equatable> {
    public var elements: [Point:T]
    public private(set) var rows: Int
    public private(set) var columns: Int
    public let defaultValue: T
    
    public init(_ elements: [Point:T], rows: Int, columns: Int, defaultValue: T) {
        self.defaultValue = defaultValue
        self.rows = rows
        self.columns = columns
        self.elements = elements
    }
    
    public func padded(by: Int) -> DictGrid<T> {
        let adder = Point(by, by)
        var newElements = [Point:T]()
        elements.forEach {
            newElements[$0.key + adder] = $0.value
        }
        return DictGrid(newElements, rows: rows + 2 * by, columns: columns + 2 * by, defaultValue: defaultValue)
    }
    
    public subscript(x: Int, y: Int) -> T {
        get {
            return elements[Point(x, y), default: defaultValue]
        }
        set {
            elements[Point(x, y)] = newValue
        }
    }
    
    public subscript(point: Point) -> T {
        get {
            return elements[point, default: defaultValue]
        }
        set {
            elements[point] = newValue
        }
    }
    
    public func draw() {
        for y in (0..<rows) {
            var line = ""
            for x in (0..<columns) {
                line.append(self[Point(x: x, y: y)] != defaultValue ? "⚪️" : "⚫️")
            }
            print(line)
        }
        print()
    }
    
    public func draw2() {
        let (minCoord, maxCoord) = elements.keys.minMax()
        
        for y in (minCoord.y...maxCoord.y) {
            var line = ""
            for x in (minCoord.x...maxCoord.x) {
                line.append(self[Point(x: x, y: y)] != defaultValue ? "⚪️" : "⚫️")
            }
            print(line)
        }
        print()
    }
}
