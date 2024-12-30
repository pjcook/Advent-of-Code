import XCTest
import InputReader
import Year2016

class Day11Tests: XCTestCase {
    
    let day = Day11()

    func test_part1() {
//        measure {
        let floors: [Day11.Floor] = [
            Day11.Floor(id: 1, devices: [
                Day11.Device(id: "S", type: .generator),
                Day11.Device(id: "S", type: .microchip),
                Day11.Device(id: "P", type: .generator),
                Day11.Device(id: "P", type: .microchip),
                ]),
            
            Day11.Floor(id: 2, devices: [
                Day11.Device(id: "R", type: .generator),
                Day11.Device(id: "R", type: .microchip),
                Day11.Device(id: "C", type: .generator),
                Day11.Device(id: "C", type: .microchip),
                Day11.Device(id: "T", type: .generator),
            ]),
            
            Day11.Floor(id: 3, devices: [
                Day11.Device(id: "T", type: .microchip),
            ]),
            
            Day11.Floor(id: 4, devices: [
            ]),
        ]
        XCTAssertEqual(37, day.part1(floors))
//        }
    }
    
    func test_part1_example() {
        let floors: [Day11.Floor] = [
            Day11.Floor(id: 1, devices: [
                Day11.Device(id: "H", type: .microchip),
                Day11.Device(id: "L", type: .microchip),
                ]),
            
            Day11.Floor(id: 2, devices: [
                Day11.Device(id: "H", type: .generator),
            ]),
            
            Day11.Floor(id: 3, devices: [
                Day11.Device(id: "L", type: .generator),
            ]),
            
            Day11.Floor(id: 4, devices: [
            ]),
        ]
        XCTAssertEqual(11, day.part1(floors))
    }
    
    func test_part2() {
//        measure {
        let floorsA: [Day11.Floor] = [
            Day11.Floor(id: 1, devices: [
                Day11.Device(id: "S", type: .generator),
                Day11.Device(id: "S", type: .microchip),
                ]),
            
            Day11.Floor(id: 2, devices: [
                Day11.Device(id: "R", type: .generator),
                Day11.Device(id: "R", type: .microchip),
                Day11.Device(id: "C", type: .generator),
                Day11.Device(id: "C", type: .microchip),
                Day11.Device(id: "T", type: .generator),
            ]),
            
            Day11.Floor(id: 3, devices: [
                Day11.Device(id: "T", type: .microchip),
            ]),
            
            Day11.Floor(id: 4, devices: [
            ]),
        ]
        
        let floorsB: [Day11.Floor] = [
            Day11.Floor(id: 1, devices: [
                Day11.Device(id: "S", type: .generator),
                Day11.Device(id: "S", type: .microchip),
                Day11.Device(id: "P", type: .generator),
                Day11.Device(id: "P", type: .microchip),
                ]),
            
            Day11.Floor(id: 2, devices: [
                Day11.Device(id: "R", type: .generator),
                Day11.Device(id: "R", type: .microchip),
                Day11.Device(id: "C", type: .generator),
                Day11.Device(id: "C", type: .microchip),
                Day11.Device(id: "T", type: .generator),
            ]),
            
            Day11.Floor(id: 3, devices: [
                Day11.Device(id: "T", type: .microchip),
            ]),
            
            Day11.Floor(id: 4, devices: [
            ]),
        ]
        // 25, 37, 49
        let a = day.part1(floorsA)
        let b = day.part1(floorsB)
        let dx = b - a
        let result = b + 2 * dx
        XCTAssertEqual(61, result)
//        }
    }
}

/*
 F4 . .. .. .. .. .. .. .. .. .. ..
 F3 . .. .. .. .. .. .. .. .. .. TM
 F2 . .. .. .. .. RG RM CG CM TG ..
 F1 E SG SM PG PM .. .. .. .. .. ..
 */
