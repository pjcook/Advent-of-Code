import Foundation

public struct Day8 {
    class Node {
        let childNodes: Int
        let metaCount: Int
        var children: [Node] = []
        var meta: [Int] = []
        
        init(childNodes: Int, metaCount: Int) {
            self.childNodes = childNodes
            self.metaCount = metaCount
        }
        
        func buildGraph(_ input: inout [Int]) {
            for _ in 0..<childNodes {
                let node = Node(childNodes: input.removeFirst(), metaCount: input.removeFirst())
                node.buildGraph(&input)
                children.append(node)
            }
            
            for _ in 0..<metaCount {
                meta.append(input.removeFirst())
            }
        }
        
        var sumMeta: Int {
            return meta.reduce(0, +) + children.reduce(0) { $0 + $1.sumMeta }
        }
        
        var value: Int {
            if childNodes == 0 {
                return meta.reduce(0, +)
            } else {
                return (meta
                    .compactMap({
                    let index = $0 - 1
                    return index < children.count ? children[index] : nil
                }) as [Node])
                .reduce(0) { $0 + $1.value }
            }
        }
    }
    
    public func part1(_ input: [Int]) -> Int {
        var input = input
        let node = Node(childNodes: input.removeFirst(), metaCount: input.removeFirst())
        node.buildGraph(&input)
        return node.sumMeta
    }
    
    public func part2(_ input: [Int]) -> Int {
        var input = input
        let node = Node(childNodes: input.removeFirst(), metaCount: input.removeFirst())
        node.buildGraph(&input)
        return node.value
    }
}
