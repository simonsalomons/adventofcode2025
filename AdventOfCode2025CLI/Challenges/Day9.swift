//
//  Day9.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 09/12/2024.
//

import Foundation

func day9() {
    let input = content(file: "input9")

    var redLights = input.lines { line in
        let c = line.split(separator: ",")
        return Pos(x: Int(c[0])!,
                   y: Int(c[1])!)
    }

    struct Rectangle {
        let p1: Pos
        let p2: Pos
        let size: Int

        var p3: Pos { Pos(x: p1.x, y: p2.y) }
        var p4: Pos { Pos(x: p2.x, y: p1.y) }
    }

    func cross(_ a: Pos, _ b: Pos) -> Int {
        a.x * b.y - a.y * b.x
    }

    func doesLine(from A: Pos, to B: Pos, intersectWithLineFrom C: Pos, to D: Pos) -> Bool {
        let AB = Pos(x: B.x - A.x, y: B.y - A.y)
        let AC = Pos(x: C.x - A.x, y: C.y - A.y)
        let AD = Pos(x: D.x - A.x, y: D.y - A.y)

        let CD = Pos(x: D.x - C.x, y: D.y - C.y)
        let CA = Pos(x: A.x - C.x, y: A.y - C.y)
        let CB = Pos(x: B.x - C.x, y: B.y - C.y)

        let c1 = cross(AB, AC)
        let c2 = cross(AB, AD)
        let c3 = cross(CD, CA)
        let c4 = cross(CD, CB)

        return (c1.signum() * c2.signum() < 0) && (c3.signum() * c4.signum() < 0)
    }

    func isPos(_ pos: Pos, inside rectangle: Rectangle) -> Bool {
        let minX = min(rectangle.p1.x, rectangle.p2.x)
        let maxX = max(rectangle.p1.x, rectangle.p2.x)
        let minY = min(rectangle.p1.y, rectangle.p2.y)
        let maxY = max(rectangle.p1.y, rectangle.p2.y)

        if pos.x >= minX, pos.x <= maxX,
           pos.y >= minY, pos.y <= maxY {
            return true
        }
        return false
    }

    func arePos(_ p1: Pos, andPos p2: Pos, between p3: Pos, and p4: Pos) -> Bool {
        if p1.x == p2.x, p1.x == p3.x, p1.x == p4.x {
            let minY = min(p3.y, p4.y)
            let maxY = max(p3.y, p4.y)
            return p1.y >= minY && p1.y <= maxY && p2.y >= minY && p2.y <= maxY
        } else if p1.y == p2.y, p1.y == p3.y, p1.y == p4.y {
            let minX = min(p3.x, p4.x)
            let maxX = max(p3.x, p4.x)
            return p1.x >= minX && p1.x <= maxX && p2.x >= minX && p2.x <= maxX
        }
        return false
    }

    func arePos(_ p1: Pos, andPos p2: Pos, onSameBorderOfRectangle rectangle: Rectangle) -> Bool {
        arePos(p1, andPos: p2, between: rectangle.p1, and: rectangle.p3) ||
        arePos(p1, andPos: p2, between: rectangle.p3, and: rectangle.p2) ||
        arePos(p1, andPos: p2, between: rectangle.p2, and: rectangle.p4) ||
        arePos(p1, andPos: p2, between: rectangle.p4, and: rectangle.p1)
    }

    func doesLine(from i1: Pos, to i2: Pos, intersectWithRectangle rectangle: Rectangle) -> Bool {
        if arePos(i1, andPos: i2, onSameBorderOfRectangle: rectangle) {
            return false
        }

        if (isPos(i1, inside: rectangle) &&
            isPos(i2, inside: rectangle)) ||
            doesLine(from: i1, to: i2, intersectWithLineFrom: rectangle.p1, to: rectangle.p3) ||
            doesLine(from: i1, to: i2, intersectWithLineFrom: rectangle.p3, to: rectangle.p2) ||
            doesLine(from: i1, to: i2, intersectWithLineFrom: rectangle.p2, to: rectangle.p4) ||
            doesLine(from: i1, to: i2, intersectWithLineFrom: rectangle.p4, to: rectangle.p1) {
            return true
        }
        return false
    }

    var processedRedLights: [Pos] = []
    var possibleRectangles: [Rectangle] = []

    func rectangleIntersectsWithProcessedRedLights(_ rectangle: Rectangle) -> Bool {
        guard processedRedLights.count > 1 else { return false }

        for i in 0..<processedRedLights.count - 1 {
            let p1 = processedRedLights[i]
            let p2 = processedRedLights[i + 1]

            if rectangle.p1 == p1 || rectangle.p1 == p2 || rectangle.p2 == p1 || rectangle.p2 == p2 {
                continue
            }

            if doesLine(from: p1, to: p2, intersectWithRectangle: rectangle) {
                return true
            }
        }
        return false
    }

    redLights.append(redLights.first!)

    var maxSize = 0
    for p1 in redLights {

        // Remove rectangles that intersect with the new line segment
        if let lastProcessedRedLight = processedRedLights.last {
            possibleRectangles.removeAll { rectangle in
                doesLine(from: p1, to: lastProcessedRedLight, intersectWithRectangle: rectangle)
            }
        }

        // Create rectangles that have this point as a corner with any of the previously used points
        for p2 in processedRedLights {
            let size = (abs(p1.x - p2.x) + 1) * (abs(p1.y - p2.y) + 1)
            maxSize = max(size, maxSize)

            let rectangle = Rectangle(p1: p1, p2: p2, size: size)

            // Only add it if it doesn't intersect with any previous segments
            if !rectangleIntersectsWithProcessedRedLights(rectangle) {
                possibleRectangles.append(rectangle)
            }
        }

        processedRedLights.append(p1)
    }

    print("Part 1:", maxSize) // 4748769124

    let maxSize2 = possibleRectangles.max(by: { $0.size < $1.size })?.size ?? 0

    print("Part 2:", maxSize2) // 1525991432
}
