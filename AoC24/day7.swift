//
//  day7.swift
//  AoC24
//
//  Created by Edward Kish on 12/7/24.
//

import Foundation


func processInput7(_ raw: String) -> [(Int, [Int])] {
    var inp: [(Int, [Int])] = []
    for line in raw.split(separator: "\n") {
        let chunks = line.split(separator: ": ")
        let goal = Int(chunks[0])!
        let vals = chunks[1].split(separator: " ").map {Int($0)!}
        inp.append((goal, vals))
    }
    return inp
}

func silver7(_ raw: String) {
    let data = processInput7(raw)
    var cnt = 0
    for (tot, arr) in data {
        if checkSilv(goal: tot, numbers: arr) {
            cnt += tot
        }
    }
    print("Silver: ", cnt)
}


func checkSilv(goal: Int, numbers: [Int]) -> Bool {
    let num_op: Int = numbers.count - 1
    var ops: Int = 0
    while ops <= Int(pow(Double(2), Double(num_op))) {
        var tot = numbers[0]
        var p = 1
        for i in 0..<num_op {
            if ops & p != 0 {
                tot = tot * numbers[i+1]
            } else {
                tot = tot + numbers[i+1]
            }
            p = 2 * p
        }
        if tot == goal { return true }
        ops += 1
    }
    return false
}

func gold7(_ raw: String) {
    let data = processInput7(raw)
    var cnt = 0
    for (tot, arr) in data {
        if checkGold(goal: tot, numbers: arr) {
            cnt += tot
        }
    }
    print("Gold  : ", cnt)
}

func ternaryIncrement(_ arr: inout [Int]) {
    var carry = false
    var col = arr.count-1
    repeat {
        carry = false
        arr[col] += 1
        if arr[col] == 3 {
            arr[col] = 0
            carry = true
            col -= 1
        }
    } while carry && col >= 0
}

func checkGold(goal: Int, numbers: [Int]) -> Bool {
    let num_op: Int = numbers.count - 1
    var ops: Int = 0
    var op_arr = Array(repeating: 0, count: num_op)
    
    while ops <= Int(pow(Double(3), Double(num_op))) {
        //print(op_arr)
        var tot = numbers[0]
        for i in 0..<num_op {
            if op_arr[i] == 0 {
                tot = tot + numbers[i+1]
            } else if op_arr[i] == 1 {
                tot = tot * numbers[i+1]
            } else if op_arr[i] == 2 {
                tot = Int("\(tot)\(numbers[i+1])")!
            }
            if tot > goal { break }
        }
        ternaryIncrement(&op_arr)
        if tot == goal {
            return true
        }
        ops += 1
    }
    return false
}

