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
