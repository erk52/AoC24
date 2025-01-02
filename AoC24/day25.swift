//
//  day25.swift
//  AoC24
//
//  Created by Edward Kish on 12/25/24.
//

import Foundation


func day25(_ raw: String) {
    let schematics = raw.split(separator: "\n\n").map { String($0) }
    var locks: [[Int]] = []
    var keys: [[Int]] = []
    
    for s in schematics {
        let grid = s.split(separator: "\n").map { String($0)}
        var cols = Array(repeating: -1, count: grid[0].count)
        if s.starts(with: "#####") {
            for r in 0..<grid.count{
                for c in 0..<grid[r].count {
                    if grid[r].getChar(at: c) == "#" {
                        cols[c] += 1
                    }
                }
            }
            locks.append(cols)
        } else {
            for r in stride(from: grid.count-1, to: -1, by: -1) {
                for c in 0..<grid[r].count {
                    if grid[r].getChar(at: c) == "#" {
                        cols[c] += 1
                    }
                }
            }
            keys.append(cols)
        }
    }
    var winners = 0
    for l in locks {
        for k in keys {
            for i in 0..<k.count {
                if l[i] + k[i] >= 6 {
                    winners -= 1
                    break
                }
            }
            winners += 1
        }
    }
    print("HO HO HO! Day 25: ", winners)
}
