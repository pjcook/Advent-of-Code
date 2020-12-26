//
//  Day8.swift
//  Year2019
//
//  Created by PJ COOK on 08/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

// https://www.hackingwithswift.com/example-code/language/how-to-split-an-array-into-chunks
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension Collection {
    /// Splits into an array of subsequences each with the given length.
    ///
    /// - Parameter length: Length of each subsequence of the returned array.
    public func split(length: Int) -> [SubSequence] {
        stride(from: 0, to: count, by: length).map {
            let lower = index(startIndex, offsetBy: $0)
            let upper = index(lower, offsetBy: length)
            return self[lower..<upper]
        }
    }
}

public func decodeImageFindMultiplier(_ data: String, size: CGSize) -> Int {
    let layers = data.compactMap { Int(String($0)) }.chunked(into: Int(size.width * size.height))
    var selectedLayer = [Int]()
    var zeroCount = Int.max
    
    for layer in layers {
        let count = layer.filter { $0 == 0 }.count
        if count < zeroCount {
            zeroCount = count
            selectedLayer = layer
        }
    }
    
    let count1 = selectedLayer.filter { $0 == 1 }.count
    let count2 = selectedLayer.filter { $0 == 2 }.count
    return count1 * count2
}

public func renderImage(_ data: String, size: CGSize) {
    let layers = data.compactMap { Int(String($0)) }.chunked(into: Int(size.width * size.height))
    var finalImageData = [Int]()
    
    for i in 0..<Int(size.width * size.height) {
        var found = false
        for layer in layers {
            if [0,1].contains(layer[i]) {
                finalImageData.append(layer[i])
                found = true
                break
            }
        }
        if !found { finalImageData.append(2) }
    }
    
    let imageData = finalImageData.chunked(into: Int(size.width))
    for rowData in imageData {
        var row = ""
        for x in 0..<rowData.count {
            if rowData[x] == 1 {
                row += "◻️"
            } else {
                row += "◼️"
            }
        }
        print("\(row)")
    }
}
