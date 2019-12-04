//
//  Day1.swift
//  Year2019
//
//  Created by PJ COOK on 02/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

func basicFuelCalculation(mass: Int) -> Int {
    return (mass / 3) - 2
}

func calculateFuelRequired(mass: Int) -> Int {
    let fuel = basicFuelCalculation(mass: mass)
    guard fuel > 0 else { return 0 }
    return fuel + calculateFuelRequired(mass: fuel)
}

func calculateFuelRequired(input: [Int]) -> Int {
    return input.reduce(0) { $0 + calculateFuelRequired(mass: $1) }
}
