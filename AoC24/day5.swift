//
//  day5.swift
//  AoC24
//
//  Created by Edward Kish on 12/5/24.
//

import Foundation

func process_input(_ raw: String) -> ([[Int]], [Int: Set<Int>]){
    var ordering: [Int: Set<Int>] = [:]
    let blocks = raw.split(separator: "\n\n")
    for line in blocks[0].split(separator: "\n") {
        let parts = line.split(separator: "|")
        let a = Int(parts[0])!
        let b = Int(parts[1])!
        if ordering.keys.contains(a){
            ordering[a] = ordering[a]!.union([b])
        } else {
            ordering[a] = [b]
        }
    }
    var printings: [[Int]] = []
    for line in blocks[1].split(separator: "\n") {
        printings.append(line.split(separator: ",").map{Int($0)!})
    }
    return (printings, ordering)
}

func isValid(vals: [Int], ordering: [Int: Set<Int>]) -> Bool {
    for (i, val) in vals.enumerated() {
        let must_before = ordering[val] ?? []
        for j in 0..<i {
            if must_before.contains(vals[j]) {
                return false
            }
        }
    }
    return true
}

func setInOrder(printing: [Int], ordering: [Int:Set<Int>]) -> [Int] {
    var order: [Int:Set<Int>] = [:]
    var free: Set<Int> = []
    var not_free: Set<Int> = []
    var new_seq: [Int] = []
    for val in printing {
        var s = Set(printing)
        s.remove(val)
        order[val] = s.intersection(ordering[val] ?? [])
        if order[val]!.isEmpty {
            free.insert(val)
        } else {
            not_free.insert(val)
        }
    }
    while !free.isEmpty {
        let choice = free.first!
        free.remove(choice)
        new_seq.append(choice)
        var liberated: [Int] = []
        for v in not_free {
            if order[v]!.contains(choice) {
                order[v]!.remove(choice)
                if order[v]!.isEmpty {
                    liberated.append(v)
                }
            }
        }
        for l in liberated {
            not_free.remove(l)
            free.insert(l)
        }
    }
    return new_seq
}

func silver5(_ raw: String) {
    let (vals, before) = process_input(raw)
    var total = 0
    for val in vals {
        if isValid(vals: val, ordering: before) {
            total += val[val.count / 2]
        }
    }
    print("Silver ", total)
}

func gold5(_ raw: String){
    let (vals, before) = process_input(raw)
    var total = 0
    for val in vals {
        if !isValid(vals: val, ordering: before) {
            let new_seq = setInOrder(printing: val, ordering: before)
            total += new_seq[new_seq.count / 2]
        }
    }
    print("Gold ", total)
}
