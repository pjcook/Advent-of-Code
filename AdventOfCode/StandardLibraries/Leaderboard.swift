import Foundation

public struct Leaderboard {
    public let ownerID: Int
    public let event: Int
    public let members: [Member]

    public init(ownerID: Int, event: Int, members: [Member]) {
        self.ownerID = ownerID
        self.event = event
        self.members = members
    }
}

public struct Member {
    public let id: Int
    public let stars: Int
    public let name: String
    public let lastStarDateTime: Date?
    public let localScore: Int
    public let globalScore: Int
    public let levels: [Level]
    
    public init(memberID: Int, stars: Int, name: String, lastStarDateTime: Date?, localScore: Int, id: Int, globalScore: Int, levels: [Level]) {
        self.id = id
        self.stars = stars
        self.levels = levels
        self.name = name
        self.lastStarDateTime = lastStarDateTime
        self.localScore = localScore
        self.globalScore = globalScore
    }
}

public struct Level {
    let id: Int
    let star1: Date?
    let star2: Date?
    
    public init(id: Int, star1: Date?, star2: Date?) {
        self.id = id
        self.star1 = star1
        self.star2 = star2
    }
}

extension Leaderboard {
    init(api: API.Leaderboard) {
        self.ownerID = api.ownerID
        self.event = api.event
        self.members = api
            .members
            .map({ $0.value })
            .map(Member.init)
    }
}

extension Member {
    init(api: API.Member) {
        self.stars = api.stars
        self.name = api.name
        self.lastStarDateTime = api.lastStarDateTime
        self.localScore = api.localScore
        self.id = api.id
        self.globalScore = api.globalScore
        self.levels = api.day.map({
            Level(key: $0.key, values: $0.value)
        })
    }
}

extension Level {
    init(key: String, values: [String: API.StarTime]) {
        self.id = Int(key)!
        self.star1 = values["1"]?.datetime
        self.star2 = values["2"]?.datetime
    }
}

enum API {
    struct Leaderboard: Decodable {
        let ownerID: Int
        let event: Int
        let members: [String: Member]
    }
    
    struct Member: Decodable {
        let stars: Int
        let day: [String: [String: StarTime]]
        let name: String
        let lastStarDateTime: Date?
        let localScore: Int
        let id: Int
        let globalScore: Int
    }
    
    struct StarTime: Decodable {
        let datetime: Date
    }
}

extension API.Leaderboard {
    enum CodingKeys: String, CodingKey {
        case ownerID = "owner_id"
        case event
        case members
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ownerID = try Int(values.decode(String.self, forKey: .ownerID))!
        event = try Int(values.decode(String.self, forKey: .event))!
        members = try values.decode([String: API.Member].self, forKey: .members)
    }
}

extension API.Member {
    enum CodingKeys: String, CodingKey {
        case stars
        case day = "completion_day_level"
        case name
        case lastStarDateTime = "last_star_ts"
        case localScore = "local_score"
        case id
        case globalScore = "global_score"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stars = try values.decode(Int.self, forKey: .stars)
        name = (try? values.decode(String.self, forKey: .name)) ?? ""
        localScore = (try? values.decode(Int.self, forKey: .localScore)) ?? 0
        id = (try? Int(values.decode(String.self, forKey: .id))) ?? 0
        globalScore = (try? values.decode(Int.self, forKey: .globalScore)) ?? 0
        if let timestamp = try? values.decode(String.self, forKey: .lastStarDateTime) {
            lastStarDateTime = Date(timeIntervalSince1970: Double(timestamp)! / 1000)
        } else {
            lastStarDateTime = nil
        }
        day = (try? values.decode([String: [String: API.StarTime]].self, forKey: .day)) ?? [:]
    }
}

extension API.StarTime {
    enum CodingKeys: String, CodingKey {
        case datetime = "get_star_ts"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let timestamp = try Double(values.decode(String.self, forKey: .datetime))! / 1000
        datetime = Date(timeIntervalSince1970: timestamp)
    }
}
