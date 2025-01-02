//
//  day19.swift
//  AoC24
//
//  Created by Edward Kish on 12/19/24.
//

import Foundation


func day19(_ raw: String) {
    let chunks = raw.split(separator: "\n\n")
    assert(chunks.count == 2)
    let patterns = chunks[0].split(separator: ", ").map { String($0) }
    let combos = chunks[1].split(separator: "\n").map { String($0) }
    
    // Silver
    func canDesign(_ des: String) -> Int {
        if des.count < 1 { return 0 }
        var possibilities: [String] = []
        for p in patterns {
            if p == des { return 1 }
            if des.starts(with: p) {
                possibilities.append(des.substring(from: p.count, to: des.count))
            }
        }
        for p in possibilities {
            if canDesign(p) == 1 { return 1 }
        }
        return 0
    }
    print("Silver: ", combos.map(canDesign).reduce(0, +))
    
    var M: [String: Int] = [:]
    func ways(_ s: String) -> Int {
        if M.keys.contains(s) { return M[s]! }
        var tot = 0
        for p in patterns {
            if s.starts(with: p) {
                if s == p { tot += 1}
                else { tot += ways(s.substring(from: p.count, to: s.count)) }
            }
        }
        M[s] = tot
        return tot
    }
    print("Gold: ", combos.map(ways).reduce(0, +))
}
