//
//  day6.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 06/12/2024.
//

import Foundation

func day6() {
    let input = content(file: "input6")

    func perform(operands: [Int], operator op: Substring.SubSequence) -> Int {
        switch op {
        case "+":
            return operands.reduce(0, +)
        case "*":
            return operands.reduce(1, *)
        default:
            fatalError()
        }
    }

    var lines = input.lines()
    var operators = lines.removeLast().split(separator: " ", omittingEmptySubsequences: true)
    let operands = lines.map({ line in
        line.split(separator: " ", omittingEmptySubsequences: true).map({ Int($0)! })
    })

    var sum = 0
    for (index, op) in operators.enumerated() {
        let operands = operands.map({ $0[index] })
        sum += perform(operands: operands, operator: op)
    }

    print("Part 1:", sum)

    var operands2: [Int] = []
    var sum2 = 0

    for i in (0..<lines.first!.count).reversed() {
        var string = ""
        for line in lines {
            let index = line.index(line.startIndex, offsetBy: i)
            string += line[index..<line.index(after: index)]
        }
        if let operand = Int(string.trimmingCharacters(in: .whitespaces)) {
            operands2.append(operand)
        } else {
            sum2 += perform(operands: operands2, operator: operators.removeLast())
            operands2.removeAll()
        }
    }
    sum2 += perform(operands: operands2, operator: operators.removeLast())

    print("Part 2:", sum2)
}
