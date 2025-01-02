//
//  day10.swift
//  AoC24
//
//  Created by Edward Kish on 12/10/24.
//

import Foundation

func rating(start: (Int, Int), grid: [String]) -> Int {
    var queue = [start]
    var count = 0
    while !queue.isEmpty {
        let (r, c) = queue.removeFirst()
        if grid[r].getChar(at: c) == "9" {
            count += 1
            continue
        }
        for (nr, nc) in [(r, c+1), (r, c-1), (r+1, c), (r-1, c)] {
            if nr >= 0 && nc >= 0 && nr < grid.count && nc < grid[0].count {
                if (Int(grid[nr].getChar(at: nc))! == Int(grid[r].getChar(at: c))! + 1) {
                    queue.append((nr, nc))
                }
            }
        }
    }
    return count
}

func gold10(_ raw: String) {
    let grid = raw.🍌()
    var starts: [(Int, Int)] = []
    for r in 0..<grid.count {
        for c in 0..<grid[0].count {
            if grid[r].getChar(at: c) == "0" {
                starts.append((r, c))
            }
        }
    }
    let s = starts.map { rating10(start: $0, grid: grid) }.reduce(0, +)
    print("Gold ", s)
}

func silver10(_ raw: String) {
    let grid = raw.🍌()
    var starts: [(Int, Int)] = []
    for r in 0..<grid.count {
        for c in 0..<grid[0].count {
            if grid[r].getChar(at: c) == "0" {
                starts.append((r, c))
            }
        }
    }
    let s = starts.map { score10(start: $0, grid: grid) }.reduce(0, +)
    print("Silver ", s)
}

func rating10(start: (Int, Int), grid: [String]) -> Int {
    var queue = [start]
    var count = 0
    while !queue.isEmpty {
        let (r, c) = queue.removeFirst()
        if grid[r].getChar(at: c) == "9" {
            count += 1
            continue
        }
        for (nr, nc) in [(r, c+1), (r, c-1), (r+1, c), (r-1, c)] {
            if nr >= 0 && nc >= 0 && nr < grid.count && nc < grid[0].count {
                if (Int(grid[nr].getChar(at: nc))! == Int(grid[r].getChar(at: c))! + 1) {
                    queue.append((nr, nc))
                }
            }
        }
    }
    return count
}

func score10(start: (Int, Int), grid: [String]) -> Int {
    var queue = [start]
    var count = 0
    var seen: Set<String> = []
    seen.insert("\(start)")
    while !queue.isEmpty {
        let (r, c) = queue.removeFirst()
        if grid[r].getChar(at: c) == "9" {
            count += 1
            continue
        }
        for (nr, nc) in [(r, c+1), (r, c-1), (r+1, c), (r-1, c)] {
            if nr >= 0 && nc >= 0 && nr < grid.count && nc < grid[0].count {
                if (Int(grid[nr].getChar(at: nc))! == Int(grid[r].getChar(at: c))! + 1) && !seen.contains("\((nr, nc))") {
                    queue.append((nr, nc))
                    seen.insert("\((nr, nc))")
                }
            }
        }
    }
    return count
}
