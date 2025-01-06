import XCTest
import InputReader
import Year2017

class Day25Tests: XCTestCase {
    
    let input = Input("Day25.input", Bundle.module).lines
    let day = Day25()

    func test_part1() {
//        measure {
        let stateA = Day25.State(id: "A", instructions: [
            Day25.Instruction(write: 1, move: 1, nextState: "B"),
            Day25.Instruction(write: 0, move: -1, nextState: "C"),
        ])
        let stateB = Day25.State(id: "B", instructions: [
            Day25.Instruction(write: 1, move: -1, nextState: "A"),
            Day25.Instruction(write: 1, move: -1, nextState: "D"),
        ])
        let stateC = Day25.State(id: "C", instructions: [
            Day25.Instruction(write: 1, move: 1, nextState: "D"),
            Day25.Instruction(write: 0, move: 1, nextState: "C"),
        ])
        let stateD = Day25.State(id: "D", instructions: [
            Day25.Instruction(write: 0, move: -1, nextState: "B"),
            Day25.Instruction(write: 0, move: 1, nextState: "E"),
        ])
        let stateE = Day25.State(id: "E", instructions: [
            Day25.Instruction(write: 1, move: 1, nextState: "C"),
            Day25.Instruction(write: 1, move: -1, nextState: "F"),
        ])
        let stateF = Day25.State(id: "F", instructions: [
            Day25.Instruction(write: 1, move: -1, nextState: "E"),
            Day25.Instruction(write: 1, move: 1, nextState: "A"),
        ])
        let states = [
            "A": stateA,
            "B": stateB,
            "C": stateC,
            "D": stateD,
            "E": stateE,
            "F": stateF,
        ]
        XCTAssertEqual(2474, day.part1(states, steps: 12172063))
//        }
    }
    
    func test_part1_example() {
        let input = """
Begin in state A.
Perform a diagnostic checksum after 6 steps.

In state A:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state B.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state B.

In state B:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state A.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A.
""".lines
        let stateA = Day25.State(id: "A", instructions: [
            Day25.Instruction(write: 1, move: 1, nextState: "B"),
            Day25.Instruction(write: 0, move: -1, nextState: "B"),
        ])
        let stateB = Day25.State(id: "B", instructions: [
            Day25.Instruction(write: 1, move: -1, nextState: "A"),
            Day25.Instruction(write: 1, move: 1, nextState: "A"),
        ])
        let states = [
            "A": stateA,
            "B": stateB
        ]
        XCTAssertEqual(3, day.part1(states, steps: 6))
    }
}
