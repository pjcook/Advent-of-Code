import XCTest
import InputReader
import Year2017

class Day18Tests: XCTestCase {
    
    let input = Input("Day18.input", Bundle.module).lines
    let day = Day18()
    
    func test_part1() {
        //        measure {
        XCTAssertEqual(4601, day.part1(input))
        //        }
    }
    
    func test_part1b() {
        //        measure {
        XCTAssertEqual(4601, day.part1b(input))
        //        }
    }
    
    func test_part1c() {
        let program   = Duet.Assembly(.v1, input)!
        let processor = Duet.Processor(program: program)
        processor.on(.recover) {
            XCTAssertEqual(4601, $0)
            print("The most recently played sound the first time a rcv instruction is executed is \($0!),")
            return .stop
        }
        processor.run()
    }
    
    func test_part1_example() {
        let input = """
set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2
""".lines
        XCTAssertEqual(4, day.part1(input))
    }
    
    func test_part2() {
        //        measure {
//        XCTAssertEqual(6858, day.part2(input))
        //        }
    }
    
    func test_part2b() {
        //        measure {
        XCTAssertEqual(6858, day.part2b(input))
        //        }
    }
    
    func test_part2c() {
        let program_v2 = Duet.Assembly(.v2, input)!
        let p0 = Duet.Processor(id: 0, program: program_v2)
        let p1 = Duet.Processor(id: 1, program: program_v2)
        var messages_sent_by_p1 = 0
        p1.on(.send) { _ in
          messages_sent_by_p1 += 1
          return .proceed
        }
        Duet.run_in_duet(p0, and: p1)
        XCTAssertEqual(6858, messages_sent_by_p1)
        print("and once obht programs have terminated the program 1 sent \(messages_sent_by_p1) values.")
    }
    
    func test_part2_example() {
        let input = """
snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d
""".lines
        XCTAssertEqual(3, day.part2(input))
    }
    
    func test_part2b_example() {
        let input = """
snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d
""".lines
        XCTAssertEqual(3, day.part2b(input))
    }
    
    func test_parsing() {
        let program_v2 = Duet.Assembly(.v1, input)!
        let operations = input.map { Day18.OpCode($0, version: .v1) }
        
        XCTAssertEqual(program_v2.instructions.count, operations.count)
        
        for (ins, op) in zip(program_v2.instructions, operations) {
            switch (ins, op) {
            case let (.send(value1), .send(value2)):
                XCTAssertEqual(value1.eval(fetch: { _ in 0 }), value2.value(with: [:]))
                
            case let (.receive(register1), .receive(register2)):
                XCTAssertEqual(register1, register2)
            
            case let (.set(reg: register1, exp: value1), .set(register2, value2)):
                XCTAssertEqual(register1, register2)
                XCTAssertEqual(value1.eval(fetch: { _ in 0 }), value2.value(with: [:]))
                
            case let (.add(reg: register1, exp: value1), .add(register2, value2)):
                XCTAssertEqual(register1, register2)
                XCTAssertEqual(value1.eval(fetch: { _ in 0 }), value2.value(with: [:]))
                
            case let (.mul(reg: register1, exp: value1), .multiply(register2, value2)):
                XCTAssertEqual(register1, register2)
                XCTAssertEqual(value1.eval(fetch: { _ in 0 }), value2.value(with: [:]))
                
            case let (.mod(reg: register1, exp: value1), .mod(register2, value2)):
                XCTAssertEqual(register1, register2)
                XCTAssertEqual(value1.eval(fetch: { _ in 0 }), value2.value(with: [:]))
                
            case let (.jgz(cond: cond, offset: offset), .jump(register2, value2)):
                switch cond {
                case let .literal(value):
                    XCTAssertEqual(value, register2.value(with: [:]))
                case let .identifier(register1):
                    XCTAssertEqual(String(register1), register2.privateStorage)
                }
                XCTAssertEqual(offset.eval(fetch: { _ in 0 }), value2.value(with: [:]))
                
            case let (.play(src: src), .play(value2)):
                XCTAssertEqual(src.eval(fetch: { _ in 0 }), value2.value(with: [:]))
                
            case let (.recover(cond: cond), .recover(register2)):
                XCTAssertEqual(cond, register2)
                
            case let (.receive(dest: dest), .send(value2)):
                XCTAssertEqual(String(dest), value2.privateStorage)
                
            case let (.send(src: src), .receive(register2)):
                switch src {
                case let .literal(value): fatalError("Invalid: \(value)")
                case let .identifier(register1):
                    XCTAssertEqual(register1, register2)
                }
                
            default:
                fatalError("Undefined: \(ins):\(op)")
            }
        }
    }
}
