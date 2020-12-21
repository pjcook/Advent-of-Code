import Foundation
import StandardLibraries

public class Day21 {
    public init() {}
    
    public func part1(_ input: [String]) throws -> Int {
        let recipes = try input.map(Recipe.init)
        var alegens = [String: Set<String>]()
        var allIngredients = [String:Int]()

        for recipe in recipes {
            // Find alegens
            alegens = findAlegens(recipe: recipe, recipes: recipes, alegens: alegens)
            
            // Build ingredients list for later
            allIngredients = countIngredients(recipe, allIngredients: allIngredients)
        }

        // Find list of alegen words in foreign language
        let alegenFood = alegens.map { $0.value }.reduce([]) { $0 + $1 }
        
        // Remove words from main ingredient list
        for alegen in alegenFood {
            allIngredients.removeValue(forKey: alegen)
        }
        
        // Count remaining words
        return allIngredients
            .reduce(0) { $0 + $1.value }
    }
    
    public func part2(_ input: [String]) throws -> String {
        let recipes = try input.map(Recipe.init)
        var alegens = [String: Set<String>]()

        for recipe in recipes {
            // Find alegens
            alegens = findAlegens(recipe: recipe, recipes: recipes, alegens: alegens)
        }

        // Reduce alegens list until each alegen can only map to 1 word
        alegens = matchAlegens(alegens)
        
        // Sort English alegen names
        return alegens.keys.sorted()
            // Sort foreign alegen names by sorted English name
            .map { alegens[$0]!.first! }
            // Return foreign alegen names comma separated
            .joined(separator: ",")
    }
}

public extension Day21 {
    func matchAlegens(_ alegens: [String : Set<String>]) -> [String : Set<String>] {
        var alegens = alegens
        while alegens.map({ $0.value }).reduce([], { $0 + $1 }).count > alegens.count {
            for alegen in alegens.filter({ $0.value.count == 1 }) {
                for alegen2 in alegens.filter({ $0.value.count > 1 && $0.value.intersection(alegen.value).count == 1 }) {
                    var list = alegen2.value
                    list.remove(alegen.value.first!)
                    alegens[alegen2.key] = list
                }
            }
        }
        return alegens
    }
    
    func countIngredients(_ recipe: Day21.Recipe, allIngredients: [String : Int]) -> [String : Int] {
        var allIngredients = allIngredients
        for ingredient in recipe.ingredients {
            var count = allIngredients[ingredient] ?? 0
            count += 1
            allIngredients[ingredient] = count
        }
        return allIngredients
    }
    
    func findAlegens(recipe: Recipe, recipes: [Recipe], alegens: [String: Set<String>]) -> [String: Set<String>] {
        var alegens = alegens
        for alegen in recipe.alegens {
            let otherRecipes = findRecipesWithAlegen(alegen, recipes: recipes)
            let matches = findMatchesInAll(recipe, recipes: otherRecipes)
            let previousMatches = alegens[alegen] ?? []
            alegens[alegen] = Set(matches + previousMatches)
        }
        return alegens
    }
    
    func findRecipesWithAlegen(_ alegen: String, recipes: [Recipe]) -> [Recipe] {
        return recipes.filter { $0.alegens.contains(alegen) }
    }
    
    func findMatchesInAll(_ recipe: Recipe, recipes: [Recipe]) -> [String] {
        return recipe.ingredients.filter { ingredient in
            recipes.filter { recipe in
                recipe.ingredients.contains(ingredient)
            }.count == recipes.count
        }
    }
}

public extension Day21 {
    struct Recipe: Hashable {
        public let ingredients: Set<String>
        public let alegens: Set<String>
        public static let regex = try! RegularExpression(pattern: #"([a-z]+)"#)

        public init(_ input: String) throws {
            let matches = Self.regex.matches(in: input)
            let wordList = try matches.map { try $0.string(at: 0) }
            let index = wordList.firstIndex(of: "contains")!
            self.ingredients = Set(wordList[0..<index])
            self.alegens = Set(wordList[(index+1)...])
        }
    }
}
