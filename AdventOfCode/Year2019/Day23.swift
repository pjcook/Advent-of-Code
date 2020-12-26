//
//  Day23.swift
//  Year2019
//
//  Created by PJ COOK on 01/01/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import Foundation

public class ShipNetwork {
    private var computers = [Int:NetworkComputer]()
    private let numberOfComputers: Int
    private let natQueue = DispatchQueue(label: "NAT")
    public var finalOutput = 0
    public let group = DispatchGroup()
    public var queues = [DispatchQueue]()
    public var isPart1 = true

    public init(_ input: [Int], numberOfComputers: Int) {
        self.numberOfComputers = numberOfComputers
        for i in 0..<numberOfComputers {
            let computer = NetworkComputer(input, id: i, network: self)
            computers[i] = computer
        }
    }
    
    public func process() {
        computers.forEach { item in
            let queue = DispatchQueue(label: String(item.value.id))
            queue.async {
                item.value.enterGroup(self.group)
                item.value.process()
            }
            queues.append(queue)
        }
        
        group.wait()
    }
    
    private func stopNetworkComputers() {
        for queue in queues {
            queue.suspend()
        }
        for item in computers {
            item.value.leaveGroup(group)
        }
    }
    
    public var x = 0
    public var y = 0
    public func sendMessage(address: Int, x: Int, y: Int) {
//        print("sendMessage", address, x, y)
        if isPart1 && address == 255 {
            finalOutput = y
            stopNetworkComputers()
        } else if !isPart1 && address == 255 {
            self.x = x
            self.y = y
//            print("sendMessage", address, x, y)
        }
        guard let computer = computers[address] else { return }
        computer.addInput(x: x, y: y)
    }
    
    private func isAllQueuesEmpty() -> Bool {
        return computers.reduce(0, { $0 + ($1.value.hasInputs ? 1 : 0) }) == 0
    }
    
    private func isNetworkIdle() -> Bool {
        if idleComputers.count != numberOfComputers { return false }
        return idleComputers.reduce(0, { $0 + ($1.value > 1 ? 1 : 0) }) == numberOfComputers
    }
    
    private var idleComputers = [Int:Int]()
    private var sentByNat = [Int:Int]()
    public func readingEmptyInput(_ id: Int) {
        natQueue.async {
            self.idleComputers[id] = (self.idleComputers[id, default: 0]) + 1
            if self.isNetworkIdle() && self.y != 0 {
                self.idleComputers.removeAll()
                self.sendMessage(address: 0, x: self.x, y: self.y)
                let count = (self.sentByNat[self.y, default: 0]) + 1
                if count > 1 {
                    self.finalOutput = self.y
                    self.stopNetworkComputers()
                }
                self.sentByNat[self.y] = count
            }
        }
    }
    
    public func computerFinished(address: Int) {
        guard let computer = computers[address] else { return }
        computer.leaveGroup(group)
        computers.removeValue(forKey: address)
    }
}

public class NetworkComputer {
    private var computer: SteppedIntComputer?
    private var inputs = [Int]()
    private var outputs = [Int]()
    private let network: ShipNetwork
    
    public var id: Int { return computer!.id }
    public var hasInputs: Bool { return !inputs.isEmpty }
    
    public init(_ input: [Int], id: Int, network: ShipNetwork) {
        self.network = network
        inputs.append(id)
        computer = SteppedIntComputer(
            id: id,
            data: input,
            readInput: readInput,
            processOutput: processOutput,
            completionHandler: completionHandler,
            forceWriteMode: false
        )
    }
    
    public func process() {
        computer?.process()
    }
    
    public func addInput(x: Int, y: Int) {
        inputs.append(x)
        inputs.append(y)
    }
    
    public func enterGroup(_ group: DispatchGroup) {
        group.enter()
    }
    
    public func leaveGroup(_ group: DispatchGroup) {
        group.leave()
    }
    
    private func readInput() -> Int {
//        print(computer!.id, "readInput:", inputs)
        guard !inputs.isEmpty else {
            network.readingEmptyInput(computer!.id)
            return -1
        }
        return inputs.removeFirst()
    }
    
    private func processOutput(_ value: Int) {
//        print(computer!.id, "output:", value)
        outputs.append(value)
        if outputs.count == 3 {
            let address = outputs.removeFirst()
            let x = outputs.removeFirst()
            let y = outputs.removeFirst()
            network.sendMessage(address: address, x: x, y: y)
        }
    }
    
    private func completionHandler() {
//        print("[\(computer!.id)] FINISHED\n")
        network.computerFinished(address: computer!.id)
    }
}
