//
//  day8.swift
//  AoC24
//
//  Created by Edward Kish on 12/8/24.
//

import Foundation


func silver8(_ raw: String) {
    let lines = raw.split(separator: "\n").map {String($0)}
    var antennas: [String: [(row: Int, col: Int)]] = [:]
    let RLIM = lines.count
    let CLIM = lines[0].count
    for r in 0..<lines.count {
        for c in 0..<lines[r].count{
            let v = lines[r].getChar(at: c)
            if v != "." {
                if antennas.keys.contains(v) {
                    antennas.updateValue(antennas[v]! + [(row: r, col: c)], forKey: v)
                } else {
                    antennas[v] = [((row: r, col: c))]
                }
            }
        }
    }
    print("maxR: \(RLIM)   maxC: \(CLIM)")
    var antinodes: Set<String> = Set()
    for freq in antennas.keys {
        print(freq)
        for i in 0..<antennas[freq]!.count-1 {
            for j in i+1..<antennas[freq]!.count {
                let a1 = antennas[freq]![i]
                let a2 = antennas[freq]![j]
                let dx = a1.col - a2.col
                let dy = a1.row - a2.row
                
                let anti1 = (row: a1.row + dx, col: a1.col + dy)
                let anti2 = (row: a1.row - 2*dx, col: a1.col - 2*dy)
                
                print(a1, a2)
                
                if anti1.row >= 0 && anti1.row <= RLIM && anti1.col >= 0 && anti1.col <= CLIM {
                    antinodes.insert("-\(anti1)-")
                    print("\(anti1) good")
                } else {
                    print("\(anti1) bad")
                }
                if anti2.row >= 0 && anti2.row <= RLIM && anti2.col >= 0 && anti2.col <= CLIM {
                    antinodes.insert("\(anti2)")
                    print("\(anti2) good")
                } else {
                    print("\(anti2) bad")
                }
            }
        }
    }
    print("Silver: \(antinodes.count)")
    print("This doesn't work. Just look at your python solution that actually works.")
    
    
}
