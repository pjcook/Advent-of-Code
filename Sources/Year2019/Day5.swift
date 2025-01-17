//
//  Created by PJ on 16/01/2025.
//

import Foundation
import StandardLibraries

public final class Day5 {
    public init() {}
    
    private var systemID = 1
    
    public func part1(_ input: [Int], code: Int = 1) -> Int {
        systemID = code
        let computer = Computer(forceWriteMode: true)
        computer.delegate = self
        
        computer.loadProgram(input)
        
        while !computer.isFinished {
            computer.tick()
        }
        
        return computer.output ?? -1
    }
}

extension Day5: ComputerDelegate {
    public func processOutput(id: Int, value: Int) {}
    
    public func readInput(id: Int) -> Int { systemID }
    
    public func computerFinished(id: Int) {}
}
