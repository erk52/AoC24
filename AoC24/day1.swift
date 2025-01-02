//
//  day1.swift
//  AoC24
//
//  Created by  on 12/1/24.
//


func silver1(_ raw: String) {
    print("SILVER Answer")
    var right: [Int] = []
    var left: [Int] = []
    for line in raw.split(separator: "\n") {
        let chunks = String(line).split(separator: "   ")
        left.append(Int(chunks[0])!)
        right.append(Int(chunks[1])!)
    }
    left.sort()
    right.sort()
    var delta = 0
    for (l, r) in zip(left, right) {
        delta += abs(l - r)
    }
    print(zip(left, right).map { abs($0 - $1) }.reduce(0, +))
    print(delta)
}


func gold1(_ raw: String) {
    print("GOLD Answer")
    var right: [Int: Int] = [:]
    var left: [Int] = []
    for line in raw.split(separator: "\n") {
        let sl = String(line)
        let chunks = sl.split(separator: "   ")
        left.append(Int(chunks[0])!)
        let r = Int(chunks[1])!
        right[r] = 1 + (right[r] ?? 0)
    }
    var total = 0
    for i in 0..<left.count {
        total += left[i] * (right[left[i]] ?? 0)
    }
    print(total)
}
