import Foundation
import StandardLibraries

public struct Day4 {
    public init() {}
    
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
        
        var count = 0
        for x in (0..<5) {
            for y in (0..<5) {
                let value = board[x][y]
                if value != -1 {
                    count += value
                }
            }
        }
        
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
                    boardsToRemove.append(boards.firstIndex(of: board)!)
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
        
        var count = 0
        for x in (0..<5) {
            for y in (0..<5) {
                let value = board[x][y]
                if value != -1 {
                    count += value
                }
            }
        }
        
        return currentNumber * count
    }
    
    public func callNumber(_ b: Board, currentNumber: Int) -> Board {
        var board = b
        for x in (0..<5) {
            for y in (0..<5) {
                if board[x][y] == currentNumber {
                    board[x][y] = -1
                }
            }
        }
        return board
    }
    
    public func checkBoardForWin(_ board: Board) -> Bool {
        for i in (0..<5) {
            if board[0][i] == -1 && board[1][i] == -1 && board[2][i] == -1 && board[3][i] == -1 && board[4][i] == -1 {
                return true
            }
            if board[i][0] == -1 && board[i][1] == -1 && board[i][2] == -1 && board[i][3] == -1 && board[i][4] == -1 {
                return true
            }
        }
        
        return false
    }
    
    public typealias Board = [[Int]]
    public typealias NumberCalls = [Int]
    public let regex = try! RegularExpression(pattern: "^\\s?(\\d+)\\s+(\\d+)\\s+(\\d+)\\s+(\\d+)\\s+(\\d+)$")
    
    public func parse(_ input: [String]) throws -> (NumberCalls, [Board]) {
        var boards = [Board]()
        let numberCalls = input.first!.components(separatedBy: ",").compactMap(Int.init)
        var i = 2
        
        while i < input.count {
            var board = Board()
            board.append(try parse(input[i]))
            board.append(try parse(input[i+1]))
            board.append(try parse(input[i+2]))
            board.append(try parse(input[i+3]))
            board.append(try parse(input[i+4]))
            i += 6
            boards.append(board)
        }
        
        return (numberCalls, boards)
    }
    
    public func parse(_ input: String) throws -> [Int] {
        let match = try regex.match(input)
        var numbers = [Int]()
        numbers.append(try match.integer(at: 0))
        numbers.append(try match.integer(at: 1))
        numbers.append(try match.integer(at: 2))
        numbers.append(try match.integer(at: 3))
        numbers.append(try match.integer(at: 4))
        return numbers
    }
}
