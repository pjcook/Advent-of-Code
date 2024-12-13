import Foundation

public extension Int {
    var binary: String {
        String(self, radix: 2)
    }
    
    func binary(padLength: Int, with character: Character = "0") -> String {
        let binary = self.binary
        return String(repeating: character, count: padLength - binary.count) + binary
    }
    
    var isPrime: Bool {
        guard self >= 2     else { return false }
        guard self != 2     else { return true  }
        guard self % 2 != 0 else { return false }
        return !stride(from: 3, through: Int(sqrt(Double(self))), by: 2).contains { self % $0 == 0 }
    }
    
    var length: Int {
        switch self {
        case 0...9: 1
        case 10...99: 2
        case 100...999: 3
        case 1000...9999: 4
        case 10000...99999: 5
        case 100000...999999: 6
        case 1000000...9999999: 7
        case 10000000...99999999: 8
        case 100000000...999999999: 9
        case 1000000000...9999999999: 10
        case 10000000000...99999999999: 11
        case 100000000000...999999999999: 12
        case 1000000000000...9999999999999: 13
        case 10000000000000...99999999999999: 14
        case 100000000000000...999999999999999: 15
        case 1000000000000000...9999999999999999: 16
        case 10000000000000000...99999999999999999: 17
        case 100000000000000000...999999999999999999: 18
        default: -1
        }
    }
    
    var isEven: Bool {
        self % 2 == 0
    }
    
    var isOdd: Bool {
        self % 2 == 1
    }
}

// Function to find gcd (Greatest Common Divisor) of two numbers
public func findGCD(_ num1: Int, _ num2: Int) -> Int {
   var x = 0

   // Finding maximum number
   var y: Int = max(num1, num2)

   // Finding minimum number
   var z: Int = min(num1, num2)

   while z != 0 {
      x = y
      y = z
      z = x % y
    }
   return y
}

// Function to find lcm (Lowest Common Multiple) of two numbers
public func findLCM(n1: Int, n2: Int)->Int{
   return (n1 * n2/findGCD(n1, n2))
}
