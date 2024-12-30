//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries
import CryptoKit

public struct Day5 {
    public init() {}
    
    public func part1(_ input: String) -> String {
        var password = ""
        var i = 0
        
        while password.count < 8 {
            i += 1
            let md5 = Insecure.MD5.hash(data: (input + String(i)).data(using: .utf8)!)
            let hash = md5.map { String(format: "%02hhx", $0) }.joined()
            if hash.hasPrefix("00000") {
                password.append(String(hash[5]))
                print(password, i, hash)
            }
//            if i % 10000 == 0 {
//                print(i)
//            }
        }
        
        return password
    }
    
    public func part2(_ input: String) -> String {
        var password = [Int:String]()
        var i = 0
        
        while password.count < 8 {
            i += 1
            let md5 = Insecure.MD5.hash(data: (input + String(i)).data(using: .utf8)!)
            let hash = md5.map { String(format: "%02hhx", $0) }.joined()
            if hash.hasPrefix("00000") {
                guard let index = Int(hash[5]), (0...7).contains(index), password[index] == nil else { continue }
                password[index] = String(hash[6])
                print(password.sorted(by: { $0.key < $1.key }).map({ $0.value }).joined(), i, hash)
            }
            if i % 100000 == 0 {
                print(i)
            }
        }
        
        return password.sorted(by: { $0.key < $1.key }).map({ $0.value }).joined()
    }
}
