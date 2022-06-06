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
