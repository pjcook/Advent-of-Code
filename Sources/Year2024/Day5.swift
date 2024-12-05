import Foundation
import StandardLibraries

struct Rule {
    let first: Int
    let second: Int
    let ruleSet: Set<Int>
    
    init(first: Int, second: Int) {
        self.first = first
        self.second = second
        ruleSet = Set([first, second])
    }
}

struct Pages: Equatable {
    let pages: [Int]
    let pageSet: Set<Int>
    let middle: Int
    
    init(pages: [Int]) {
        self.pages = pages
        pageSet = Set(pages)
        middle = pages[pages.count / 2]
    }
}

public struct Day5 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        var (rules, pages) = parse(input)
        
        for rule in rules {
            for page in pages where page.pageSet.isSuperset(of: rule.ruleSet) {
                let index1 = page.pages.firstIndex(of: rule.first)!
                let index2 = page.pages.firstIndex(of: rule.second)!
                if index2 < index1 {
                    pages.remove(at: pages.firstIndex(where: { $0 == page })!)
                }
            }
        }
        
        return pages.reduce(0) { $0 + $1.middle }
    }
    
    public func part2(_ input: [String]) -> Int {
        var (rules, pages) = parse(input)
        var invalidPages: [Pages] = []
        
        // find invalid pages
        for rule in rules {
            for page in pages where page.pageSet.isSuperset(of: rule.ruleSet) {
                let index1 = page.pages.firstIndex(of: rule.first)!
                let index2 = page.pages.firstIndex(of: rule.second)!
                if index2 < index1 {
                    invalidPages.append(page)
                    pages.remove(at: pages.firstIndex(where: { $0 == page })!)
                }
            }
        }
        
        // fix invalid pages
        var result = 0
        for page in invalidPages {
            let pageRules = rules.filter { $0.ruleSet.isSubset(of: page.pageSet) }
            let fixedPage = fixPage(page: page, with: pageRules)
            result += fixedPage[fixedPage.count / 2]
        }
        
        return result
    }
}

extension Day5 {
    func fixPage(page: Pages, with rules: [Rule]) -> [Int] {
        var pages = page.pages
        
        while !isValid(page: pages, rules: rules) {
            for rule in rules {
                let index1 = pages.firstIndex(of: rule.first)!
                let index2 = pages.firstIndex(of: rule.second)!
                if index2 < index1 {
                    let val1 = pages[index1]
                    let val2 = pages[index2]
                    pages[index1] = val2
                    pages[index2] = val1
                }
            }
        }
        
        return pages
    }
    
    func isValid(page: [Int], rules: [Rule]) -> Bool {
        for rule in rules {
            let index1 = page.firstIndex(of: rule.first)!
            let index2 = page.firstIndex(of: rule.second)!
            if index2 < index1 {
                return false
            }
        }
        
        return true
    }
    
    func parse(_ input: [String]) -> ([Rule], [Pages]) {
        var rules: [Rule] = []
        var pages: [Pages] = []
        var foundPages = false

        for line in input {
            if line.isEmpty {
                foundPages = true
                continue
            }
            
            if !foundPages {
                let components = line.split(separator: "|")
                rules.append(Rule(first: Int(components[0])!, second: Int(components[1])!))
            } else {
                pages.append(Pages(pages: line.split(separator: ",").map({ Int($0)! })))
            }
        }
        
        return (rules, pages)
    }
}
