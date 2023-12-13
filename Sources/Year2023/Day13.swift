import Foundation
import StandardLibraries

public struct Day13 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let blocks = parse(input)
        return blocks.reduce(0) { $0 + calculateScore(rows: $1.0, cols: $1.1, checkForSmudge: false)}
    }
    
    public func part2(_ input: [String]) -> Int {
        let blocks = parse(input)
        return blocks.reduce(0) { $0 + calculateScore(rows: $1.0, cols: $1.1, checkForSmudge: true)}
    }
    
    typealias Rows = [String]
    typealias Columns = [String]
}

extension Day13 {
    
    
    func calculateScore(rows: Rows, cols: Columns, checkForSmudge: Bool) -> Int {
        if let score = checkRows(cols, checkForSmudge: checkForSmudge, multiplier: 1) {
            return score
        }
        
        if let score = checkRows(rows, checkForSmudge: checkForSmudge, multiplier: 100) {
            return score
        }
        
        assertionFailure("Oops")
        return 0
    }
    
    func checkRows(_ rows: Day13.Rows, checkForSmudge: Bool, multiplier: Int) -> Int? {
        for y in (0..<rows.count-1) {
            if checkDifference(a: rows[y], b: rows[y+1], checkForSmudge: checkForSmudge), validate(rows: rows, index: y, checkForSmudge: checkForSmudge) {
                return (y+1) * multiplier
            }
        }
        return nil
    }
    
    func checkDifference(a: String, b: String, checkForSmudge: Bool) -> Bool {
        guard checkForSmudge else { return a == b }
        return a == b || hasSmudge(a: a, b: b)
    }
    
    func hasSmudge(a: String, b: String) -> Bool {
        a.hammingDistance(with: b) == 1
    }
        
    func validate(rows: Rows, index: Int, checkForSmudge: Bool) -> Bool {
        var differences = 0
        var lower = index
        var upper = index+1
        while lower >= 0 && upper < rows.count {
            if rows[lower] != rows[upper] {
                if checkForSmudge == false {
                    return false
                }
                
                if hasSmudge(a: rows[lower], b: rows[upper]) {
                    differences += 1
                } else {
                    return false
                }

                if differences > 1 {
                    return false
                }
            }
            lower = lower-1
            upper = upper+1
        }
        return checkForSmudge ? differences == 1 : true
    }
}

extension Day13 {
    func parse(_ input: [String]) -> [(Rows, Columns)] {
        var results = [(Rows, Columns)]()
        var rows = [String]()
        
        for row in input {
            guard !row.isEmpty else {
                let cols = calculateColumns(rows)
                results.append((rows, cols))
                rows = []
                continue
            }
            
            rows.append(row)
        }
        
        if rows.count > 0 {
            let cols = calculateColumns(rows)
            results.append((rows, cols))
        }
        
        return results
    }
    
    func calculateColumns(_ rows: [String]) -> Columns {
        var columns = [Int: String]()
        
        for row in rows {
            for x in (0..<row.count) {
                let col = columns[x, default: ""]
                columns[x] = col + row[x]
            }
        }
        
        var results = Columns()
        for x in (0..<columns.count) {
            results.append(columns[x]!)
        }
        return results
    }
}
