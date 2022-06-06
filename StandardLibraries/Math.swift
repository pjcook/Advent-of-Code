public func radiansToDegrees(_ number: Double) -> Double {
    return number * 180 / .pi
}

public func degreesToRadians(_ number: Double) -> Double {
    return number * .pi / 180
}

extension Double {
    public func mod(_ value: Double) -> Double {
        self - floor(self / value) * value
    }
}

extension Decimal {
    public func mod(_ value: Decimal) -> Decimal {
        var d = self / value
        var f: Decimal = 0
        NSDecimalRound(&f, &d, 0, .down)
        return self - value * f
    }
    
    public func round(to dp: Int) -> Decimal {
        var f: Decimal = 0
        var d = self
        NSDecimalRound(&f, &d, dp, .down)
        return f
    }
}
