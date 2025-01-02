//
//  day22.swift
//  AoC24
//
//  Created by Edward Kish on 12/22/24.
//

import Foundation


func evolve(secret: Int) -> Int {
    var val = secret * 64
    var secret = val ^ secret
    secret = secret % 16777216
    val = secret / 32
    secret = val ^ secret
    secret = secret % 16777216
    val = secret * 2048
    secret = val ^ secret
    secret = secret % 16777216
    return secret
}

func twoThou(secret: Int) -> Int {
    var val = secret
    for _ in 0..<2000 {
        val = evolve(secret: val)
    }
    return val
}

func silver22(_ raw: String) {
    print("Silver: ", raw.split(separator: "\n").map{ Int($0)! }.map(twoThou).reduce(0, +))
}

struct Quad:Hashable { var a, b, c, d: Int }

func gold22(_ raw: String) {
    let data = raw.split(separator: "\n").map{ Int($0)! }
    
    var allMonkeys: [Quad: Int] = [:]
    for monkey in data {
        var sec = monkey
        var prices = [sec % 10]
        var deltas: [Int] = []
        var seen: Set<Quad> = Set()
        
        for _ in 0..<2000 {
            sec = evolve(secret: sec)
            deltas.append((sec % 10) - prices.last!)
            prices.append(sec % 10 )
            
            if deltas.count < 4 { continue }
            let (a, b, c, d) = (deltas[deltas.count-4], deltas[deltas.count-3], deltas[deltas.count-2], deltas[deltas.count-1])
            let q = Quad(a: a, b: b, c: c, d: d)
            let p = prices.last!
            if !seen.contains(q) {
                seen.insert(q)
                allMonkeys[q] = (allMonkeys[q] ?? 0) + p
            }
        }
    }
    print("Gold:  ", allMonkeys.values.max()!)
}
