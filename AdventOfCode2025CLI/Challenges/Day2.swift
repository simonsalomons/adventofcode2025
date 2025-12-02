//
//  day2.swift
//  
//
//  Created by Simon Salomons on 04/12/2024.
//

import Foundation

func day2() {
    let input = content(file: "input2")

    let ranges = input.components(separatedBy: ",").map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })

    var invalidIds: Set<Int> = []

    func part1() -> Int {
        for range in ranges {
            let c = range.components(separatedBy: "-")
            let min = Int(c[0])!
            let max = Int(c[1])!

            for id in min...max {
                let string = String(id)
                let length = string.count

                guard length % 2 == 0 else { continue }

                let midIndex = string.index(string.startIndex, offsetBy: length / 2)
                let start = string[string.startIndex..<midIndex]
                let end = string[midIndex..<string.endIndex]
                if start == end {
                    invalidIds.insert(id)
                }
            }
        }

        return invalidIds.reduce(into: 0, +=) // 15873079081
    }

    func part2() -> Int {
        var invalidIds: Set<Int> = []

        for range in ranges {
            let c = range.components(separatedBy: "-")
            let min = Int(c[0])!
            let max = Int(c[1])!

            for id in min...max {
                let string = String(id)
                let length = string.count

                guard !invalidIds.contains(id),
                      length > 1 else {
                    continue
                }

                for i in 1...length / 2 where length % i == 0 {
                    let subIndex = string.index(string.startIndex, offsetBy: i)
                    let subString = string[string.startIndex..<subIndex]
                    var newString = subString
                    repeat {
                        newString += subString
                    } while newString.count < length

                    if newString == string {
                        invalidIds.insert(id)
                    }
                }
            }
        }

        return invalidIds.reduce(into: 0, +=)
    }


    print("Part 1", part1()) // 15873079081
    print("Part 2", part2()) // 22617871034
}
