//
//  day3.swift
//  
//
//  Created by Simon Salomons on 04/12/2024.
//

import Foundation

func day3() {
    let input = content(file: "input3")

    let lines = input.lines()

    func getVoltage(numberOfBatteries: Int) -> Int {
        var sum = 0
        for line in lines {
            var batteryIndex = line.startIndex
            var voltage = ""
            for b in (0..<numberOfBatteries).reversed() {
                let endIndex = line.index(line.endIndex, offsetBy: -b)
                let sub = line[batteryIndex..<endIndex]
                let max = sub.max(by: { $0 < $1 })!
                batteryIndex = line.index(after: sub.firstIndex(of: max)!)
                voltage += "\(max)"
            }
            sum += Int(voltage)!
        }
        return sum
    }

    print("Part1:", getVoltage(numberOfBatteries: 2)) // 17324
    print("Part2:", getVoltage(numberOfBatteries: 12)) // 171846613143331
}
