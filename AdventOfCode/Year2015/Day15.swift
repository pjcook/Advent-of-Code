import Foundation
import StandardLibraries

public struct Day15 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let ingredients = parse(input)
        var scores = [Int]()
        for a in (1..<100 - ingredients.count + 1) {
            for b in (1..<100-a) {
                for c in (1..<100-a-b) {
                    let d = 100-a-b-c
                    assert(a+b+c+d == 100)
                    let ingredient1 = ingredients[0]
                    let ingredient2 = ingredients[1]
                    let ingredient3 = ingredients[2]
                    let ingredient4 = ingredients[3]
                    let capacity = ingredient1.capacity * a + ingredient2.capacity * b + ingredient3.capacity * c + ingredient4.capacity * d
                    let durability = ingredient1.durability * a + ingredient2.durability * b + ingredient3.durability * c + ingredient4.durability * d
                    let flavor = ingredient1.flavor * a + ingredient2.flavor * b + ingredient3.flavor * c + ingredient4.flavor * d
                    let texture = ingredient1.texture * a + ingredient2.texture * b + ingredient3.texture * c + ingredient4.texture * d
                    if capacity > 0, durability > 0, flavor > 0, texture > 0 {
                        scores.append(capacity * durability * flavor * texture)
                    }
                }
            }
        }
        
        return scores.sorted().last ?? -1
    }
    
    public func part2(_ input: [String]) -> Int {
        let ingredients = parse(input)
        var scores = [Int]()
        for a in (1..<100 - ingredients.count + 1) {
            for b in (1..<100-a) {
                for c in (1..<100-a-b) {
                    let d = 100-a-b-c
                    assert(a+b+c+d == 100)
                    let ingredient1 = ingredients[0]
                    let ingredient2 = ingredients[1]
                    let ingredient3 = ingredients[2]
                    let ingredient4 = ingredients[3]
                    let calories = ingredient1.calories * a + ingredient2.calories * b + ingredient3.calories * c + ingredient4.calories * d
                    
                    guard calories == 500 else {
                        continue
                    }
                    
                    let capacity = ingredient1.capacity * a + ingredient2.capacity * b + ingredient3.capacity * c + ingredient4.capacity * d
                    let durability = ingredient1.durability * a + ingredient2.durability * b + ingredient3.durability * c + ingredient4.durability * d
                    let flavor = ingredient1.flavor * a + ingredient2.flavor * b + ingredient3.flavor * c + ingredient4.flavor * d
                    let texture = ingredient1.texture * a + ingredient2.texture * b + ingredient3.texture * c + ingredient4.texture * d
                    if capacity > 0, durability > 0, flavor > 0, texture > 0 {
                        scores.append(capacity * durability * flavor * texture)
                    }
                }
            }
        }
        
        return scores.sorted().last ?? -1
    }
    
    public func parse(_ input: [String]) -> [Ingredient] {
        var ingredients = [Ingredient]()
        for line in input {
            let comps = line.components(separatedBy: ": ")
            let name = comps[0]
            let characteristics: [(String, Int)] = comps[1].components(separatedBy: ",").map {
                let parts = $0.trimmingCharacters(in: .whitespacesAndNewlines)
                    .components(separatedBy: " ")
                return (parts[0], Int(parts[1])!)
            }
            ingredients.append(Ingredient(name: name, characteristics: characteristics))
        }
        return ingredients
    }
    
    public struct Ingredient {
        let name: String
        let capacity: Int
        let durability: Int
        let flavor: Int
        let texture: Int
        let calories: Int
        
        public init(name: String, characteristics: [(String, Int)]) {
            self.name = name
            self.capacity = characteristics[0].1
            self.durability = characteristics[1].1
            self.flavor = characteristics[2].1
            self.texture = characteristics[3].1
            self.calories = characteristics[4].1
        }
    }
}
