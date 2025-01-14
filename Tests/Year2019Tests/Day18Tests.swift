//
//  Day18Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 17/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

// TODO: optimisation
class Day18Tests: XCTestCase {
    let input = Input("Day18.input", Bundle.module).lines
    let day = Day18()

    func test_part1b() {
        // doesn't work currently
//        measure {
        // shortest path h,e,o,p,n,s,r,w,f,c,q,d,l,m,g,x,i,v,k,a,j,t,y,u,b,z
        //               h,e,o,p,s,n,m,l,r,q,c,w,f,d,g,x,i,v,k,a,j,t,y,u,b,z
        XCTAssertEqual(4248, day.part1(input, filename: "2019-18-part1b.cache"))
//        }
    }
    
    func test_part1b2() {
        // Works but is slow with a hack to make it finish
        // 214.925 seconds
//        measure {
        XCTAssertEqual(4248, day.part1b(input))
//        }
    }
    
    func test_part1c() {
        // too slow to wait to see how long it takes
//        measure {
        XCTAssertEqual(4248, day.part1c(input))
//        }
    }
    
    func test_part1b_example() {
        let input = """
#########
#b.A.@.a#
#########
""".lines
        XCTAssertEqual(8, day.part1b(input))
        XCTAssertEqual(8, day.part1(input, filename: "2019-18-part1b-example.cache"))
    }
    
    func test_part1b_example2() {
        let input = """
########################
#...............b.C.D.f#
#.######################
#.....@.a.B.c.d.A.e.F.g#
########################
""".lines
        XCTAssertEqual(132, day.part1b(input))
        XCTAssertEqual(132, day.part1(input, filename: "2019-18-part1b-example2.cache"))
    }
    
    func test_part1b_example3() {
        let input = """
#################
#i.G..c...e..H.p#
########.########
#j.A..b...f..D.o#
########@########
#k.E..a...g..B.n#
########.########
#l.F..d...h..C.m#
#################
""".lines
        // a, f, b, j, g, n, h, d, l, o, e, p, c, i, k, m
        XCTAssertEqual(136, day.part1b(input))
        XCTAssertEqual(136, day.part1(input, filename: "2019-18-part1b-example3.cache"))
    }
    
    func test_part1b_example4() {
        let input = """
########################
#@..............ac.GI.b#
###d#e#f################
###A#B#C################
###g#h#i################
########################
""".lines
        XCTAssertEqual(81, day.part1b(input))
        XCTAssertEqual(81, day.part1(input, filename: "2019-18-part1b-example4.cache"))
    }
    
    func test_part2b() {
//        measure {
        XCTAssertEqual(1878, day.part2(input))
//        }
    }
}
