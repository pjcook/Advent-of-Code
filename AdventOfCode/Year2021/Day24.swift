import Foundation
import StandardLibraries

public struct Day24 {
    public init() {}
    
    /*
     So I don't actually think there is a sensible programmatic way to solve this puzzle. The solution to the problem is to look at the input file, figure out that there are 14 sections to the program denoted by the `inp` instructions. Each `inp` instruction would want the next digit from your `modelNumber`.
     
     Looking at the program in detail, you can break it down to see that the program sections are all identical apart from 3 numbers which we will call A, B, C
     
     Variable `A` is effectively the number at the end of line 5 and will be either 1 or 26. These ultimately equate to pops and pushes, more on this later.
     Variable `B` is the value at the end of line 6.
     Variable `C` is the value at the end of line 16.
     
     Draw a grid using these numbers line in the `validate` function below.
     
     You then need to align the pops and pushes by matching the nearest `pop` to the nearest `push`.
     
     In my input below this is:
     
     [01] 1   ---------\
     [02] 1   -------\ |
     [03] 1   -----\ | |
     [04] 1   ---\ | | |
     [05] 1   -\ | | | |
     [06] 26  -/ | | | |
     [07] 1   -\ | | | |
     [08] 26  -/ | | | |
     [09] 26  ---/ | | |
     [10] 26  -----/ | |
     [11] 1   -\     | |
     [12] 26  -/     | |
     [13] 26  -------/ |
     [14] 26  ---------/
     
     The formulas to calculate the correct digits are then:
     [01] + [01.C] + [14.B]    ==>    [01] + 5 - 13 = [14]   ==>   9 + 5 - 13 = 1
     [02] + [02.C] + [13.B]    ==>    [02] + 5 - 2 = [13]    ==>   6 + 5 - 2  = 9
     [03] + [03.C] + [10.B]    ==>    [03] + 1 - 8 = [10]    ==>   9 + 1 - 8  = 2
     [04] + [04.C] + [09.B]    ==>    [04] + 15 - 7 = [09]   ==>   1 + 15 - 7 = 9
     [05] + [05.C] + [06.B]    ==>    [05] + 2 - 1 = [06]    ==>   8 + 2 - 1  = 9
     [06]                                                          9
     [07] + [07.C] + [08.B]    ==>    [07] + 5 - 8 = [08]    ==>   9 + 5 - 8  = 6
     [08]                                                          6
     [09]                                                          9
     [10]                                                          2
     [11] + [11.C] + [12.B]    ==>    [11] + 7 - 2 = [12]    ==>   4 + 7 - 2  = 9
     [12]                                                          9
     [13]                                                          9
     [14]                                                          1
     
     For Part 2, use the above formulas, but try putting the smallest number possible from 1-9 into the `push` positions.
     */
    
    public struct IntALU {
        public var x: Int = 0
        public var y: Int = 0
        public var z: Int = 0
        public init() {}
    }
    
    public func validate(_ input: [Int]) -> Int {
        var alu = IntALU()
        alu = execute(w: input[0], a: 1, b: 11, c: 5, alu: alu)
        alu = execute(w: input[1], a: 1, b: 13, c: 5, alu: alu)
        alu = execute(w: input[2], a: 1, b: 12, c: 1, alu: alu)
        alu = execute(w: input[3], a: 1, b: 15, c: 15, alu: alu)
        alu = execute(w: input[4], a: 1, b: 10, c: 2, alu: alu)
        alu = execute(w: input[5], a: 26, b: -1, c: 2, alu: alu)
        alu = execute(w: input[6], a: 1, b: 14, c: 5, alu: alu)
        alu = execute(w: input[7], a: 26, b: -8, c: 8, alu: alu)
        alu = execute(w: input[8], a: 26, b: -7, c: 14, alu: alu)
        alu = execute(w: input[9], a: 26, b: -8, c: 12, alu: alu)
        alu = execute(w: input[10], a: 1, b: 11, c: 7, alu: alu)
        alu = execute(w: input[11], a: 26, b: -2, c: 14, alu: alu)
        alu = execute(w: input[12], a: 26, b: -2, c: 13, alu: alu)
        alu = execute(w: input[13], a: 26, b: -13, c: 6, alu: alu)
        print(alu.z.formatted())
        return alu.z
    }
    
    public func execute(w: Int, a: Int, b: Int, c: Int, alu: IntALU) -> IntALU {
        var alu = alu
        alu.x = ((alu.z % 26) + b) == w ? 0 : 1
        alu.y = (w + c) * alu.x
        alu.z = (alu.z / a) * (25 * alu.x + 1) + alu.y
        print(w, a, b, c, alu.x, alu.y, alu.z)
        return alu
    }
}
