import Foundation

public struct ComponentizedDate {
    
    public let date: Date
    public let year: Int
    public let month: Int
    public let day: Int
    public let hours: Int
    public let minutes: Int
    
    public init(_ date: Date) {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        self.date = date
        self.year = components.year!
        self.month = components.month!
        self.day = components.day!
        self.hours = components.hour!
        self.minutes = components.minute!
    }
}
