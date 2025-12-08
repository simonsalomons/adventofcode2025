//
//  Day8.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 08/12/2024.
//

import Foundation

func day8() {
    let input = content(file: "input8")
    let connections = 1_000

    struct Coord: Equatable, Hashable, CustomDebugStringConvertible {
        let x: Int
        let y: Int
        let z: Int

        var debugDescription: String {
            "{\(x),\(y),\(z)}"
        }
    }

    let coords = input.lines { line in
        let c = line.split(separator: ",")
        return Coord(x: Int(c[0])!,
                     y: Int(c[1])!,
                     z: Int(c[2])!)
    }

    struct Distance {
        let value: Double
        let c1: Coord
        let c2: Coord
    }

    var distances: [Distance] = []

    for i1 in 0..<(coords.count - 1) {
        for i2 in i1 + 1..<coords.count {
            let c1 = coords[i1]
            let c2 = coords[i2]
            let x = pow(Double(c2.x) - Double(c1.x), 2)
            let y = pow(Double(c2.y) - Double(c1.y), 2)
            let z = pow(Double(c2.z) - Double(c1.z), 2)
            let distance = sqrt(x + y + z)
            distances.append(Distance(value: distance, c1: c1, c2: c2))
        }
    }

    distances.sort(by: { $0.value < $1.value })

    var circuits: [Set<Coord>] = []

    func makeConnection() -> Distance {
        let distance = distances.removeFirst()
        let circuit1Index: Int? = circuits.firstIndex(where: { $0.contains(distance.c1) })
        let circuit2Index: Int? = circuits.firstIndex(where: { $0.contains(distance.c2) })

        if let circuit1Index,
           let circuit2Index {
            if circuit1Index != circuit2Index {
                let newCircuit = circuits[circuit1Index].union(circuits[circuit2Index])
                circuits.remove(at: max(circuit1Index, circuit2Index))
                circuits.remove(at: min(circuit1Index, circuit2Index))
                circuits.append(newCircuit)
            } else {
                // Already in same circuit
            }
        } else if let circuit1Index {
            circuits[circuit1Index].insert(distance.c2)
        } else if let circuit2Index {
            circuits[circuit2Index].insert(distance.c1)
        } else {
            circuits.append([distance.c1, distance.c2])
        }

        return distance
    }

    for _ in 0..<connections {
        _ = makeConnection()
    }

    circuits.sort(by: { $0.count > $1.count })
    var total = 1
    for i in 0..<3 {
        total *= circuits[i].count
    }

    print("Part 1:", total) // 54180

    connector: while true {
        let distance = makeConnection()

        if circuits.first!.count == coords.count {
            print("Part 2:", distance.c1.x * distance.c2.x) // 25325968
            break connector
        }
    }
}
