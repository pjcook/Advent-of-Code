import Foundation

public extension Collection where Element: Comparable {
    func extremes() -> (Element, Element) {
        var minElement = self[startIndex]
        var maxElement = self[startIndex]
        
        for element in dropFirst() {
            minElement = Swift.min(minElement, element)
            maxElement = Swift.max(maxElement, element)
        }
        
        return (minElement, maxElement)
    }
}

public extension Collection where Element == Point {
    func extremes() -> (Point, Point) {
        var minX = 0
        var minY = 0
        var maxX = 0
        var maxY = 0
        
        for element in self {
            minX = Swift.min(minX, element.x)
            minY = Swift.min(minY, element.y)
            maxX = Swift.max(maxX, element.x)
            maxY = Swift.max(maxY, element.y)
        }
        
        return (Point(minX, minY), Point(maxX, maxY))
    }
}

public extension Collection where Self.Iterator.Element: Collection {
    var transpose: Array<Array<Self.Iterator.Element.Iterator.Element>> {
        var result = Array<Array<Self.Iterator.Element.Iterator.Element>>()
        if self.isEmpty {return result}

        var index = self.first!.startIndex
        while index != self.first!.endIndex {
            var subResult = Array<Self.Iterator.Element.Iterator.Element>()
            for subArray in self {
                subResult.append(subArray[index])
            }
            result.append(subResult)
            index = self.first!.index(after: index)
        }
        return result
    }
}

public extension Array where Element == String {
    func flipHorizontal() -> [String] {
        var results = [String]()
        
        for row in self {
            results.append(String(row.reversed()))
        }
        
        return results
    }
    
    func flipVertical() -> [String] {
        var results = [String]()
        
        for row in self.reversed() {
            results.append(row)
        }
        
        return results
    }
    
    func flipHorizontalAndVertical() -> [String] {
        return flipHorizontal().flipVertical()
    }
    
    func rotateLeft() -> [String] {
        var results = [String]()
        
        for y in (0..<self.count).reversed() {
            var row = ""
            for x in 0..<self[y].count {
                row.append(String((self[x])[y]))
            }
            results.append(row)
        }
        
        return results
    }
}
