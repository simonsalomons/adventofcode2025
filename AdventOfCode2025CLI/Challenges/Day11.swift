//
//  Day11.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

func day11() {
    let input = content(file: "input11")

    var devices: [String: [String]] = [:]
    for line in input.lines() {
        let c = line.split(separator: ":")
        let name = String(c[0])
        let outputs = c[1].split(separator: " ", omittingEmptySubsequences: true).map({ String($0) })
        devices[name] = outputs
    }

    struct CacheKey: Hashable {
        let device: String
        let destination: String
        let ignore: String?
    }

    var cache: [CacheKey: Int] = [:]
    func getPathCount(from device: String, to destination: String, ignore: String? = nil) -> Int {
        guard device != "out" else { return 0 }

        let cacheKey = CacheKey(device: device, destination: destination, ignore: ignore)

        if let cached = cache[cacheKey] {
            return cached
        }

        let outputs = devices[device]!

        var count = 0
        for output in outputs {
            if output != destination {
                if let ignore {
                    guard output != ignore else { continue }
                }
                count += getPathCount(from: output, to: destination, ignore: ignore)
            } else {
                count += 1
            }
        }
        cache[cacheKey] = count
        return count
    }

    print("Part 1:", getPathCount(from: "you", to: "out")) // 543

    let svrToFft = getPathCount(from: "svr", to: "fft", ignore: "dac")
    let fftToDac = getPathCount(from: "fft", to: "dac")
    let dacToOut = getPathCount(from: "dac", to: "out")

    // There are no paths from svr to dac to fft to out because that would create infinite loops

    let svrFftDacCount = svrToFft * fftToDac * dacToOut

    print("Part 2:", svrFftDacCount) // 479511112939968
}
