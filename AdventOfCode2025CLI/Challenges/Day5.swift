//
//  day5.swift
//  
//
//  Created by Simon Salomons on 05/12/2024.
//

import Foundation

func day5() {
    let input = content(file: "input5")

    let inputs = input.split(separator: "\n\n")
    let input1 = inputs[0]
    let input2 = inputs[1]

    var ranges = input1.lines({ line in
        let c = line.split(separator: "-")
        let min = Int(c[0])!
        let max = Int(c[1])!

        return min...max
    })
    let ids = input2.lines({ Int($0)! })

    let fresh = ids.count(where: { id in ranges.contains(where: { $0.contains(id) }) })

    print("Part 1:", fresh) // 720

    var nonOverlappingRanges: [ClosedRange<Int>] = []
    while !ranges.isEmpty {
        var range = ranges.removeFirst()
        var addRange = true
        otherRangeLoop: for otherRange in nonOverlappingRanges {
            if range.overlaps(otherRange) {
                if range.lowerBound < otherRange.lowerBound && range.upperBound <= otherRange.upperBound {
                    range = range.lowerBound...otherRange.lowerBound - 1
                } else if otherRange.lowerBound <= range.lowerBound && otherRange.upperBound < range.upperBound {
                    range = (otherRange.upperBound + 1)...range.upperBound
                } else if range.lowerBound <= otherRange.lowerBound && range.upperBound > otherRange.upperBound {
                    ranges.append((otherRange.upperBound + 1)...range.upperBound)
                    range = range.lowerBound...otherRange.lowerBound - 1
                } else {
                    addRange = false
                    break otherRangeLoop
                }
            }
        }
        if addRange {
            nonOverlappingRanges.append(range)
        }
    }
    let allFreshIdsCount = nonOverlappingRanges.reduce(into: 0, { $0 += $1.count })

    print("Part 2:", allFreshIdsCount) // 357608232770687
}
