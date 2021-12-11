import Foundation
import StandardLibraries

public struct Day3 {
    public init() {}
    
    public struct Diagnostic {
        public let gammaRate: Int
        public let epsilonRate: Int
    }
    
    /*
     The diagnostic report (your puzzle input) consists of a list of binary numbers which, when decoded properly, can tell you many useful things about the conditions of the submarine. The first parameter to check is the power consumption.

     You need to use the binary numbers in the diagnostic report to generate two new binary numbers (called the gamma rate and the epsilon rate). The power consumption can then be found by multiplying the gamma rate by the epsilon rate.

     Each bit in the gamma rate can be determined by finding the most common bit in the corresponding position of all numbers in the diagnostic report.
     
     The epsilon rate is calculated in a similar way; rather than use the most common bit, the least common bit from each position is used.
     
     To calculate the "most significant bit", you look at all the values at each position in each row (looking at the input data you want to process each column basically), and figure out whether there are more 1 or 0 values in that column. The gamma bit value is the most significant bit, the epsilon rate is the least significant bit.
     */
    public func part1(_ input: [String]) -> Int {
        let diagnostic = calculateGammaAndEpsilon(input)
        return diagnostic.gammaRate * diagnostic.epsilonRate
    }
    
    /*
     Next, you should verify the life support rating, which can be determined by multiplying the oxygen generator rating by the CO2 scrubber rating.

     Both the oxygen generator rating and the CO2 scrubber rating are values that can be found in your diagnostic report - finding them is the tricky part. Both values are located using a similar process that involves filtering out values until only one remains. Before searching for either rating value, start with the full list of binary numbers from your diagnostic report and consider just the first bit of those numbers. Then:

     • Keep only numbers selected by the bit criteria for the type of rating value for which you are searching. Discard numbers which do not match the bit criteria.
     • If you only have one number left, stop; this is the rating value for which you are searching.
     • Otherwise, repeat the process, considering the next bit to the right.
     
     The bit criteria depends on which type of rating value you want to find:

     • To find oxygen generator rating, determine the most common value (0 or 1) in the current bit position, and keep only numbers with that bit in that position. If 0 and 1 are equally common, keep values with a 1 in the position being considered.
     • To find CO2 scrubber rating, determine the least common value (0 or 1) in the current bit position, and keep only numbers with that bit in that position. If 0 and 1 are equally common, keep values with a 0 in the position being considered.
     */
    public func part2(_ input: [String]) -> Int {
        return calculateOxygenGeneratorRating(input) * calculateCO2ScrubberRating(input)
    }
    
    /*
     To find oxygen generator rating, determine the most common value (0 or 1) in the current bit position, and keep only numbers with that bit in that position. If 0 and 1 are equally common, keep values with a 1 in the position being considered.
     
     Processing each column in turn, keep only the rows that have a bit matching the most significant bit in that column, discard all other rows until you only have 1 left.
     */
    public func calculateOxygenGeneratorRating(_ input: [String]) -> Int {
        var input2 = input
        for column in (0..<input2[0].count) {
            // Are there more 1's than zeros in the current column?
            let sigOne = calculateSignificantBitIsOne(in: column, input: input2, check: { $0 >= $1 - $0 })
            // filter out rows where the most significant bit does not match the item at the column position for that row
            input2 = input2.filter({ value in
                String(value[column]) == (sigOne ? "1" : "0")
            })
            
            // If only 1 row remaining return the decimal value of the binary number of that row
            if input2.count == 1 {
                return Int(input2[0], radix: 2)!
            }
        }
        return -1
    }
    
    /*
     To find CO2 scrubber rating, determine the least common value (0 or 1) in the current bit position, and keep only numbers with that bit in that position. If 0 and 1 are equally common, keep values with a 0 in the position being considered.
     
     Processing each column in turn, keep only the rows that have a bit matching the least significant bit in that column, discard all other rows until you only have 1 left.
     */
    public func calculateCO2ScrubberRating(_ input: [String]) -> Int {
        var input2 = input
        for column in (0..<input2[0].count) {
            // Are there more 1's than zeros in the current column?
            let sigOne = calculateSignificantBitIsOne(in: column, input: input2, check: { $0 >= $1 - $0 })
            // filter out rows where the most significant bit does not match the item at the column position for that row
            input2 = input2.filter({ value in
                String(value[column]) == (sigOne ? "0" : "1")
            })
            
            // If only 1 row remaining return the decimal value of the binary number of that row
            if input2.count == 1 {
                return Int(input2[0], radix: 2)!
            }
        }
        return -1
    }
    
    public func calculateGammaAndEpsilon(_ input: [String]) -> Diagnostic {
        // Using strings to build up the resulting binary numbers so that we don't lose leading zeros
        var gamma = ""
        var epsilon = ""
        
        // loop over each column
        for column in (0..<input[0].count) {
            // Are there more 1's than zeros in the current column?
            let sigOne = calculateSignificantBitIsOne(in: column, input: input, check: { $0 > $1 - $0 })
            gamma.append(sigOne ? "1" : "0")
            // epsilon is effectively the opposite of gamma
            epsilon.append(sigOne ? "0" : "1")
        }
        // Convert the binary result strings to decimal numbers
        return Diagnostic(gammaRate: Int(gamma, radix: 2)!, epsilonRate: Int(epsilon,  radix: 2)!)
    }
    
    public func calculateSignificantBitIsOne(in column: Int, input: [String], check: (Int,Int) -> Bool) -> Bool {
        var count = 0
        // look at the value in each row for the current column, count the rows where the bit == 1
        for line in input {
            if line[column] == "1" {
                count += 1
            }
        }
        
        // There are more 1's if the number of 1's found (count) is greater than the number of rows (input.count) minus the number of 1's found.
        return check(count, input.count)
    }
}
