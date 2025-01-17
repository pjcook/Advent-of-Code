//
//  Day25Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 01/01/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

// TODO: optimisation migrate to Computer
class Day25Tests: XCTestCase {
    let input = try! readInputAsIntegers(filename: "Day25.input", delimiter: ",", bundle: .module)
    
    func test_part1() throws {
        let droid = InvestigationDroid(input)
        droid.process()
        // Answer: 134807554
        // You need: [sand, ornament, astrolabe, shell]
        // to get across the pressure plate
        
        /*
         Kitchen: sand
         Hallway: escape pod (DO NOT TAKE)
         Navigation: astrolabe
         Storage: mutex
         Observatory: shell
         Sick Bay: giant electromagnet (DO NOT TAKE)
         Hot Chocolate Fountain: ornament
         Engineering: photons (DO NOT TAKE)
         Passage: molten lava (DO NOT TAKE)
         Science lab: klein bottle (too heavy by itself)
         Stables: semiconductor
         Corridor: infinite loop (DO NOT TAKE)
         Crew Quarters: dehydrated water
         */
    }

}
