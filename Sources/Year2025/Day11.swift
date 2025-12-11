import Foundation
import StandardLibraries

public final class Day11 {
    public init() {}

    public func part1(_ input: [String]) -> Int {
        let (_, servers) = parse(input, start: "")
        return routes(from: "you", to: "out", servers: servers)
    }

    public func part2(_ input: [String]) -> Int {
        let (_, servers) = parse(input, start: "")
        return routes2(from: "svr", to: "out", servers: servers, isPart2: true)
    }

    struct Server: Hashable {
        let name: String
        let output: [String]

        init(name: String, output: [String]) {
            self.name = name
            self.output = output
        }

        init(_ line: String) {
            let parts = line
                .replacingOccurrences(of: ":", with: "")
                .components(separatedBy: " ")
            self.name = parts[0]
            self.output = Array(parts[1...])
        }
    }
}

extension Day11 {
    func routes(from: String, to: String, servers: [String: Server], isPart2: Bool = false) -> Int {
        let start = servers[from]!
        let match = Set(["fft", "dac"])

        var total = 0
        var queue: [(String, Int)] = []
        for key in start.output {
            queue.append((key, match.contains(key) ? 1 : 0))
        }
        
        while !queue.isEmpty {
            let (serverName, count) = queue.removeFirst()

            guard let server = servers[serverName] else {
                print("FAILED", serverName)
                continue
            }

            for key in server.output {
                if key == to {
                    if isPart2, count == 2 {
                        total += 1
                        print(total, queue.count)
                    } else if !isPart2 {
                        total += 1
                    }
                } else  {
                    let nextCount = count + (match.contains(key) ? 1 : 0)
                    queue.append((key, nextCount))
                    if queue.count % 10000 == 0 {
                        print(total, queue.count)
                    }
                }
            }
        }

        return total
    }

    func routes2(from: String, to: String, servers: [String: Server], isPart2: Bool = false) -> Int {
        let start = servers[from]!
        let match = Set(["fft", "dac"])

        var total = 0
        var queue: [(String, Int)] = []
        for key in start.output {
            queue.append((key, match.contains(key) ? 1 : 0))
        }

        while !queue.isEmpty {
            let (serverName, count) = queue.removeFirst()

            guard let server = servers[serverName] else {
                print("FAILED", serverName)
                continue
            }

            var output = server.output

            if isPart2 {
                if output.contains("dac") {
                    output = ["dac"]
                } else if output.contains("fft") {
                    output = ["fft"]
                }
            }

            for key in output {
                if key == to {
                    if isPart2, count == 2 {
                        total += 1
                        print(total, queue.count)
                    } else if !isPart2 {
                        total += 1
                    }
                } else  {
                    let nextCount = count + (match.contains(key) ? 1 : 0)
                    queue.append((key, nextCount))
                    if queue.count % 10000 == 0 {
                        print(total, queue.count)
                    }
                }
            }
        }

        return total
    }

    func parse(_ input: [String], start: String) -> (Server?, [String: Server]) {
        let allServers = input.map(Server.init)
        var you: Server?
        var servers: [String: Server] = [:]

        for server in allServers {
            if server.name == start {
                you = server
            } else {
                servers[server.name] = server
            }
        }

        while true {
            guard let (serverName, server) = servers.first(where: { $0.1.output.count < 2 && $0.0 != "fft" && $0.0 != "dac" && $0.0 != "you" && $0.0 != "svr" }) else { break }
            servers.removeValue(forKey: serverName)
            let replacementNames = server.output

            for (serverName2, server2) in servers where server2.output.contains(serverName) {
                var output = server2.output
                output.removeAll {
                    $0 == serverName
                }
                output.append(contentsOf: replacementNames)
                servers[serverName2] = Server(name: serverName2, output: output)
            }
        }

        print("Number of servers", servers.count)
        return (you, servers)
    }
}
