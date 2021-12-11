import Foundation
import StandardLibraries

public struct Day4 {
    public init() {}

    public typealias Board = Grid<Int>
    public typealias NumberCalls = [Int]
    
    /*
     Bingo is played on a set of boards each consisting of a 5x5 grid of numbers. Numbers are chosen at random, and the chosen number is marked on all boards on which it appears. (Numbers may not appear on all boards.) If all numbers in any row or any column of a board are marked, that board wins. (Diagonals don't count.)
     
     Loop over all the numbers in the first row of your puzzle input until a board wins (has a full row or column marked).
     
     The score of the winning board can now be calculated. Start by finding the sum of all unmarked numbers on that board; in this case, the sum is 188. Then, multiply that sum by the number that was just called when the board won, 24, to get the final score, 188 * 24 = 4512.
     */
    public func part1(_ input: [String]) throws -> Int {
        // parse the input file to the list of numbers and set of boards
        let (numbers, b) = try parse(input)
        var boards = b
        var gameOver = false
        var index = 0
        var currentNumber = 0
        var winningBoard: Board?
        
        // loop through each number until a board wins
        // ASSUMPTION: there is definitely a winning board !!!
    outerLoop: while !gameOver {
        
            // get the next number
            currentNumber = numbers[index]
            
            // loop over each board to mark the current number if available
            for boardIndex in (0..<boards.count) {
                // mark the current number on the board
                let board = callNumber(boards[boardIndex], currentNumber: currentNumber)
                boards[boardIndex] = board
                
                // Check if board has won
                if checkBoardForWin(board) {
                    // exit as soon as the first board wins
                    gameOver = true
                    winningBoard = board
                    break outerLoop
                }
            }
            
            index += 1
        }
        
        guard let board = winningBoard else { return -1 }
        
        // marking positions on the board set them to -1, so we filter those values out and sum the remainder
        let count = board.items.filter({ $0 != -1 }).reduce(0, +)
        // Then calculate the final score by multiplying the sum of the remainder by the last number called
        return currentNumber * count
    }
    
    /*
     On the other hand, it might be wise to try a different strategy: let the giant squid win.

     You aren't sure how many bingo boards a giant squid could play at once, so rather than waste time counting its arms, the safe thing to do is to figure out which board will win last and choose that one. That way, no matter which boards it picks, it will win for sure.
     */
    public func part2(_ input: [String]) throws -> Int {
        // parse the input file to the list of numbers and set of boards
        let (numbers, b) = try parse(input)
        var boards = b
        var gameOver = false
        var index = 0
        var currentNumber = 0
        var lastBoard: Board?
        
        // loop through each number until only 1 board remains
        while !gameOver {
            // get the next number
            currentNumber = numbers[index]
            
            // We need to store which boards to remove because if we mutate the "boards" array whilst iterating over it the app will crash
            var boardsToRemove = [Int]()
            // We need to check a hasWon property because we only return when the last board wins, not immediately when there is only 1 board remaining.
            var hasWon = false
            
            // loop over each board to mark the current number if available
            for boardIndex in (0..<boards.count) {
                let board = callNumber(boards[boardIndex], currentNumber: currentNumber)
                boards[boardIndex] = board
                
                // Check if board has won
                if checkBoardForWin(board) {
                    boardsToRemove.append(boardIndex)
                    hasWon = true
                }
            }

            // only exit when there is 1 board left AND that board has won
            if boards.count == 1 && hasWon {
                gameOver = true
                lastBoard = boards.first!
            }

            // remove found boards
            for index in boardsToRemove.sorted().reversed() {
                boards.remove(at: index)
            }
            
            index += 1
        }
        
        guard let board = lastBoard else { return -1 }
        
        // marking positions on the board set them to -1, so we filter those values out and sum the remainder
        let count = board.items.filter({ $0 != -1 }).reduce(0, +)
        // Then calculate the final score by multiplying the sum of the remainder by the last number called
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
    
    /*
     Parsing the input file. There is a comma separated list of numbers on the first row, then a blank line, then blocks of 5 rows with 5 numbers on each row.
     */
    public func parse(_ input: [String]) throws -> (NumberCalls, [Board]) {
        var boards = [Board]()
        // process the first line
        let numberCalls = input.first!.components(separatedBy: ",").compactMap(Int.init)
        // variable to point to a row
        var i = 2
        
        // loop until we run out of rows to process
        while i < input.count {
            // I'm lazy so I just grab all 5 rows at once. Because I store grids in a single array instead of 2D array it makes this easier to process
            let items = [input[i], input[i+1], input[i+2], input[i+3], input[i+4]]
                .joined(separator: " ")             // join all 5 rows together into a single string
                .components(separatedBy: " ")       // separate the string into the individual numbers (this automatically ignores double spaces!!)
                .compactMap(Int.init)               // convert the values to Integers
            
            // I increment by 6 to skip the 5 rows we just processed + the blank line
            i += 6
            
            // I append a Board to the array of boards
            boards.append(Board(columns: 5, items: items))
        }
        
        return (numberCalls, boards)
    }
}
