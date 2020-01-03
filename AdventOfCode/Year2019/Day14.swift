//
//  Day14.swift
//  Year2019
//
//  Created by PJ COOK on 13/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

typealias IngredientID = String

struct Recipe {
    let ingredient: Ingredient
    let requiredIngredients: [Ingredient]
    
    var isBaseRecipe: Bool {
        return requiredIngredients.first { $0.id == .ore } != nil
    }
    
    init(_ parts: [String]) {
        let finalIngredient = parts[1].split(separator: " ")
        ingredient = Ingredient(id: String(finalIngredient[1]), value: Int(String(finalIngredient[0]))!)
        
        var ingredients = [Ingredient]()
        let ri = parts[0].split(separator: ",").map { String($0) }
        for item in ri {
            let elements = item.split(separator: " ")
            ingredients.append(
                Ingredient(id: String(elements[1]), value: Int(String(elements[0]))!)
            )
        }
        requiredIngredients = ingredients
    }
}

struct Ingredient {
    let id: IngredientID
    let value: Int
}

extension IngredientID {
    static let ore = "ORE"
    static let fuel = "FUEL"
}

func parseMineralInput(_ input: [String]) -> [Recipe] {
    var recipes = [Recipe]()
    
    for line in input {
        let parts = line.replacingOccurrences(of: "=>", with: ">").split(separator: ">").map { String($0) }
        recipes.append(Recipe(parts))
    }
    
    return recipes
}

class OreCalculator {
    let recipes: [Recipe]
    let baseRecipes: [IngredientID: Recipe]
    
    init(recipes: [Recipe]) {
        self.recipes = recipes
        baseRecipes = recipes.filter { $0.isBaseRecipe }.reduce(into: [IngredientID: Recipe]()) { $0[$1.ingredient.id] = $1 }
    }
    
    struct CalcData {
        let used: Int
        let spare: Int
        
        static let zero = CalcData(used: 0, spare: 0)
    }
    
    var results: [IngredientID:CalcData] = [:]
    
    func calculate(_ ingredient: Ingredient) {
        let recipe = findRecipe(ingredient.id)
        guard !recipe.isBaseRecipe else { return }
        let numberRequired = calculateNumberRequired(ingredient)
        let multiplier = calculateMultiplier(numberRequired: numberRequired, numberProduced: recipe.ingredient.value)
        for item in recipe.requiredIngredients {
            let requiredAmount = item.value * multiplier
            let result = results[item.id] ?? .zero
            let itemRecipe = findRecipe(item.id)
            results[item.id] = CalcData(used: result.used + requiredAmount, spare: max(0, (itemRecipe.ingredient.value * multiplier) - requiredAmount))
            calculate(item)
        }
    }
    
    func calculateNumberRequired(_ ingredient: Ingredient) -> Int {
        guard let result = results[ingredient.id] else { return ingredient.value }
        results[ingredient.id] = CalcData(used: result.used + ingredient.value, spare: 0)
        return ingredient.value - result.spare
    }
    
    func calculateRequiredBaseIngredients(_ ingredient: Ingredient) -> [IngredientID:Int] {
        let recipe = findRecipe(ingredient.id)
        guard !recipe.isBaseRecipe else { return [:] }
        var ingredients = [IngredientID:Int]()
        let multiplier = calculateMultiplier(numberRequired: ingredient.value, numberProduced: recipe.ingredient.value)
        for item in recipe.requiredIngredients {
            let requiredAmount = item.value * multiplier
            ingredients[item.id] = (ingredients[item.id] ?? 0) + requiredAmount
            let multipliedItem = Ingredient(id: item.id, value: requiredAmount)
            let results = calculateRequiredBaseIngredients(multipliedItem)
            ingredients.merge(results) { $0 + $1 }
        }
        return ingredients
    }

    func calculateOreRequired(_ ingredients: [IngredientID:Int]) -> Int {
        return ingredients.reduce(0) { currentValue, item in
            let recipe = findRecipe(item.key)
            guard recipe.isBaseRecipe else { return currentValue }
            return currentValue + (recipe.requiredIngredients[0].value * calculateMultiplier(numberRequired: item.value, numberProduced: recipe.ingredient.value))
        }
    }

    func calculateMultiplier(numberRequired: Int, numberProduced: Int) -> Int {
        var multiplier = numberRequired / numberProduced
        if numberRequired % numberProduced != 0 {
            multiplier += 1
        }
        return multiplier
    }
    
    func findRecipe(_ id: IngredientID) -> Recipe {
        return recipes.first { $0.ingredient.id == id }!
    }
}
