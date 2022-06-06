import Foundation
import StandardLibraries

public class Day10 {
    public init() {}
    private var minDY = Int.max

    public let regex = try! RegularExpression(pattern: #"position=<\s?([-\d]*),\s{0,2}([-\d]*)>\svelocity=<\s?([-\d]*),\s{0,2}([-\d]*)>"#)
    
    public func part1(_ input: [String], lineHeight: Int) -> Int {
        let data = parse(input)
        var i = 0
        while true {
            var minX = 0
            var minY = 0
            var maxX = 0
            var maxY = 0
            var points = [Point]()
            for item in data {
                let point = item.position + (item.velocity * i)
                if point.x < minX {
                    minX = point.x
                } else if point.x > maxX {
                    maxX = point.x
                }
                if point.y < minY {
                    minY = point.y
                } else if point.y > maxY {
                    maxY = point.y
                }
                points.append(point)
            }
            
            if maxY-minY > 7 {
                if maxY-minY < minDY {
                    minDY = maxY-minY
                    print("DY", i, maxY-minY, minDY)
                    if minDY < 500, draw(Set(points),minX: minX, maxX: maxX, minY: minY, maxY: maxY, lineHeight: lineHeight) {
                        break
                    }
                }
            } else {
                if draw(Set(points),minX: minX, maxX: maxX, minY: minY, maxY: maxY, lineHeight: lineHeight) {
                    break
                }
            }
            
            i += 1
            if i % 10000 == 0 {
                print(i, minDY)
            }
        }
        
        return 0
    }
    
    public func parse(_ input: [String]) -> [DataItem] {
        var data = [DataItem]()
        
        for line in input {
            let match = try! regex.match(line)
            if match.captureGroups.count == 4 {
                let p1 = try! match.integer(at: 0)
                let p2 = try! match.integer(at: 1)
                let p3 = try! match.integer(at: 2)
                let p4 = try! match.integer(at: 3)
                data.append(DataItem(position: Point(x: p1, y: p2), velocity: Point(x: p3, y: p4)))
            }
        }
        
        return data
    }
    
    public func draw(_ data: Set<Point>, minX: Int, maxX: Int, minY: Int, maxY: Int, lineHeight: Int) -> Bool {
        print(minX, maxX, minY, maxY, maxX - minX, maxY - minY, lineHeight)
        
        var output = ""
        var lineCount = 0
        for y in (minY...maxY) {
            var line = ""
            for x in (minX...maxX) {
                let point = Point(x: x, y: y)
                if data.contains(point) {
                    line += "#"
                } else {
                    line += " "
                }
            }
            if !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                output += line + "\n"
                lineCount += 1
            }
        }
        
        if lineCount == lineHeight {
            print(lineCount)
            print(output)
        }
        
        return lineCount == lineHeight
    }
    
    public struct DataItem {
        public let position: Point
        public let velocity: Point
        
        public init(position: Point, velocity: Point) {
            self.position = position
            self.velocity = velocity
        }
    }
}
