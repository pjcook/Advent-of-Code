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
    
    var spareIngredients = [IngredientID:Int]()
    func calculateRequiredBaseIngredients(_ ingredient: Ingredient) -> [IngredientID:Int] {
        let recipe = findRecipe(ingredient.id)
        let numberRequired = ingredient.value
        let numberProduced = recipe.ingredient.value
        let multiplier = calculateMultiplier(numberRequired: numberRequired, numberProduced: numberProduced)
        
        if recipe.isBaseRecipe {
            spareIngredients[ingredient.id] = (numberProduced * multiplier) - numberRequired
            return [ingredient.id:numberRequired]
        }
        
        var ingredients = [IngredientID:Int]()
        for ingredient in recipe.requiredIngredients {
            if let recipe = baseRecipes[ingredient.id] {
                let value = calculateNumberRequired(id: ingredient.id, numberRequired: ingredient.value * multiplier, numberProduced: recipe.ingredient.value)
                ingredients[ingredient.id] = (ingredients[ingredient.id] ?? 0) + value
            } else {
                ingredients.merge(calculateRequiredBaseIngredients(ingredient)) { $0 + $1 }
            }
        }
        
        return ingredients
    }
    
    func calculateNumberRequired(id: IngredientID, numberRequired: Int, numberProduced: Int) -> Int {
        let spare = spareIngredients[id] ?? 0
        if spare >= numberRequired {
            spareIngredients[id] = spare - numberRequired
            return 0
        } else {
            var ingredientCount = 0
            var value = spare
            while value < numberRequired {
                ingredientCount += 1
                value += numberProduced
            }
            
            spareIngredients[id] = value - numberRequired
            return ingredientCount
        }
    }
    
    func findRecipe(_ id: IngredientID) -> Recipe {
        return recipes.first { $0.ingredient.id == id }!
    }
    
    func calculateMultiplier(numberRequired: Int, numberProduced: Int) -> Int {
        var multiplier = numberRequired / numberProduced
        if numberRequired % numberProduced != 0 {
            multiplier += 1
        }
        return multiplier
    }
}

func calculateOreRequired(_ fuelRequired: Int, recipes: [Recipe]) -> Int {
    let fuel = recipes.first { $0.ingredient.id == .fuel }!
    let minerals = countRequiredIngredients(fuel.ingredient, recipes: recipes)
    print(minerals)
    return minerals.reduce(0) { currentValue, item in
        let recipe = recipes.first { $0.ingredient.id == item.key }!
        if recipe.requiredIngredients[0].id == .ore {
            var count = item.value / recipe.ingredient.value
            if item.value % recipe.ingredient.value != 0 {
                count += 1
            }
            return currentValue + (count * recipe.requiredIngredients[0].value)
        } else {
            return currentValue
        }
    }
}

func countRequiredIngredients(_ ingredient: Ingredient, recipes: [Recipe]) -> [IngredientID:Int] {
    guard ingredient.id != .ore else { return [:] }
    
    let recipe = recipes.first { $0.ingredient.id == ingredient.id }!
    if recipe.requiredIngredients[0].id == .ore { return [:] }
    var materials = [IngredientID:Int]()
    var multiplier = ingredient.value / recipe.ingredient.value
    if ingredient.value % recipe.ingredient.value != 0 {
        multiplier += 1
    }
    print(ingredient.id, ingredient.value, recipe.ingredient.id, recipe.ingredient.value, multiplier)
    
    for requiredIngredient in recipe.requiredIngredients {
        let ingredientMaterials = countRequiredIngredients(requiredIngredient, recipes: recipes)
        if !ingredientMaterials.isEmpty {
            ingredientMaterials.forEach {
                materials[$0.key] = (materials[$0.key] ?? 0) + ($0.value * multiplier)
            }
        }
        materials[requiredIngredient.id] = (materials[requiredIngredient.id] ?? 0) + (requiredIngredient.value * multiplier)
    }
    print(materials)
    return materials
}

/*
 FUEL 1 FUEL 1 1
 STKFG 53 STKFG 1 53
 VPVL 2 VPVL 8 1
 ["JNWZP": 3, "NVRVD": 17]
 FWMGM 7 FWMGM 5 2
 ["MNCFX": 74, "VJHF": 44]
 CXFTF 2 CXFTF 8 1
 ["NVRVD": 1]
 ["JNWZP": 159, "VJHF": 2332, "VPVL": 106, "FWMGM": 371, "NVRVD": 954, "CXFTF": 106, "MNCFX": 4505]
 HVMC 81 HVMC 3 27
 RFSQX 7 RFSQX 4 2
 ["VJHF": 2, "MNCFX": 12]
 FWMGM 2 FWMGM 5 1
 ["MNCFX": 37, "VJHF": 22]
 VPVL 2 VPVL 8 1
 ["JNWZP": 3, "NVRVD": 17]
 CXFTF 19 CXFTF 8 3
 ["NVRVD": 3]
 ["RFSQX": 189, "JNWZP": 81, "CXFTF": 513, "FWMGM": 54, "MNCFX": 1458, "VJHF": 648, "VPVL": 54, "NVRVD": 540]
 CXFTF 68 CXFTF 8 9
 ["NVRVD": 9]
 GNMV 25 GNMV 6 5
 VPVL 9 VPVL 8 2
 ["NVRVD": 34, "JNWZP": 6]
 CXFTF 37 CXFTF 8 5
 ["NVRVD": 5]
 ["VPVL": 45, "NVRVD": 195, "VJHF": 25, "MNCFX": 35, "JNWZP": 30, "CXFTF": 185]
 ["JNWZP": 270, "VJHF": 3051, "FWMGM": 425, "CXFTF": 872, "NVRVD": 1698, "HVMC": 81, "GNMV": 25, "STKFG": 53, "VPVL": 205, "MNCFX": 6004, "RFSQX": 189]
 
 ===================================================================
 139 ORE => 4 NVRVD
 144 ORE => 7 JNWZP
 145 ORE => 6 MNCFX
 176 ORE => 6 VJHF
 17 NVRVD, 3 JNWZP => 8 VPVL
 22 VJHF, 37 MNCFX => 5 FWMGM
 1 VJHF, 6 MNCFX => 4 RFSQX
 2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG
 5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC
 1 NVRVD => 8 CXFTF
 5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV
 53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL
 */
