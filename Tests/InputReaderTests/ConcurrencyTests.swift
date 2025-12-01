//
//  ConcurrencyTests.swift
//  AdventOfCode
//
//  Created by PJ on 14/03/2025.
//

import XCTest
import InputReader

public typealias Completion<T> = (Result<T, Swift.Error>) -> Void

class ConcurrencyTests: XCTestCase {
    func test_asyncHandler() async throws {
        let exp = expectation(description: "Testing async concurrency")
        let sut = AsyncHandler()
        var output = ""

        sut.run { result in
            switch result {
            case let .success(value):
                output = value
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        
        await fulfillment(of: [exp])
        XCTAssertEqual(output, "Hello world: 1")
    }
    
    func test_asyncHandler_multipleRequests() async throws {
        let sut = AsyncHandler()
        let results = Results()
        var expectations = [XCTestExpectation]()
        
        for _ in 0..<10 {
            let exp = expectation(description: "Testing async concurrency")
            sut.run { result in
                switch result {
                case let .success(value):
                    Task {
                        await results.append(value)
                        exp.fulfill()
                    }
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                    exp.fulfill()
                }
            }
            expectations.append(exp)
        }
        
        await fulfillment(of: expectations)
        let outputs = await results.results
        for output in outputs {
            XCTAssertEqual(output, "Hello world: 1")
        }
        XCTAssertEqual(10, outputs.count)

        expectations.removeAll()
        await results.clearAll()
        
        for _ in 0..<2 {
            let exp = expectation(description: "Testing async concurrency")
            sut.run { result in
                switch result {
                case let .success(value):
                    Task {
                        await results.append(value)
                        exp.fulfill()
                    }
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                    exp.fulfill()
                }
            }
            expectations.append(exp)
        }
        
        await fulfillment(of: expectations)
        let outputs2 = await results.results
        for output in outputs2 {
            XCTAssertEqual(output, "Hello world: 2")
        }
        XCTAssertEqual(2, outputs2.count)
    }
}

actor Results {
    private var outputs: [String] = []
    
    var results: [String] {
        outputs
    }
    
    func append(_ output: String) {
        outputs.append(output)
    }
    
    func clearAll() {
        outputs.removeAll()
    }
}

final class AsyncHandler {
    private var task: Task<String, Error>?
    private var callCount = 0
    
    func run(callback: @escaping Completion<String>) {
        Task {
            do {
                let result = try await reauthenticate()
                callback(.success(result))
            } catch {
                callback(.failure(error))
            }
        }
    }
    
    private func reauthenticate() async throws -> String {
        if let task {
            return try await task.value
        }
        
        callCount += 1
        let task = Task<String, Error> {
            defer { self.task = nil }
            sleep(1)
            return "Hello world: \(callCount)"
        }
        
        self.task = task
        return try await task.value
    }
}
