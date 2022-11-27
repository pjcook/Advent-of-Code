//
//  Day14.swift
//  Year2019
//
//  Created by PJ COOK on 13/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

public typealias IngredientID = String

public struct Recipe {
    public let ingredient: Ingredient
    public let requiredIngredients: [Ingredient]
    
    public var isBaseRecipe: Bool {
        return requiredIngredients.first { $0.id == .ore } != nil
    }
    
    public init(_ parts: [String]) {
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

public struct Ingredient {
    public let id: IngredientID
    public let value: Int
}

public extension IngredientID {
    static let ore = "ORE"
    static let fuel = "FUEL"
}

public func parseMineralInput(_ input: [String]) -> [Recipe] {
    var recipes = [Recipe]()
    
    for line in input {
        let parts = line.replacingOccurrences(of: "=>", with: ">").split(separator: ">").map { String($0) }
        recipes.append(Recipe(parts))
    }
    
    return recipes
}

public class OreCalculator {
    public let recipes: [Recipe]
    private var required = [IngredientID:Int]()
    private var spare = [IngredientID:Int]()

    public init(recipes: [Recipe]) {
        self.recipes = recipes
    }
    
    private func disassembleSpares() -> Int {
        var ore = 0
        var queue = spare.compactMap { $0.value > 0 ? $0.key : nil }
        
        while !queue.isEmpty {
            let key = queue.removeFirst()
            let value = spare[key, default: 0]
            if value > 0 {
                let recipe = findRecipe(key)
                let multiplier = Int(value / recipe.ingredient.value)
                let remainder = value - (recipe.ingredient.value * multiplier)
                spare[key] = remainder
                
                for ingredient in recipe.requiredIngredients {
                    if ingredient.id == IngredientID.ore {
                        ore += recipe.requiredIngredients.first!.value * multiplier
                    } else {
                        let currentAmount = spare[ingredient.id, default: 0]
                        spare[ingredient.id] = currentAmount + (ingredient.value * multiplier)
                        if currentAmount + (ingredient.value * multiplier) > ingredient.value {
                            queue.append(ingredient.id)
                        }
                    }
                }
            }
        }

        return ore
    }
    
    public func calculateMaxFuel(_ ingredient: Ingredient, _ maxOre: Int) -> Int {
        let ore = calculate(ingredient)
        let basicSpares = spare
        var remainingOre = maxOre
        var fuelCount = 0
                        
        while remainingOre > ore {
            let iterations = remainingOre / ore
            fuelCount += iterations * ingredient.value
            remainingOre -= ore * iterations
            basicSpares.forEach {
                spare[$0.key] = (spare[$0.key, default: 0]) + ($0.value * iterations)
            }
            remainingOre += disassembleSpares()
//            print(fuelCount, remainingOre)
        }
        
        return fuelCount
    }
        
    public func calculate(_ ingredient: Ingredient) -> Int {
        let initialItem = findRecipe(ingredient.id)
        var ore = 0
        required[initialItem.ingredient.id] = initialItem.ingredient.value
        
        while !required.isEmpty {
            guard let work = required.popFirst() else { return ore }
            let recipe = findRecipe(work.key)
            var multiplier = work.value / recipe.ingredient.value
            if work.value % recipe.ingredient.value != 0 {
                multiplier += 1
            }
            let spareWork = (recipe.ingredient.value * multiplier) - work.value
            let currentSpare = spare[work.key, default: 0]
            spare[work.key] = currentSpare + spareWork
            
            for ingredient in recipe.requiredIngredients {
                var requiredAmount = ingredient.value * multiplier
                guard ingredient.id != IngredientID.ore else {
                    ore += requiredAmount
                    continue
                }
                let available = spare.removeValue(forKey: ingredient.id) ?? 0
                requiredAmount -= available
                if requiredAmount < 0 {
                    spare[ingredient.id] = abs(requiredAmount)
                } else {
                    let outstandingAmount = required[ingredient.id, default: 0]
                    required[ingredient.id] = outstandingAmount + requiredAmount
                }
            }
        }
        
        return ore
    }
    
    public func findRecipe(_ id: IngredientID) -> Recipe {
        return recipes.first { $0.ingredient.id == id }!
    }
}
