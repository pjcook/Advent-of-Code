import Foundation
import StandardLibraries

public struct Day13 {
    public init() {}
    
    public func part1(_ input: [String]) -> Point {
        let track = parse(input)

        while true {
            if let position = track.step() {
                return position
            }
//            track.draw()
        }
    }

    public func part2(_ input: [String]) -> Point {
        let track = parse(input)

        while true {
            track.step2()
            if track.numberOfCarts == 1 {
                return track.remainingCart.position
            }
        }
    }

    public func parse(_ input: [String]) -> Track {
        var track = [Point:String]()
        var carts = [Cart]()
        let maxY = input.count
        var maxX = 0
        for y in (0..<input.count) {
            let line = input[y]
            for x in (0..<line.count) {
                if line.count > maxX {
                    maxX = line.count
                }
                let point = Point(x: x, y: y)
                var value = line[x]
                switch value {
                case "<":
                    value = "-"
                    carts.append(Cart(id: carts.count, position: point, direction: .w))
                    break
                case ">":
                    value = "-"
                    carts.append(Cart(id: carts.count, position: point, direction: .e))
                    break
                case "^":
                    value = "|"
                    carts.append(Cart(id: carts.count, position: point, direction: .n))
                    break
                case "v":
                    value = "|"
                    carts.append(Cart(id: carts.count, position: point, direction: .s))
                    break
                default:
                    break
                }
                track[point] = String(value)
            }
        }
        
        return Track(carts: carts, track: track, size: Point(x: maxX, y: maxY))
    }
    
    public class Track {
        private let size: Point
        private let track: [Point:String]
        private var carts: [Cart]
        private var orderedCarts: [Cart] {
            carts.sorted(by: { $0.position.x < $1.position.x && $0.position.y < $1.position.y })
        }
        
        public var numberOfCarts: Int {
            carts.count
        }
        
        public var remainingCart: Cart {
            carts.last!
        }
        
        public init(carts: [Cart], track: [Point:String], size: Point) {
            self.carts = carts
            self.track = track
            self.size = size
        }
        
        public func step() -> Point? {
            let carts = orderedCarts
            var cartPositions = Set<Point>()
            for cart in carts {
                move(cart)
                if cartPositions.contains(cart.position) {
                    return cart.position
                } else {
                    cartPositions.insert(cart.position)
                }
            }
            return nil
        }
        
        public func step2() {
            let carts = orderedCarts
            var currentPositions = Set(carts.map { $0.position })
            var cartPositions = Set<Point>()
            for cart in carts {
                currentPositions.remove(cart.position)
                move(cart)
                if cartPositions.contains(cart.position) || currentPositions.contains(cart.position) {
                    removeCarts(at: cart.position)
                }
                cartPositions.insert(cart.position)
            }
        }
        
        public func removeCarts(at position: Point) {
            carts.removeAll(where: { $0.position == position })
        }
        
        public func move(_ cart: Cart) {
            cart.move()
            switch (track[cart.position]!, cart.direction) {
            case ("/", .n):
                cart.direction = .e
            case ("/", .w):
                cart.direction = .s
            case ("/", .s):
                cart.direction = .w
            case ("/", .e):
                cart.direction = .n
            case ("\\", .e):
                cart.direction = .s
            case ("\\", .n):
                cart.direction = .w
            case ("\\", .w):
                cart.direction = .n
            case ("\\", .s):
                cart.direction = .e
            case ("+", _):
                cart.direction = cart.nextJunction()
            default:
                break
            }
        }
        
        public func draw() {
            for y in (0..<size.y) {
                var line = ""
                for x in (0..<size.x) {
                    let point = Point(x: x, y: y)
                    if let cart = carts.first(where: { $0.position == point }) {
                        line += directionValue(cart.direction)
                    } else {
                        line += track[point, default: " "]
                    }
                }
                print(line)
            }
            print()
        }
        
        private func directionValue(_ direction: CompassDirection) -> String {
            switch direction {
            case .n: return "^"
            case .s: return "v"
            case .e: return ">"
            case .w: return "w"
            }
        }
    }
    
    public class Cart {
        public let id: Int
        public var position: Point
        public var direction: CompassDirection
        public var junctionOptions = Ring<MovementDirection>([.left, .straight, .right])
        
        public init(id: Int, position: Point, direction: CompassDirection) {
            self.id = id
            self.position = position
            self.direction = direction
        }
        
        public func nextJunction() -> CompassDirection {
            switch junctionOptions.next() {
            case .left:
                return direction.rotateLeft()
            case .right:
                return direction.rotateRight()
            default:
                return direction
            }
        }
        
        public func move() {
            switch direction {
            case .n:
                position = position + Point(x: 0, y: -1)
            case .s:
                position = position + Point(x: 0, y: 1)
            case .e:
                position = position + Point(x: 1, y: 0)
            case .w:
                position = position + Point(x: -1, y: 0)
            }
        }
    }
}
