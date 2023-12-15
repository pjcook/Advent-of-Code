//
//  ASCII+Extensions.swift
//  Year2019
//
//  Created by PJ COOK on 18/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

public extension String {
    func toAscii() -> [Int] {
        var output = [Int]()
        for c in utf8 {
            output.append(Int(c))
        }
        return output
    }
}

public extension Int {
    func toAscii() -> String? {
        guard self >= 0 else { return nil }
        if let us = UnicodeScalar(self) {
            return String(Character(us))
        }
        return nil
    }
}
