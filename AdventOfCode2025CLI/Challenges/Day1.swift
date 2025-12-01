//
//  day1.swift
//  
//
//  Created by Simon Salomons on 04/12/2024.
//

import Foundation

func day1() {

    let input = content(file: "input1")

    let lines = input.lines({ String($0) })

    var value = 50
    var count1 = 0
    var count2 = 0
    for var line in lines {
        switch line.removeFirst() {
        case "L":
            if value == 0 {
                count2 -= 1
            }
            value -= Int(line)!
            while value < 0 {
                value += 100
                count2 += 1
            }
            if value == 0 {
                count2 += 1
            }
        case "R":
            value += Int(line)!
            while value > 99 {
                value -= 100
                count2 += 1
            }
        default:
            fatalError()
        }

        if value == 0 {
            count1 += 1
        }
    }
    print("Part1:", count1) // 1011
    print("Part2:", count2) // 5937
}
