import Foundation
import StandardLibraries

public struct Day16 {
    public struct Instruction: Hashable {
        public let label: String
        public let l1: Int
        public let l2: Int
        public let l3: Int
        public let l4: Int
        
        public init(label: String, l1: Int, l2: Int, l3: Int, l4: Int) {
            self.label = label
            self.l1 = l1
            self.l2 = l2
            self.l3 = l3
            self.l4 = l4
        }
        
        public func validate(_ input: Int) -> Bool {
            return (l1...l2).contains(input) || (l3...l4).contains(input)
        }
    }
    
    public struct Ticket: Hashable {
        public let yourTicket: Bool
        public let values: [Int]
        
        public init(values: [Int], yourTicket: Bool = false) {
            self.yourTicket = yourTicket
            self.values = values
        }
        
        public func isValid(_ instructions: [Instruction]) -> Bool {
            var valid = true
            for value in values {
                if (instructions.first(where: { $0.validate(value) == true }) == nil) {
                    valid = false
                    break
                }
            }
            return valid
        }
    }
    
    public struct Parser {
        public init() {}
        public let fieldRegex = try! RegularExpression(pattern: #"^([a-z ]+): ([\d]+)-([\d]+) or ([\d]+)-([\d]+)$"#)
        
        public func parse(_ input: [String]) throws -> ([Instruction], [Ticket]) {
            var instructions = [Instruction]()
            for i in 0..<20 {
                let line = input[i]
                let match = try fieldRegex.match(line)
                let label = try match.string(at: 0)
                let l1 = try match.integer(at: 1)
                let l2 = try match.integer(at: 2)
                let l3 = try match.integer(at: 3)
                let l4 = try match.integer(at: 4)
                instructions.append(Instruction(label: label, l1: l1, l2: l2, l3: l3, l4: l4))
            }
            
            var tickets = [Ticket]()
            let line = input[22]
            tickets.append(Ticket(values: line.components(separatedBy: ",").map({ Int(String($0))! }), yourTicket: true))
            
            for i in 25..<265 {
                let line = input[i]
                tickets.append(Ticket(values: line.components(separatedBy: ",").map({ Int(String($0))! }), yourTicket: true))
            }

            return (instructions, tickets)
        }
    }
    
    public init() {}
    
    public func part1(instructions: [Instruction], tickets: [Ticket]) -> Int {
        var invalidNumbers = [Int]()
        
        for ticket in tickets {
            for value in ticket.values {
                if (instructions.first(where: { $0.validate(value) == true }) == nil) {
                    invalidNumbers.append(value)
                }
            }
        }
        
        return invalidNumbers.reduce(0, +)
    }
    
    public func part2(instructions: [Instruction], tickets: [Ticket]) -> Int {
        // Filter to only valid tickets
        let validTickets = tickets.compactMap { $0.isValid(instructions) ? $0 : nil }
        
        // Map instuctions to columns
        var mapped = [Instruction: [Int]]() // cache
        var remainingInstructions = instructions
        var mappedInstructions = [Instruction: Int]()
        var mappedIndexes = [Int]()
        let ticketValue = tickets[0].values.count
        
        while !remainingInstructions.isEmpty {
            let instruction = remainingInstructions.removeFirst()
            var indexes = [Int]()
            if let map = mapped[instruction] {
                // use cache
                indexes = map.compactMap { mappedIndexes.contains($0) ? nil : $0 }
            } else {
                // build cache
                for i in 0..<ticketValue {
                    guard !mappedIndexes.contains(i) else { continue }
                    var valid = true
                    for ticket in validTickets {
                        if !instruction.validate(ticket.values[i]) {
                            valid = false
                            break
                        }
                    }
                    if valid {
                        indexes.append(i)
                    }
                }
            }

            if indexes.count == 1 {
                mappedInstructions[instruction] = indexes[0]
                mappedIndexes.append(indexes[0])
            } else {
                remainingInstructions.append(instruction)
                mapped[instruction] = indexes
            }
        }
        
        // get indexes of departure instructions
        let indexes = instructions
            .filter { $0.label.hasPrefix("departure") }
            .map { mappedInstructions[$0]! }
        let ticket = tickets.first(where: { $0.yourTicket == true })!
        return indexes.reduce(1) { $0 * (ticket.values[$1]) }
    }
}
