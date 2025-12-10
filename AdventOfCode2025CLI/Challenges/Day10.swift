//
//  Day10.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

import Foundation

func day10() {
    var input = content(file: "input10")

//    input = """
//        [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
//        [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
//        [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
//        """

    struct Lights {
        var value: [Int]
        let buttonPresses: Int

        var areAllOff: Bool {
            !value.contains(where: { $0 == 1 })
        }

        enum Mode {
            case toggle
            case addJoltage
        }

        func pressButton(_ button: [Int], mode: Mode) -> Lights {
            var value = value
            switch mode {
            case .toggle:
                for lightIndex in button {
                    switch value[lightIndex] {
                    case 1:
                        value[lightIndex] = 0
                    case 0:
                        value[lightIndex] = 1
                    default:
                        fatalError()
                    }
                }
            case .addJoltage:
                for lightIndex in button {
                    value[lightIndex] += 1
                }
            }
            return Lights(value: value, buttonPresses: buttonPresses + 1)
        }

        func hasJoltages(_ joltages: [Int]) -> Bool {
            value == joltages
        }

        func isOverPowered(_ targetJoltages: [Int]) -> Bool {
            zip(value, targetJoltages).contains(where: { $0.0 > $0.1 })
        }
    }

    struct Machine {
        let lights: Lights
        let buttons: [[Int]]
        let joltages: [Int]
    }

    let machines = input.lines { line in
        var line = line
        line.removeFirst()
        let c1 = line.split(separator: "]")
        let lightConfig = Array(c1[0]).map({ $0 == "#" ? 1 : 0 })
        let c2 = c1[1].split(separator: "{")

        let buttons = c2[0].split(separator: " ", omittingEmptySubsequences: true).map { buttonString in
            var buttonString = buttonString
            buttonString.removeFirst()
            buttonString.removeLast()
            return buttonString.split(separator: ",").map({ Int($0)! })
        }

        var joltageString = c2[1]
        joltageString.removeLast()
        let joltages = joltageString.split(separator: ",").map({ Int($0)! })

        return Machine(lights: Lights(value: lightConfig, buttonPresses: 0), buttons: buttons, joltages: joltages)
    }

    func part1() -> Int {
        var sum = 0
        for machine in machines {
            var lights = [machine.lights]
            bfs: while true {
                var newLights: [Lights] = []
                for light in lights {
                    for button in machine.buttons {
                        let adjustedLights = light.pressButton(button, mode: .toggle)

                        if adjustedLights.areAllOff {
                            sum += adjustedLights.buttonPresses
                            break bfs
                        }
                        newLights.append(adjustedLights)
                    }
                }
                lights = newLights
            }
        }
        return sum
    }

    func part2() -> Int {
        var sum = 0
        for machine in machines {
            var lights = [Lights(value: Array(repeating: 0, count: machine.joltages.count), buttonPresses: 0 )]
            bfs: while true {
                var newLights: [Lights] = []
                for light in lights {
                    for button in machine.buttons {
                        let adjustedLights = light.pressButton(button, mode: .addJoltage)

                        if adjustedLights.value == machine.joltages {
                            sum += adjustedLights.buttonPresses
                            print("Machine done! (\(adjustedLights.buttonPresses))")
                            break bfs
                        }
                        if !adjustedLights.isOverPowered(machine.joltages) {
                            newLights.append(adjustedLights)
                        }
                    }
                }
                lights = newLights
            }
        }
        return sum
    }

//    print("Part 1:", part1()) // 491

    print("Part 2:", part2())
}

