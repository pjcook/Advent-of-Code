import Foundation
import StandardLibraries

public struct Day4 {
    public init() {}

    public typealias Board = Grid<Int>
    public typealias NumberCalls = [Int]
    
    public func part1(_ input: [String]) throws -> Int {
        let (numbers, b) = try parse(input)
        var boards = b
        var gameOver = false
        var index = 0
        var currentNumber = 0
        var winningBoard: Board?
        
    outerLoop: while !gameOver {
            currentNumber = numbers[index]
            
            for boardIndex in (0..<boards.count) {
                let board = callNumber(boards[boardIndex], currentNumber: currentNumber)
                boards[boardIndex] = board
                
                // Check if board has won
                if checkBoardForWin(board) {
                    gameOver = true
                    winningBoard = board
                    break outerLoop
                }
            }
            
            index += 1
        }
        
        guard let board = winningBoard else { return -1 }
        
        let count = board.items.filter({ $0 != -1 }).reduce(0, { $0 + $1 })
        return currentNumber * count
    }
    
    public func part2(_ input: [String]) throws -> Int {
        let (numbers, b) = try parse(input)
        var boards = b
        var gameOver = false
        var index = 0
        var currentNumber = 0
        var lastBoard: Board?
        
        while !gameOver {
            currentNumber = numbers[index]
            
            var boardsToRemove = [Int]()
            var hasWon = false
            
            for boardIndex in (0..<boards.count) {
                let board = callNumber(boards[boardIndex], currentNumber: currentNumber)
                boards[boardIndex] = board
                
                // Check if board has won
                if checkBoardForWin(board) {
                    boardsToRemove.append(boardIndex)
                    hasWon = true
                }
            }

            if boards.count == 1 && hasWon {
                gameOver = true
                lastBoard = boards.first!
            }

            for index in boardsToRemove.sorted().reversed() {
                boards.remove(at: index)
            }
            
            index += 1
        }
        
        guard let board = lastBoard else { return -1 }
        
        let count = board.items.filter({ $0 != -1 }).reduce(0, { $0 + $1 })
        return currentNumber * count
    }
    
    public func callNumber(_ b: Board, currentNumber: Int) -> Board {
        var board = b
        if let index = board.items.firstIndex(of: currentNumber) {
            board.items[index] = -1
        }
        return board
    }
    
    public func checkBoardForWin(_ board: Board) -> Bool {
        for i in (0..<5) {
            if board[0,i] == -1 && board[1,i] == -1 && board[2,i] == -1 && board[3,i] == -1 && board[4,i] == -1 {
                return true
            }
            if board[i,0] == -1 && board[i,1] == -1 && board[i,2] == -1 && board[i,3] == -1 && board[i,4] == -1 {
                return true
            }
        }
        
        return false
    }
    
    public func parse(_ input: [String]) throws -> (NumberCalls, [Board]) {
        var boards = [Board]()
        let numberCalls = input.first!.components(separatedBy: ",").compactMap(Int.init)
        var i = 2
        
        while i < input.count {
            let items = [input[i], input[i+1], input[i+2], input[i+3], input[i+4]]
                .joined(separator: " ")
                .replacingOccurrences(of: "  ", with: " ")
                .components(separatedBy: " ")
                .compactMap { $0.isEmpty ? nil : Int($0) }
            
            i += 6
            boards.append(Board(columns: 5, items: items))
        }
        
        return (numberCalls, boards)
    }
}
