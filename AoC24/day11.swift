//
//  day11.swift
//  AoC24
//
//  Created by Edward Kish on 12/11/24.
//

import Foundation


struct RockState: Hashable {
    let n: Int
    let its: Int
}

func blink(_ n: Int) -> [Int] {
    if n == 0 { return [1] }
    let st = "\(n)"
    if st.count % 2 == 0 {
        let left = st.substring(from: 0, to: st.count / 2)
        let right = st.substring(from: st.count / 2, to: st.count)
        return [Int(left)!, Int(right)!]
    }
    return [2024 * n]
}

var MEMO: [RockState: Int] = [:]

func calculate(from rs: RockState) -> Int {
    if rs.its == 0 { return 1 }
    if MEMO.keys.contains(rs) { return MEMO[rs]! }
    
    let new_vals = blink(rs.n)
    var sm = 0
    for n in new_vals {
        sm += calculate(from: RockState(n: n, its: rs.its - 1))
    }
    MEMO[rs] = sm
    return sm
}

func silver11(_ raw: String) {
    var ct = 0
    for n in raw.split(separator: " ").map({ Int($0)! }) {
        ct += calculate(from: RockState(n: n, its: 25))
    }
    print("Silver: ", ct)
}

func gold11(_ raw: String) {
    var ct = 0
    for n in raw.split(separator: " ").map({ Int($0)! }) {
        ct += calculate(from: RockState(n: n, its: 75))
    }
    print("Silver: ", ct)
}
