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
        var cache = [CacheKey: Int]()
        return dfs("svr", false, false, servers, &cache)
    }

    public func part2b(_ input: [String]) -> Int {
        let (_, servers) = parse(input, start: "")
//        return routes2(from: "svr", to: "out", servers: servers, isPart2: true)
        let graph = createGraph(from: Array(servers.values))
        guard let node = graph["svr"] else { return 0 }
        return route(from: node, fft: false, dac: false, depth: 0, maxDepth: graph.count + 2)
    }

    class Node {
        let name: String
        var children: [Node] = []

        init(_ name: String) {
            self.name = name
        }
    }

    func createGraph(from servers: [Server]) -> [String: Node] {
        var nodes = [String: Node]()

        for server in servers {
            let node = nodes[server.name, default: Node(server.name)]
            var children = [Node]()
            for serverName in server.output {
                let child = nodes[serverName, default: Node(serverName)]
                nodes[child.name] = child
                children.append(child)
            }
            node.children = children
            nodes[node.name] = node
        }

        return nodes
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
    struct CacheKey: Hashable {
        let node: String
        let seenDac: Bool
        let seenFft: Bool

        init(_ node: String, _ seenDac: Bool, _ seenFft: Bool) {
            self.node = node
            self.seenDac = seenDac
            self.seenFft = seenFft
        }
    }
    func dfs(_ node: String, _ seen_dac: Bool, _ seen_fft: Bool, _ adj_list: [String: Server], _ cache: inout [CacheKey: Int]) -> Int {
        if node == "out" {
            return seen_dac && seen_fft ? 1 : 0
        }
        let cacheKey = CacheKey(node, seen_dac, seen_fft)
        if let value = cache[cacheKey] {
            return value
        }

        let is_fft = node == "fft"
        let is_dac = node == "dac"

        var result = 0
        for neighbor in adj_list[node]!.output {
            result += dfs(neighbor, seen_dac || is_dac, seen_fft || is_fft, adj_list, &cache)
        }

        cache[cacheKey] = result
        return result
    }

    func route(from node: Node, fft: Bool, dac: Bool, depth: Int, maxDepth: Int) -> Int {
        guard depth < maxDepth else { return 0 }
        if node.name == "out" {
            return fft && dac ? 1 : 0
        }
        let fft = fft || node.name == "fft"
        let dac = dac || node.name == "dac"
        if dac == true && fft == false { return 0 }

        return node.children.reduce(0) {
            $0 + route(from: $1, fft: fft, dac: dac, depth: depth + 1, maxDepth: maxDepth)
        }
    }

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
