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

class Day25Tests: XCTestCase {
    let input = Input("Day25.input", Bundle.module).delimited(",", cast: Int.init).compactMap({ $0 })
    let day = Day25()
    
    /*
     If you want to play the game manually then you need to comment out the line `populateValidActions()` and put a break point in the `readInput(id: Int)` function where it says `return -1`. Then when the break point is hit, you need to view the output in the console and manually enter the action you want to take. e.g. `po perform(.move(.south))` then press `play` to process that input and see the next set of options.
     */
    func test_part1() {
        XCTAssertEqual(134807554, day.part1(input))
    }

    /*
                                                                                                            [Navigation (astolabe)]    [Crew quarters (dehydrated water)]
                                                                                                                      I                               I
                                                                                                                      I                               I
                                                                                                            [Hallway (escape pod)]        [Corridor (infinite loop)]
                                                                                                                      I                               I
                                                                                                                      I                               I
                                                                            [Storage (mutex)] --- [Arcade] --- [Kitchen (sand)]           [Warp drive maintenance]
                                                                                                                      I                               I
                                                                             [Observatory (shell)]                    I                               I
                                                                                       I                              I                               I
                                                                                       I                              I                               I
                                                                                  [Holodeck] -------------- [Hull breach - START] --- [Science lab (klein bottle)] --- [Stables (semiconductor)]
                                                                                       I
                                                                                       I
        [Gift wrap center] --- [Hot chocolate fountain (ornament)] --- [Sick bay (giant electromagnet)] --- [Engineering (photons)]
                I                                                                                                      I
                I                                                                                                      I
      [Security Checkpoint]                                                                                 [Passages (molten lava)]
                I
                I
         [Pressure Plate]
     */
}
