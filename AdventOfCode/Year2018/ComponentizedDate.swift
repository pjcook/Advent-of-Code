import Foundation

public struct ComponentizedDate {
    
    let date: Date
    let year: Int
    let month: Int
    let day: Int
    let hours: Int
    let minutes: Int
    
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
