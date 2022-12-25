import Foundation

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

public func pow<T: BinaryInteger>(_ base: T, _ power: T) -> T {
    func expBySq(_ y: T, _ x: T, _ n: T) -> T {
        precondition(n >= 0)
        if n == 0 {
            return y
        } else if n == 1 {
            return y * x
        } else if n.isMultiple(of: 2) {
            return expBySq(y, x * x, n / 2)
        } else { // n is odd
            return expBySq(y * x, x * x, (n - 1) / 2)
        }
    }

    return expBySq(1, base, power)
}
