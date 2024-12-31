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

public struct Day14 {
    public init() {}
    
    public func part1(_ input: String) -> Int {
        var hashes = [String]()
        var parsedHashes = [String: [String: Int]]()
        var keys = [String]()
        var lastIndex = 0
        var pointer = 0
        
        while pointer < Int.max {
            var hash = ""
            if pointer >= hashes.count {
                hash = generateHash(value: input + String(pointer))
                hashes.append(hash)
                parsedHashes[hash] = check(hash: hash)
            } else {
                hash = hashes[pointer]
            }

            let checked = parsedHashes[hash]!
            if checked.count > 0 {
                innerLoop: for i in 1...1000 {
                    let nextIndex = pointer + i
                    
                    var hash2 = ""
                    if nextIndex >= hashes.count {
                        hash2 = generateHash(value: input + String(nextIndex))
                        hashes.append(hash2)
                        parsedHashes[hash2] = check(hash: hash2)
                    } else {
                        hash2 = hashes[nextIndex]
                    }
                    let checked2 = parsedHashes[hash2]!
                    for key in checked.keys {
                        if let value = checked2[key] {
                            if value == 5 {
                                keys.append(hash)
                                if keys.count == 64 {
                                    lastIndex = pointer
                                    return pointer
                                }
                                break innerLoop
                            }
                        }
                    }
                }
            }
            
            pointer += 1
        }
        
        return lastIndex
    }
    
    public func part2(_ input: String) -> Int {
        var hashes = [String]()
        var parsedHashes = [String: [String: Int]]()
        var keys = [String]()
        var lastIndex = 0
        var pointer = 0
        
        while pointer < Int.max {
            var hash = ""
            if pointer >= hashes.count {
                hash = stretch(generateHash(value: input + String(pointer)))
                hashes.append(hash)
                parsedHashes[hash] = check(hash: hash)
            } else {
                hash = hashes[pointer]
            }

            let checked = parsedHashes[hash]!
            if checked.count > 0 {
                innerLoop: for i in 1...1000 {
                    let nextIndex = pointer + i
                    
                    var hash2 = ""
                    if nextIndex >= hashes.count {
                        hash2 = stretch(generateHash(value: input + String(nextIndex)))
                        hashes.append(hash2)
                        parsedHashes[hash2] = check(hash: hash2)
                    } else {
                        hash2 = hashes[nextIndex]
                    }
                    let checked2 = parsedHashes[hash2]!
                    for key in checked.keys {
                        if let value = checked2[key] {
                            if value == 5 {
                                keys.append(hash)
                                if keys.count == 64 {
                                    lastIndex = pointer
                                    return pointer
                                }
                                break innerLoop
                            }
                        }
                    }
                }
            }
            
            pointer += 1
            if pointer % 1000 == 0 {
                print(pointer, Date(), keys.count, hashes.count, parsedHashes.count)
            }
        }
        
        return lastIndex
    }
}

extension Day14 {
    func stretch(_ value: String) -> String {
        var value = value
        for _ in 0..<2016 {
            value = generateHash(value: value)
        }
        return value
    }
    
    func generateHash(value: String) -> String {
        let md5 = Insecure.MD5.hash(data: value.data(using: .utf8)!)
        return md5.map { String(format: "%02hhx", $0) }.joined()
    }
    
    func check(hash: String) -> [String: Int] {
        var i = 2
        var results = [String: Int]()
        
        while i < hash.count {
            let a = hash[i-2]
            let b = hash[i-1]
            if a == b {
                let c = hash[i]
                if a == c {
                    if results.isEmpty {
                        results[String(a)] = max(3, results[String(a), default: 0])
                    }
                    
                    if i >= 5 {
                        let d = hash[i-3]
                        if a == d {
                            let e = hash[i-4]
                            if a == e {
                                results[String(a)] = max(5, results[String(a), default: 0])
                            }
                        }
                    }
                }
            }

            i += 1
        }
        
        return results
    }
}
