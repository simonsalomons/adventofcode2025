//
//  day4.swift
//  
//
//  Created by Simon Salomons on 04/12/2024.
//

import Foundation

func day4() {
    let input = content(file: "input4")

    var grid = input.grid()

    func removeRolls() -> Int {
        var rolls: Set<Pos> = []

        grid.loop { pos, element in
            if element == "@" {
                var rollCount = 0
                for dir in Direction.all {
                    if grid.at(pos + dir) == "@" {
                        rollCount += 1
                    }
                }
                if rollCount < 4 {
                    rolls.insert(pos)
                }
            }
        }

        for roll in rolls {
            grid.set(".", at: roll)
        }

        return rolls.count
    }

    var count = removeRolls()
    var totalCount = count

    print("Part 1:", count) // 1370

    while count > 0 {
        count = removeRolls()
        totalCount += count
    }

    print("Part 2:", totalCount) // 8437
}
