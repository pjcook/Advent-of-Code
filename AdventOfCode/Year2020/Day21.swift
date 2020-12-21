import Foundation
import StandardLibraries

public struct Day21 {
    public init() {}
    
    public func part1(_ input: [String]) throws -> Int {
        let recipes = try input.map(Recipe.init)
        
        var alegens = [String: [String]]()
        var allIngredients = [String:Int]()

        for recipe in recipes {
            // Find alegens
            for alegen in recipe.alegens {
                let otherRecipes = findRecipesWithAlegen(alegen, recipes: recipes)
                let matches = findMatchesInAll(recipe, recipes: otherRecipes)
                let previousMatches = alegens[alegen] ?? []
                alegens[alegen] = matches + previousMatches
            }
            
            // Build ingredients list for later
            for ingredient in recipe.ingredients {
                var count = allIngredients[ingredient] ?? 0
                count += 1
                allIngredients[ingredient] = count
            }
        }

        // Find list of alegen words in foreign language
        let alegenFood = Set(alegens.map { $0.value }.reduce([]) { $0 + $1 })
        
        // Remove words from main ingredient list
        for alegen in alegenFood {
            allIngredients.removeValue(forKey: alegen)
        }
        
        // Count remaining words
        return allIngredients.map { $0.value }.reduce(0, +)
    }
    
    public func part2(_ input: [String]) throws -> String {
        let recipes = try input.map(Recipe.init)
        
        var alegens = [String: Set<String>]()

        for recipe in recipes {
            // Find alegens
            for alegen in recipe.alegens {
                let otherRecipes = findRecipesWithAlegen(alegen, recipes: recipes)
                let matches = findMatchesInAll(recipe, recipes: otherRecipes)
                let previousMatches = alegens[alegen] ?? []
                alegens[alegen] = Set(matches + previousMatches)
            }
        }

        // Reduce alegens list until each alegen can only map to 1 word
        while alegens.map({ $0.value }).reduce([], { $0 + $1 }).count > alegens.count {
            for alegen in alegens.filter({ $0.value.count == 1 }) {
                for alegen2 in alegens.filter({ $0.value.count > 1 && $0.value.intersection(alegen.value).count == 1 }) {
                    var list = alegen2.value
                    list.remove(alegen.value.first!)
                    alegens[alegen2.key] = list
                }
            }
        }
        
        // Sort English alegen names
        let alegenNames = alegens.keys.sorted()
        var output = [String]()
        
        // Sort foreign alegen names by sorted English name
        for name in alegenNames {
            output.append(alegens[name]!.first!)
        }
        
        // Return foreign alegen names comma separated
        return output.joined(separator: ",")
    }
}

public extension Day21 {
    func findRecipesWithAlegen(_ alegen: String, recipes: [Recipe]) -> [Recipe] {
        var results = [Recipe]()
        
        for recipe in recipes {
            if recipe.alegens.contains(alegen) {
                results.append(recipe)
            }
        }
        
        return results
    }
    
    func findMatchesInAll(_ recipe: Recipe, recipes: [Recipe]) -> [String] {
        var matches = [String]()
        let match = recipes.count
        for ingredient in recipe.ingredients {
            if recipes.filter({ $0.ingredients.contains(ingredient) }).count == match {
                matches.append(ingredient)
            }
        }
        
        return matches
    }
}

public extension Day21 {
    struct Recipe: Hashable {
        public let ingredients: Set<String>
        public let alegens: Set<String>
        public static let regex = try! RegularExpression(pattern: #"([a-z]+)"#)

        public init(_ input: String) throws {
            let matches = Self.regex.matches(in: input)
            var ingredients = [String]()
            var alegens = [String]()
            var foundContains = false
            for match in matches {
                let word = try match.string(at: 0)
                if word == "contains" {
                    foundContains = true
                } else if foundContains {
                    alegens.append(word)
                } else {
                    ingredients.append(word)
                }
            }
            self.ingredients = Set(ingredients)
            self.alegens = Set(alegens)
        }
    }
}
