//
//  day2.swift
//  AoC24
//
//  Created by Edward Kish on 12/2/24.
//

import Foundation


func is_safe(report: [Int]) -> Int {
    var allAscending = true
    var allDescending = true
    for i in 1..<report.count {
        if report[i] > report[i-1] {
            allDescending = false
        } else if report[i] < report[i-1] {
            allAscending = false
        }
        if abs(report[i] - report[i-1]) < 1 || abs(report[i] - report[i-1]) > 3 {
            return 0
        }
    }
    if allAscending || allDescending {
        return 1
    } else {
        return 0
    }
}

func is_safe_with_damping(report: [Int]) -> Int {
    if is_safe(report: report) != 0 {
        return 1
    }
    for i in 0..<report.count {
        var new_report = report
        new_report.remove(at: i)
        if is_safe(report: new_report) != 0 { return 1 }
    }
    return 0
}



func is_safe_smarter(report: [Int]) -> Int {
    let goal = report.count - 1
    var queue = [(idx: 0, direc: 0, skip: 0), (idx: 0, direc: 1, skip: 0), (idx: 1, direc: 0, skip: 1), (idx: 1, direc: 1, skip: 1)]
    while !queue.isEmpty {
        let cur = queue.removeFirst()
        if cur.idx == goal { return 1 }
        if cur.idx == goal - 1 && cur.skip == 0 { return 1 }
        if cur.direc == 0 {
            if report[cur.idx + 1] - report[cur.idx] > 0 && report[cur.idx + 1] - report[cur.idx] < 4 {
                queue.append((idx: cur.idx + 1, direc: 0, skip: cur.skip))
            }
            if cur.skip == 0 && cur.idx + 2 <= goal && (report[cur.idx + 2] - report[cur.idx]) > 0 && (report[cur.idx + 2] - report[cur.idx]) < 4 {
                queue.append((idx:cur.idx + 2, direc: 0, skip: 1))
            }
        } else if cur.direc == 1 {
            if (report[cur.idx] - report[cur.idx + 1]) > 0 && (report[cur.idx] - report[cur.idx + 1]) < 4 {
                queue.append((idx: cur.idx + 1, direc: 1, skip: cur.skip))
            }
            if cur.skip == 0 && cur.idx + 2 <= goal && (report[cur.idx] - report[cur.idx + 2]) > 0 && (report[cur.idx] - report[cur.idx + 2]) < 4 {
                queue.append((idx:cur.idx + 2, direc: 1, skip: 1))
            }
        }
    }
    return 0
}

func silver2(_ raw: String) {
    print("Silver Day 2:")
    let lines = raw.split(separator: "\n")
    let reports = lines.map {$0.split(separator: " ").map {Int($0)!}}
    let total = reports.map{is_safe(report: $0)}.reduce(0, +)
    print(total)
}

func gold2(_ raw: String) {
    print("Gold Day 2:")
    let lines = raw.split(separator: "\n")
    let reports = lines.map {$0.split(separator: " ").map {Int($0)!}}
    let total = reports.map{is_safe_smarter(report: $0)}.reduce(0, +)
    print(total)
}
