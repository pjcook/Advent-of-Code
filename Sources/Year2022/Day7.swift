//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day7 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let dir = parse(input)
        return part1Traverse(total: 0, dir: dir)
    }
    
    public func part2(_ input: [String], requiredFreeSpace: Int = 30_000_000, fileSystemSize: Int = 70_000_000) -> Int {
        let dir = parse(input)
        let additionalSpaceNeeded = requiredFreeSpace - (fileSystemSize - dir.size)
        var folders = [Dir]()
        part2Traverse(dir: dir, additionalSpaceNeeded: additionalSpaceNeeded, folders: &folders)
        return folders.sorted(by: { $0.size < $1.size }).first!.size
    }
}

extension Day7 {
    public func part1Traverse(total: Int, dir: Dir) -> Int {
        var total = total
        let size = dir.size
        if size <= 100000 {
            total += size
        }
        
        for item in dir.contents where item is Dir {
            total = part1Traverse(total: total, dir: item as! Dir)
        }
        
        return total
    }
    
    public func part2Traverse(dir: Dir, additionalSpaceNeeded: Int, folders: inout [Dir]) {
        if dir.size > additionalSpaceNeeded {
            folders.append(dir)
        }
        
        for item in dir.contents where item is Dir {
            part2Traverse(dir: item as! Dir, additionalSpaceNeeded: additionalSpaceNeeded, folders: &folders)
        }
    }
}

public protocol FolderItem {
    var name: String { get }
    var size: Int { get }
}

extension Day7 {
    public struct File: FolderItem {
        public let name: String
        public let size: Int
        
        public init(name: String, size: Int) {
            self.name = name
            self.size = size
        }
    }
    
    public class Dir: FolderItem {
        public let name: String
        public let parent: Dir?
        public var contents: [FolderItem]
        
        private var calculatedSpace: Int?
        public var size: Int {
            if let calculatedSpace {
                return calculatedSpace
            }
            
            calculatedSpace = contents.reduce(0) {
                $0 + $1.size
            }
            
            return calculatedSpace ?? 0
        }
        
        public init(name: String, parent: Dir?, contents: [FolderItem]) {
            self.name = name
            self.parent = parent
            self.contents = contents
        }
    }
}

extension Day7 {
    public func parse(_ input: [String]) -> Dir {
        let root = Dir(name: "/", parent: nil, contents: [])
        var current = root
        
        for line in input {
            let components = line.components(separatedBy: " ")
            switch components[0] {
            case "$":
                switch components[1] {
                case "cd":
                    switch components[2] {
                    case "/":
                        current = root
                        
                    case "..":
                        if let parent = current.parent {
                            current = parent
                        }
                        
                    default:
                        if let item = current.contents.first(where: { $0.name == components[2] }) as? Dir {
                            current = item
                        } else {
                            let dir = Dir(name: components[1], parent: current, contents: [])
                            current.contents.append(dir)
                            current = dir
                        }
                        
                    }
                    
                case "ls":
                    break
                    
                default: break
                }
                
            case "dir":
                current.contents.append(Dir(name: components[1], parent: current, contents: []))
                
            default:
                current.contents.append(File(name: components[1], size: Int(components[0]) ?? 0))
            }
        }        
        
        return root
    }
}
