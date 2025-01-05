//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day20 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let particles = parse(input)
        var smallest: Int = Int.max
        var smallestParticle: Int = 0

        for p in 0..<particles.count {
            var particle = particles[p]
            for i in 0..<1000 {
                particle = Particle(position: particle.position + particle.velocity + particle.acceleration, velocity: particle.velocity + particle.acceleration, acceleration: particle.acceleration)
            }
            let dx = particle.position.manhattanDistance(to: .zero)
            if dx < smallest {
                smallest = dx
                smallestParticle = p
                smallest = min(smallest, dx)
                print(smallestParticle, smallest)
            }
                
        }
        
        return smallestParticle
    }
    
    public func part2(_ input: [String]) -> Int {
        var particles = parse(input)
        var i: Int = 0
        var lastCollision: Int = 0
        
        while true {
            var seen = Set<Vector>()
            
            for p in (0..<particles.count).reversed() {
                var particle = particles[p]
                particle = Particle(position: particle.position + particle.velocity + particle.acceleration, velocity: particle.velocity + particle.acceleration, acceleration: particle.acceleration)
                if seen.contains(particle.position) {
                    particles.remove(at: p)
                    for i in p..<particles.count {
                        if particles[i].position == particle.position {
                            particles.remove(at: i)
                            break
                        }
                    }
                    lastCollision = i
                } else {
                    particles[p] = particle
                }
                seen.insert(particle.position)
            }
            
            i += 1
            if i - lastCollision > 1000 {
                break
            }
        }

        return particles.count
    }
    
    struct Particle {
        let position: Vector
        let velocity: Vector
        let acceleration: Vector
        
        init(position: Vector, velocity: Vector, acceleration: Vector) {
            self.position = position
            self.velocity = velocity
            self.acceleration = acceleration
        }
        
        init(_ input: String) {
            let values = input
                .replacingOccurrences(of: "<", with: "")
                .replacingOccurrences(of: ">", with: "")
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "=", with: "")
                .replacingOccurrences(of: "p", with: "")
                .replacingOccurrences(of: "v", with: "")
                .replacingOccurrences(of: "a", with: "")
                .split(separator: ",")
                .map(String.init)
                .compactMap(Int.init)
            position = Vector(x: values[0], y: values[1], z: values[2])
            velocity = Vector(x: values[3], y: values[4], z: values[5])
            acceleration = Vector(x: values[6], y: values[7], z: values[8])
        }
    }
}

extension Day20 {
    func parse(_ input: [String]) -> [Particle] {
        input.map(Particle.init)
    }
}
