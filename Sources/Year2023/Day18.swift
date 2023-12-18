import Foundation
import StandardLibraries

public struct Day18 {
    public init() {}
        
    public func part1(_ input: [String]) -> Int {
        var grid = parse(input)
        var start = Point.zero
        for x in (0..<grid.columns) {
            let point = Point(x,0)
            if grid[point] == "#" {
                start = point + Point(1,1)
                break
            }
        }
        
        var toProcess = Set<Point>([start])
        while let point = toProcess.popFirst() {
            grid[point] = "#"
            for neighbor in point.cardinalNeighbors(max: grid.bottomRight) {
                if grid[neighbor] == "." {
                    toProcess.insert(neighbor)
                }
            }
        }
        
        grid.draw()
        print()
        return grid.items.reduce(0) {
            $0 + ($1 == "#" ? 1 : 0)
        }
    }
    
    public func part1Shoelace(_ input: [String]) -> Int {
        var current = Point.zero
        var count = 0
        var points = [current]
        for line in input {
            let components = line.components(separatedBy: " ")
            let value = Int(String(components[1]))!
            count += value
            switch components[0] {
                case "L":
                    current = current + Point(-value, 0)
                case "R":
                    current = current + Point(value, 0)
                case "U":
                    current = current + Point(0, -value)
                case "D":
                    current = current + Point(0, value)
                default:
                    break
            }
            points.append(current)
        }
        
        var shoelace = 0
        for i in (0..<points.count) {
            var prevIndex = i - 1
            if prevIndex < 0 {
                prevIndex = points.count - 1
            }
            var nextIndex = i + 1
            if nextIndex >= points.count {
                nextIndex = 0
            }
            
            shoelace += points[i].y * (points[prevIndex].x - points[nextIndex].x)
        }
        
        shoelace = abs(shoelace) / 2
        let internalArea = shoelace - count / 2 + 1
        print(shoelace, internalArea)
        return internalArea + count
    }
    
    // shoelace formula
    public func part2(_ input: [String]) -> Int {
        var current = Point.zero
        var count = 0
        var points = [current]
        for line in input {
            let components = line.components(separatedBy: " ")
            var element = components[2]
                .replacingOccurrences(of: "(", with: "")
                .replacingOccurrences(of: ")", with: "")
                .replacingOccurrences(of: "#", with: "")
            let direction = Int(String(element.removeLast()))!
            let value = Int(element, radix: 16)!
            count += value
            switch direction {
                case 2: // "L":
                    current = current + Point(-value, 0)
                case 0: // "R":
                    current = current + Point(value, 0)
                case 3: // "U":
                    current = current + Point(0, -value)
                case 1: // "D":
                    current = current + Point(0, value)
                default:
                    break
            }
            points.append(current)
        }
        
        var shoelace = 0
        for i in (0..<points.count) {
            var prevIndex = i - 1
            if prevIndex < 0 {
                prevIndex = points.count - 1
            }
            var nextIndex = i + 1
            if nextIndex >= points.count {
                nextIndex = 0
            }
            
            shoelace += points[i].y * (points[prevIndex].x - points[nextIndex].x)
        }
        
        shoelace = abs(shoelace) / 2
        let internalArea = shoelace - count / 2 + 1
        print(shoelace, internalArea)
        return internalArea + count
    }
}

extension Day18 {
    func parse(_ input: [String]) -> Grid<String> {
        var minValue = Point.zero
        var maxValue = Point.zero
        var current = Point.zero
        for line in input {
            let components = line.components(separatedBy: " ")
            let value = Int(String(components[1]))!
            switch components[0] {
                case "L": 
                    current = current + Point(-value, 0)
                    minValue = Point(min(minValue.x, current.x), minValue.y)
                case "R":
                    current = current + Point(value, 0)
                    maxValue = Point(max(maxValue.x, current.x), maxValue.y)
                case "U":
                    current = current + Point(0, -value)
                    minValue = Point(minValue.x, min(minValue.y, current.y))
                case "D":
                    current = current + Point(0, value)
                    maxValue = Point(maxValue.x, max(maxValue.y, current.y))
                default:
                    break
            }
        }
        
        let cols = maxValue.x - minValue.x + 1
        let rows = maxValue.y - minValue.y + 1
        let items = Array(repeating: ".", count: rows * cols)
        var grid = Grid<String>(columns: cols, items: items)

        current = Point(abs(minValue.x), abs(minValue.y))
        for line in input {
            let components = line.components(separatedBy: " ")
            let value = Int(String(components[1]))!
            switch components[0] {
                case "L":
                    for _ in (0..<value) {
                        current = current + Direction.left.point
                        grid[current] = "#"
                    }

                case "R":
                    for _ in (0..<value) {
                        current = current + Direction.right.point
                        grid[current] = "#"
                    }

                case "U":
                    for _ in (0..<value) {
                        current = current + Direction.up.point
                        grid[current] = "#"
                    }

                case "D":
                    for _ in (0..<value) {
                        current = current + Direction.down.point
                        grid[current] = "#"
                    }

                default:
                    break
            }
        }
        
//        grid.draw()
//        print()
        
        return grid
    }
    
    func calculateRanges(_ input: [String]) -> ([(Point,Point)], Point) {
        // calculate ranges
        var ranges = [(Point,Point)]()
        var current = Point.zero
        for line in input {
            let components = line.components(separatedBy: " ")
            let value = Int(String(components[1]))!
            switch components[0] {
                case "L":
                    ranges.append((current + Point(-value, 0), current))
                    current = current + Point(-value, 0)

                case "R":
                    ranges.append((current, current + Point(value, 0)))
                    current = current + Point(value, 0)

                case "U":
                    ranges.append((current + Point(0, -value), current))
                    current = current + Point(0, -value)
                case "D":
                    ranges.append((current, current + Point(0, value)))
                    current = current + Point(0, value)
                default:
                    break
            }
        }
        
        // adjust coordinates to all be positive with top left (0,0)
        var minPoint = Point.zero
        var maxPoint = Point.zero
        
        for (a,b) in ranges {
            minPoint = Point(min(a.x, minPoint.x), min(a.y, minPoint.y))
            maxPoint = Point(max(b.x, maxPoint.x), max(b.y, maxPoint.y))
        }

        maxPoint = Point(maxPoint.x + abs(minPoint.x), maxPoint.y + abs(minPoint.y))
        for i in (0..<ranges.count) {
            let (a,b) = ranges[i]
            ranges[i] = (Point(a.x + abs(minPoint.x), a.y + abs(minPoint.y)), Point(b.x + abs(minPoint.x), b.y + abs(minPoint.y)))
        }
        minPoint = .zero
        // finished adjusting
        return (ranges, maxPoint)
    }
    
    func parse1(_ input: [String]) -> Int {
        let (ranges, maxPoint) = calculateRanges(input)
        var rowRanges = [[ClosedRange<Int>]]()

        for y in (0...maxPoint.y) {
            let items = ranges.filter {
                ($0.0.y...$0.1.y).contains(y)
            }
            
            let cols = items
                .filter {
                    $0.0.x == $0.1.x
                }
                .map {
                    $0.0.x
                }
                .sorted()
            
            let bars = items
                .filter {
                    $0.0.y == $0.1.y
                }
                .sorted {
                    $0.1.y < $1.0.y
                }
            
            enum HorizontalItem {
                case column(Int)
                case bar((Point, Point))
            }
            
            var horizontalItems = [HorizontalItem]()
            var index = 0
            while index < cols.count {
                let col = cols[index]
                if let bar = bars.first(where: { $0.0.x == col }) {
                    horizontalItems.append(.bar(bar))
                    index += 1
                } else {
                    horizontalItems.append(.column(col))
                }
                index += 1
            }

            var rowElements = [ClosedRange<Int>]()
            index = 0
            while index < horizontalItems.count {
                switch horizontalItems[index] {
                    case let .column(col1):
                        index += 1
                        let next = horizontalItems[index]
                        switch next {
                            case let .column(col2):
                                rowElements.append((col1...col2))
                                
                            case let .bar((_, end2)):
                                rowElements.append((col1...end2.x))
                                if index+1 < horizontalItems.count {
                                    let check = horizontalItems[index+1]
                                    switch next {
                                        case let .column(col2):
                                            if col2 == end2.x {
                                                index += 1
                                            }
                                            
                                        default:
                                            break
                                    }
                                }
                        }
                        
                    case let .bar((start1, end1)):
                        index += 1
                        if index < horizontalItems.count {
                            let next = horizontalItems[index]
                            switch next {
                                case let .column(col2):
                                    rowElements.append((start1.x...col2))
                                    
                                case .bar(_):
                                    rowElements.append((start1.x...end1.x))
                                    index -= 1
                            }
                        } else {
                            rowElements.append((start1.x...end1.x))
                        }
                        
                }
                
                index += 1
            }
            
            if y > 0 {
                let previousElements = rowRanges[y-1]
                for previousElement in previousElements {
                    let overlapping = rowElements
                        .filter {
                            $0.overlaps(previousElement)
                        }
                        .sorted {
                            $0.lowerBound < $1.lowerBound
                        }
                    if !overlapping.isEmpty {
                        for element in overlapping {
                            rowElements.removeAll(where: { $0 == element })
                        }
                        let e1 = overlapping.first!
                        let e2 = overlapping.last ?? e1
                        rowElements.append((e1.lowerBound...e2.upperBound))
                    }
                }
            }
            rowRanges.append(rowElements)
        }
        
        return rowRanges.reduce(0) {
            $0 + $1.reduce(0) {
                $0 + ($1.upperBound - $1.lowerBound + 1)
            }
        }
    }
    
    func parse2(_ input: [String]) -> Int {
        let (ranges, maxPoint) = calculateRanges(input)
        
        var result = 0
        var toProcess = [0]
        
        while !toProcess.isEmpty {
            let y = toProcess.removeFirst()
            guard y < maxPoint.y else { break }
            let items = ranges.filter({ $0.0.y <= y && $0.0.y >= y || $0.1.y <= y && $0.1.y >= y })
            guard !items.isEmpty else { continue }
            let columns = items.filter({ $0.0.y == y && $0.1.y == y })

            for col in columns {
                let r1 = items
                    .filter({ $0.0.x <= col.0.x && $0.0.x >= col.0.x })
                    .sorted(by: { $0.1.y > $1.1.y })
                let r2 = items
                    .filter({ $0.0.x <= col.1.x && $0.0.x >= col.1.x })
                    .sorted(by: { $0.1.y > $1.1.y })
                let m1 = min(r1[0].1.y, r2[0].1.y)
                let m2 = max(r1[0].1.y, r2[0].1.y)
                result += (col.1.x - col.0.x + 2) * (m1 - y + 2)
                if m1 != y {
                    toProcess.append(m1)
                }
                if m1 != m2 {
                    toProcess.append(m2)
                }
            }
            
            toProcess.sort()
        }
        
        
        return result
    }
}
