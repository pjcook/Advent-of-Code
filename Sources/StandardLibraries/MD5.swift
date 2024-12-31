//
//  File.swift
//  AdventOfCode
//
//  Created by PJ on 31/12/2024.
//

import CryptoKit

public func generateMD5Hash(for value: String) -> String {
    let md5 = Insecure.MD5.hash(data: value.data(using: .utf8)!)
    return md5.map { String(format: "%02hhx", $0) }.joined()
}
