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
    public let id: Int
    public let star1: Date?
    public let star2: Date?
    
    public init(id: Int, star1: Date?, star2: Date?) {
        self.id = id
        self.star1 = star1
        self.star2 = star2
    }
}

extension Leaderboard {
    public init(api: API.Leaderboard) {
        self.ownerID = api.ownerID
        self.event = api.event
        self.members = api
            .members
            .map({ $0.value })
            .map(Member.init)
    }
}

extension Member {
    public init(api: API.Member) {
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
    public init(key: String, values: [String: API.StarTime]) {
        self.id = Int(key)!
        self.star1 = values["1"]?.datetime
        self.star2 = values["2"]?.datetime
    }
}

public enum API {
    public struct Leaderboard: Decodable {
        public let ownerID: Int
        public let event: Int
        public let members: [String: Member]
        
        public init(ownerID: Int, event: Int, members: [String : Member]) {
            self.ownerID = ownerID
            self.event = event
            self.members = members
        }
    }
    
    public struct Member: Decodable {
        public let stars: Int
        public let day: [String: [String: StarTime]]
        public let name: String
        public let lastStarDateTime: Date?
        public let localScore: Int
        public let id: Int
        public let globalScore: Int
        
        public init(stars: Int, day: [String : [String : StarTime]], name: String, lastStarDateTime: Date?, localScore: Int, id: Int, globalScore: Int) {
            self.stars = stars
            self.day = day
            self.name = name
            self.lastStarDateTime = lastStarDateTime
            self.localScore = localScore
            self.id = id
            self.globalScore = globalScore
        }
    }
    
    public struct StarTime: Decodable {
        public let datetime: Date
        
        public init(datetime: Date) {
            self.datetime = datetime
        }
    }
}

extension API.Leaderboard {
    enum CodingKeys: String, CodingKey {
        case ownerID = "owner_id"
        case event
        case members
    }
    
    public init(from decoder: Decoder) throws {
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
    
    public init(from decoder: Decoder) throws {
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
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let timestamp = try Double(values.decode(String.self, forKey: .datetime))! / 1000
        datetime = Date(timeIntervalSince1970: timestamp)
    }
}
