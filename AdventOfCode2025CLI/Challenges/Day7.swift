//
//  Day7.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 06/12/2024.
//

func day7() {
    let input = content(file: "input7")

    let grid = input.grid()
    let start = grid.first(where: { $1 == "S" })!.0

    var beams: Set<Pos> = [start]
    var splitCount = 0

    while !beams.isEmpty {
        var newBeams: Set<Pos> = []
        var newBeams2: [Pos: Int] = [:]

        func addToBeams2(_ pos: Pos, beamCount: Int) {
            if let count = newBeams2[pos] {
                newBeams2[pos] = count * beamCount
            } else {
                newBeams2[pos] = beamCount
            }
        }

        for beam in beams {
            let nextPos = beam + Direction.down

            switch grid.at(nextPos) {
            case ".":
                newBeams.insert(nextPos)
            case "^":
                newBeams.insert(nextPos + Direction.left)
                newBeams.insert(nextPos + Direction.right)
                splitCount += 1
            case .none:
                break
            default:
                fatalError()
            }
        }

        beams = newBeams
    }

    print("Part 1:", splitCount) // 1539

    var beams2: [Pos: Int] = [start: 1]
    var timelineCount = 1

    while !beams2.isEmpty {
        timelineCount = beams2.values.reduce(0, +)
        var newBeams2: [Pos: Int] = [:]

        func addToBeams2(_ pos: Pos, beamCount: Int) {
            if let count = newBeams2[pos] {
                newBeams2[pos] = count + beamCount
            } else {
                newBeams2[pos] = beamCount
            }
        }

        for (beam, count) in beams2 {
            let nextPos = beam + Direction.down

            switch grid.at(nextPos) {
            case ".":
                addToBeams2(nextPos, beamCount: count)
            case "^":
                addToBeams2(nextPos + Direction.left, beamCount: count)
                addToBeams2(nextPos + Direction.right, beamCount: count)
            case .none:
                break
            default:
                fatalError()
            }
        }

        beams2 = newBeams2
    }

    print("Part 2:", timelineCount) // 6479180385864
}
