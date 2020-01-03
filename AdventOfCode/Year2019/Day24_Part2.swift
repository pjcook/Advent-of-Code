//
//  Day24_Part2.swift
//  Year2019
//
//  Created by PJ COOK on 02/01/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import Foundation

func day24Part2(bugGrid: BugGrid, iterations: Int) -> Int {
    for _ in 0..<iterations {
//        print("Level", i)
        updateGrid(bugGrid)
        finishProcessing(bugGrid)
//        debugPrint(bugGrid)
    }
    
    return bugCount(bugGrid)
}

private func updateGrid(_ bugGrid: BugGrid) {
    bugGrid.updateData()
    bugGrid.processParent()
    bugGrid.processChild()
}

private func finishProcessing(_ bugGrid: BugGrid) {
    bugGrid.finishProcessing()
    bugGrid.finishProcessingParent()
    bugGrid.finishProcessingChild()
}

private func bugCount(_ bugGrid: BugGrid) -> Int {
//    print("Printing bug count", bugGrid.bugCount)
    return bugGrid.bugCount + bugGrid.parentBugCount + bugGrid.childBugCount
}

private func debugPrint(_ bugGrid: BugGrid) {
    bugGrid.debugPrintChild()
    bugGrid.debugPrint()
    bugGrid.debugPrintParent()
}

extension BugGrid {
    func sample1() {
        e = true
        f = true
        i = true
        k = true
        n = true
        o = true
        r = true
        u = true
    }
    
    func initialise() {
        b = true
        c = true
        d = true
        f = true
        g = true
        n = true
        o = true
        q = true
        s = true
        u = true
        w = true
        y = true
    }
    
    func debugPrint(_ id: Int = 0) {
        print(id)
        var output = ""
        output += a ? "⚪️" : "⚫️"
        output += b ? "⚪️" : "⚫️"
        output += c ? "⚪️" : "⚫️"
        output += d ? "⚪️" : "⚫️"
        output += e ? "⚪️" : "⚫️"
        output += "\n"
        
        output += f ? "⚪️" : "⚫️"
        output += g ? "⚪️" : "⚫️"
        output += h ? "⚪️" : "⚫️"
        output += i ? "⚪️" : "⚫️"
        output += j ? "⚪️" : "⚫️"
        output += "\n"
        
        output += k ? "⚪️" : "⚫️"
        output += l ? "⚪️" : "⚫️"
        output += "🟠"
        output += n ? "⚪️" : "⚫️"
        output += o ? "⚪️" : "⚫️"
        output += "\n"
        
        output += p ? "⚪️" : "⚫️"
        output += q ? "⚪️" : "⚫️"
        output += r ? "⚪️" : "⚫️"
        output += s ? "⚪️" : "⚫️"
        output += t ? "⚪️" : "⚫️"
        output += "\n"
        
        output += u ? "⚪️" : "⚫️"
        output += v ? "⚪️" : "⚫️"
        output += w ? "⚪️" : "⚫️"
        output += x ? "⚪️" : "⚫️"
        output += y ? "⚪️" : "⚫️"
        output += "\n"
        
        print(output)
        print("Count:", bugCount)
    }
    
    func debugPrintParent(_ id: Int = 1) {
        parent?.debugPrint(id)
        parent?.debugPrintParent(id + 1)
    }
    
    func debugPrintChild(_ id: Int = -1) {
        child?.debugPrintChild(id - 1)
        child?.debugPrint(id)
    }
}

class BugGrid {
    private(set) var a = false
    private(set) var b = false
    private(set) var c = false
    private(set) var d = false
    private(set) var e = false

    private(set) var f = false
    private(set) var g = false
    private(set) var h = false
    private(set) var i = false
    private(set) var j = false

    private(set) var k = false
    private(set) var l = false

    private(set) var n = false
    private(set) var o = false

    private(set) var p = false
    private(set) var q = false
    private(set) var r = false
    private(set) var s = false
    private(set) var t = false

    private(set) var u = false
    private(set) var v = false
    private(set) var w = false
    private(set) var x = false
    private(set) var y = false
    
    private(set) var a2 = false
    private(set) var b2 = false
    private(set) var c2 = false
    private(set) var d2 = false
    private(set) var e2 = false

    private(set) var f2 = false
    private(set) var g2 = false
    private(set) var h2 = false
    private(set) var i2 = false
    private(set) var j2 = false

    private(set) var k2 = false
    private(set) var l2 = false

    private(set) var n2 = false
    private(set) var o2 = false

    private(set) var p2 = false
    private(set) var q2 = false
    private(set) var r2 = false
    private(set) var s2 = false
    private(set) var t2 = false

    private(set) var u2 = false
    private(set) var v2 = false
    private(set) var w2 = false
    private(set) var x2 = false
    private(set) var y2 = false
    
    var parent: BugGrid?
    var child: BugGrid?
    
    private var parentH: Bool { return parent?.h ?? false }
    private var parentN: Bool { return parent?.n ?? false }
    private var parentR: Bool { return parent?.r ?? false }
    private var parentL: Bool { return parent?.l ?? false }
    
    private var childTop: Int {
        return
            ((child?.a ?? false) ? 1 : 0) +
            ((child?.b ?? false) ? 1 : 0) +
            ((child?.c ?? false) ? 1 : 0) +
            ((child?.d ?? false) ? 1 : 0) +
            ((child?.e ?? false) ? 1 : 0)
   }
    
    private var childRight: Int {
        return
            ((child?.e ?? false) ? 1 : 0) +
            ((child?.j ?? false) ? 1 : 0) +
            ((child?.o ?? false) ? 1 : 0) +
            ((child?.t ?? false) ? 1 : 0) +
            ((child?.y ?? false) ? 1 : 0)
    }
    
    private var childLeft: Int {
        return
            ((child?.a ?? false) ? 1 : 0) +
            ((child?.f ?? false) ? 1 : 0) +
            ((child?.k ?? false) ? 1 : 0) +
            ((child?.p ?? false) ? 1 : 0) +
            ((child?.u ?? false) ? 1 : 0)
    }
    
    private var childBottom: Int {
        return
            ((child?.u ?? false) ? 1 : 0) +
            ((child?.v ?? false) ? 1 : 0) +
            ((child?.w ?? false) ? 1 : 0) +
            ((child?.x ?? false) ? 1 : 0) +
            ((child?.y ?? false) ? 1 : 0)
    }
    
    var bugCount: Int {
        let count = [a,b,c,d,e,f,g,h,i,j,k,l,n,o,p,q,r,s,t,u,v,w,x,y].reduce(0) { $0 + ($1 ? 1 : 0) }
//        print("Bug count:", count)
        return count
    }
    
    var parentBugCount: Int {
        return (parent?.bugCount ?? 0) + (parent?.parentBugCount ?? 0)
    }
    
    var childBugCount: Int {
        return (child?.bugCount ?? 0) + (child?.childBugCount ?? 0)
    }
    
    func processParent() {
        createParentIfNeeded()
        createChildIfNeeded()
        parent?.updateData()
        parent?.processParent()
    }
    
    func processChild() {
        createParentIfNeeded()
        createChildIfNeeded()
        child?.updateData()
        child?.processChild()
    }
    
    private func count(_ items: [Bool]) -> Int {
        return items.reduce(0) { $0 + ($1 ? 1 : 0) }
    }
    
    func updateData() {
        a2 = isAlive(currentValue: a, count: count([b, f, parentH, parentL]))
        b2 = isAlive(currentValue: b, count: count([a, c, parentH, g]))
        c2 = isAlive(currentValue: c, count: count([b, d, parentH, h]))
        d2 = isAlive(currentValue: d, count: count([c, e, parentH, i]))
        e2 = isAlive(currentValue: e, count: count([d, j, parentH, parentN]))

        f2 = isAlive(currentValue: f, count: count([a, g, k, parentL]))
        g2 = isAlive(currentValue: g, count: count([b, h, f, l]))
        h2 = isAlive(currentValue: h, count: count([c, i, g]) + childTop)
        i2 = isAlive(currentValue: i, count: count([h, j, d, n]))
        j2 = isAlive(currentValue: j, count: count([e, i, o, parentN]))

        k2 = isAlive(currentValue: k, count: count([p, f, l, parentL]))
        l2 = isAlive(currentValue: l, count: count([g, q, k]) + childLeft)

        n2 = isAlive(currentValue: n, count: count([i, s, o]) + childRight)
        o2 = isAlive(currentValue: o, count: count([n, j, t, parentN]))

        p2 = isAlive(currentValue: p, count: count([k, u, q, parentL]))
        q2 = isAlive(currentValue: q, count: count([p, l, v, r]))
        r2 = isAlive(currentValue: r, count: count([q, w, s]) + childBottom)
        s2 = isAlive(currentValue: s, count: count([n, t, x, r]))
        t2 = isAlive(currentValue: t, count: count([o, y, s, parentN]))

        u2 = isAlive(currentValue: u, count: count([p, v, parentL, parentR]))
        v2 = isAlive(currentValue: v, count: count([u, q, w, parentR]))
        w2 = isAlive(currentValue: w, count: count([v, x, r, parentR]))
        x2 = isAlive(currentValue: x, count: count([w, s, y, parentR]))
        y2 = isAlive(currentValue: y, count: count([x, t, parentN, parentR]))
    }
    
    func finishProcessing() {
        a = a2
        b = b2
        c = c2
        d = d2
        e = e2
        f = f2
        g = g2
        h = h2
        i = i2
        j = j2
        k = k2
        l = l2
        n = n2
        o = o2
        p = p2
        q = q2
        r = r2
        s = s2
        t = t2
        u = u2
        w = w2
        v = v2
        x = x2
        y = y2
    }
    
    func finishProcessingParent() {
        parent?.finishProcessing()
        parent?.finishProcessingParent()
    }
    
    func finishProcessingChild() {
        child?.finishProcessing()
        child?.finishProcessingChild()
    }
    
    private func isAlive(currentValue: Bool, count: Int) -> Bool {
        switch currentValue {
        case true: return count == 1
        case false: return [1,2].contains(count)
        }
    }
    
    private func createParentIfNeeded() {
        guard parent == nil else { return }
        guard a || b || c || d || e || j || o || t || y || x || w || v || u || p || k || f  else { return }
        parent = BugGrid()
        parent?.child = self
    }
    
    private func createChildIfNeeded() {
        guard child == nil else { return }
        guard h || n || r || l else { return }
        child = BugGrid()
        child?.parent = self
    }
}
