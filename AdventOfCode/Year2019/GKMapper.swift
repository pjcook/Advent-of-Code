import GameplayKit
class GKMapper {
    private var rawMap = [Point:Int]()
    let map: GKGridGraph<GKGridGraphNode>
    
    init(_ rawMap: [Point:Int], wallID: Int) {
        self.rawMap = rawMap
        let (minX,minY,maxX,maxY) = calculateMapDimensions(rawMap)
        map = GKGridGraph(
            fromGridStartingAt: [Int32(minX),Int32(minY)],
            width: Int32(maxX-minX),
            height: Int32(maxY-minY),
            diagonalsAllowed: false
        )
        
        var nodesToRemove = [GKGridGraphNode]()
        // Find Walls
        _ = rawMap.filter { $0.value == wallID }.map {
            if let node = map.node(atGridPosition: $0.key.vector) {
                nodesToRemove.append(node)
            }
        }
        // Remove wall tiles
        map.remove(nodesToRemove)
    }
    
    func removeTilesNotIn(_ options: [Int]) {
        let (minX,minY,maxX,maxY) = calculateMapDimensions(rawMap)
        var nodesToRemove = [GKGridGraphNode]()
        for y in minY..<maxY-minY {
            for x in minX..<maxX-minX {
                let point = Point(x: x, y: y)
                let item = rawMap[point, default: Int.max]
                if !options.contains(item), let node = map.node(atGridPosition: point.vector) {
                    nodesToRemove.append(node)
                }
            }
        }
        map.remove(nodesToRemove)
    }
    
    func route(_ startPoint: Point, _ endPoint: Point) -> [Point] {
        guard let start = map.node(atGridPosition: startPoint.vector),
            let end = map.node(atGridPosition: endPoint.vector) else { return [] }
        guard let path = map.findPath(from: start, to: end) as? [GKGridGraphNode] else { return [] }
        return path.map { Point(x: Int($0.gridPosition.x), y: Int($0.gridPosition.y)) }
    }
}
