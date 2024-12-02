import Foundation
import StandardLibraries

public struct Day4 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let scratchCards = parse(input)
        return scratchCards.reduce(0, { $0 + $1.points })
    }
    
    public func part2(_ input: [String]) -> Int {
        let scratchCards = parse(input)
        var results = Array(repeating: 0, count: scratchCards.count)

        // iterate backwards
        for i in (0..<scratchCards.count) {
            let index = scratchCards.count - 1 - i
            var total = 1
            for j in (index+1..<index + 1 + scratchCards[index].numberOfWinningNumbers) {
                total += results[j]
            }
            results[index] = total
        }
        
        return results.reduce(0, +)
    }
    
    struct ScratchCard {
        let id: Int
        let winningNumbers: [Int]
        let numbers: [Int]
        let points: Int
        let numberOfWinningNumbers: Int
        
        init(id: Int, winningNumbers: [Int], numbers: [Int]) {
            self.id = id
            self.winningNumbers = winningNumbers
            self.numbers = numbers
            
            // calculate points
            var score = 0
            var numberOfWinningNumbers = 0
            for n in numbers {
                if winningNumbers.contains(n) {
                    numberOfWinningNumbers += 1
                    if score == 0 {
                        score = 1
                    } else {
                        score *= 2
                    }
                }
            }
            self.points = score
            self.numberOfWinningNumbers = numberOfWinningNumbers
        }
    }
}

extension Day4 {
    func parse(_ input: [String]) -> [ScratchCard] {
        var results = [ScratchCard]()
        
        for line in input {
            guard !line.isEmpty else { continue }
            let cleanLine = line
                .replacingOccurrences(of: "  ", with: " ")
                .replacingOccurrences(of: "  ", with: " ")
                .replacingOccurrences(of: ": ", with: ":")
                .replacingOccurrences(of: " | ", with: "|")
            let sections = cleanLine.components(separatedBy: ":")
            let cardItems = sections[0].components(separatedBy: " ")
            let cardID = Int(cardItems[1])!
            
            let numberSections = sections[1].components(separatedBy: "|")
            let winningNumberItems = numberSections[0].components(separatedBy: " ")
            let numberItems = numberSections[1].components(separatedBy: " ")
            
            let scratchCard = ScratchCard(
                id: cardID,
                winningNumbers:
                    winningNumberItems
                    .map({ Int($0)! }),
                numbers: 
                    numberItems
                    .map({ Int($0)! })
            )
            results.append(scratchCard)
        }
        
        return results
    }
}
