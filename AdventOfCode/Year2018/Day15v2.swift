import Foundation
import StandardLibraries

enum ActorType {
    case elf
    case goblin
}

struct Actor {
    let type: ActorType
    var position: Point
    var hitPoints: Int
    let attackPower: Int

    public init(_ type: ActorType, _ position: Point, _ attackPower: Int = 3) {
        self.type = type
        self.position = position
        self.hitPoints = 200
        self.attackPower = attackPower
    }

    var isAlive: Bool {
        return self.hitPoints > 0
    }
}

func pointDistance(_ left: Point, _ right: Point) -> Int {
    return abs(left.x - right.x) + abs(left.y - right.y)
}

func parseInput(input: String, map: inout [Point: Character], actorList: inout [Actor], elfAttackPower: Int) {
    let stringArray = input.split(separator: "\n").map{String($0)}

    actorList.removeAll()

    for y in 0..<stringArray.count {
        for x in 0..<stringArray[y].count {
            var char = stringArray[y][stringArray[y].index(stringArray[y].startIndex, offsetBy: x)]
            switch char {
                case "#": // remove the impassable space
                    continue
                case "E":
                    actorList.append(Actor(ActorType.elf, Point(x, y), elfAttackPower))
                    char = "."
                case "G":
                    actorList.append(Actor(ActorType.goblin, Point(x, y)))
                    char = "."
                default:
                    break
            }
            map[Point(x, y)] = char
        }
    }
}

func simulate(map: [Point: Character], actorList: inout [Actor], part2: Bool) -> Int {
    var turn = 0
    while true {
        actorList.sort{
            if $0.position.y != $1.position.y {
                return $0.position.y < $1.position.y
            } else {
                return $0.position.x < $1.position.x
            }
        }

        for i in 0..<actorList.count {
            if !actorList[i].isAlive {
                continue
            }

            let targetPositions = actorList.filter{$0.type != actorList[i].type && $0.isAlive}.map{$0.position}
            let currentActorPositions = actorList.filter{$0.isAlive}.map{$0.position}
            var destinationPositions = [Point]()
            var metaMap = [Point: Point]()
            var maxDepth = Int.max
            var steps = [(Int, Point)]()
            steps.append((0, actorList[i].position))

            // success
            if targetPositions.isEmpty {
                return turn * actorList.filter{$0.isAlive}.map{$0.hitPoints}.reduce(0, +)
            }

            route: while steps.count > 0 {
                let (currentDepth, currentStep) = steps.remove(at: 0)

                if currentDepth > maxDepth {
                    continue
                }

                // check if the actor is in range of a target
                for (x, y) in zip([0, -1, 1, 0], [-1, 0, 0, 1]) {
                    let target = Point(currentStep.x + x, currentStep.y + y)
                    if targetPositions.contains(target) {
                        maxDepth = currentDepth
                        destinationPositions.append(currentStep)
                        continue route
                    }
                }

                for (x, y) in zip([0, -1, 1, 0], [-1, 0, 0, 1]) {
                    let newStep = Point(currentStep.x + x, currentStep.y + y)
                    if map[newStep] == nil || currentActorPositions.contains(newStep) || metaMap[newStep] != nil {
                        continue
                    }

                    metaMap[newStep] = currentStep
                    steps.append((currentDepth + 1, newStep))
                }
            }

            destinationPositions.sort{
                if $0.y != $1.y {
                    return $0.y < $1.y
                } else {
                    return $0.x < $1.x
                }
            }

            // route building
            var route = [Point]()
            if destinationPositions.count > 0 {
                var step = destinationPositions[0]
                route.append(step)
                // builds the route backwards
                while metaMap[step] != actorList[i].position {
                    if (metaMap[step] != nil) {
                        route.append(metaMap[step]!)
                        step = metaMap[step]!
                    } else {
                        break
                    }
                }
                actorList[i].position = (route.last ?? actorList[i].position)
            }

            // find all potential target indicies adjacent to the currnet position
            var targetIndicies = actorList.indices.filter{
                actorList[$0].isAlive &&
                actorList[$0].type != actorList[i].type &&
                pointDistance(actorList[$0].position, actorList[i].position) == 1
            }

            if !targetIndicies.isEmpty {
                targetIndicies.sort{
                    if actorList[$0].hitPoints != actorList[$1].hitPoints {
                        return actorList[$0].hitPoints < actorList[$1].hitPoints
                    } else if actorList[$0].position.y != actorList[$1].position.y {
                        return actorList[$0].position.y < actorList[$1].position.y
                    } else {
                        return actorList[$0].position.x < actorList[$1].position.x
                    }
                }

                actorList[targetIndicies[0]].hitPoints -= actorList[i].attackPower
                if part2 && actorList[targetIndicies[0]].type == ActorType.elf && actorList[targetIndicies[0]].hitPoints <= 0 {
                    return -1
                }
            }
        }
        turn += 1
    }
}

public func 🗓1️⃣5️⃣(input: String, part2: Bool) -> Int {
    var map = [Point: Character]()
    var actorList = [Actor]()
    var elfAttackPower = part2 ? 4 : 3

    parseInput(input: input, map: &map, actorList: &actorList, elfAttackPower: elfAttackPower)

    if part2 {
        var result = simulate(map: map, actorList: &actorList, part2: true)
        while result == -1 {
            elfAttackPower += 1
            parseInput(input: input, map: &map, actorList: &actorList, elfAttackPower: elfAttackPower)
            result = simulate(map: map, actorList: &actorList, part2: true)
        }
        return result
    } else {
        return simulate(map: map, actorList: &actorList, part2: false)
    }
}

//let testData = "#######\n#.G...#\n#...EG#\n#.#.#G#\n#..G#E#\n#.....#\n#######"
//let testData2 = "#######\n#G..#E#\n#E#E.E#\n#G.##.#\n#...#E#\n#...E.#\n#######"
//let testData3 = "#######\n#E..EG#\n#.#G.E#\n#E.##E#\n#G..#.#\n#..E#.#\n#######"
//let testData4 = "#######\n#E.G#.#\n#.#G..#\n#G.#.G#\n#G..#.#\n#...E.#\n#######"
//let testData5 = "#######\n#.E...#\n#.#..G#\n#.###.#\n#E#G#G#\n#...#G#\n#######"
//let testData6 = "#########\n#G......#\n#.E.#...#\n#..##..G#\n#...##..#\n#...#...#\n#.G...G.#\n#.....G.#\n#########"
//
//assert(🗓1️⃣5️⃣(input: testData, part2: false) == 27730)
//assert(🗓1️⃣5️⃣(input: testData2, part2: false) == 36334)
//assert(🗓1️⃣5️⃣(input: testData3, part2: false) == 39514)
//assert(🗓1️⃣5️⃣(input: testData4, part2: false) == 27755)
//assert(🗓1️⃣5️⃣(input: testData5, part2: false) == 28944)
//assert(🗓1️⃣5️⃣(input: testData6, part2: false) == 18740)
//
//assert(🗓1️⃣5️⃣(input: testData, part2: true) == 4988)
//assert(🗓1️⃣5️⃣(input: testData3, part2: true) == 31284)
//assert(🗓1️⃣5️⃣(input: testData4, part2: true) == 3478)
//assert(🗓1️⃣5️⃣(input: testData5, part2: true) == 6474)
//assert(🗓1️⃣5️⃣(input: testData6, part2: true) == 1140)
//
//let input = try String(contentsOfFile: "input15.txt")
//print("🌟 :", 🗓1️⃣5️⃣(input: input, part2: false))
//print("🌟 :", 🗓1️⃣5️⃣(input: input, part2: true))
