//
//  day6.swift
//  AoC24
//
//  Created by Edward Kish on 12/6/24.
//

import Foundation

func processInput(_ raw: String) -> ((Int, Int, String), [[String]]){
    let lines = raw.split(separator: "\n").map { String($0)};
    var grid: [[String]] = []
    var start: (row: Int, col: Int, dir: String) = (0, 0, "")
    for (r, row) in lines.enumerated() {
        var new_row: [String] = []
        for i in 0..<row.count {
            new_row.append(row.getChar(at: i))
            if "v><^".contains(row.getChar(at: i)) {
                start = (row: r, col: i, row.getChar(at: i))
            }
        }
        grid.append(new_row)
    }
    return (start, grid)
}

func silver6(_ raw: String) {
    let (start, grid) = processInput(raw)
    var history: Set<Int> = Set()
    var cur = start
    var nex = cur
    history.insert(cur.0*grid[0].count + cur.1)
    var done = false
    while !done {
        let (r, c, d) = cur
        switch d {
        case "^":
            if (r-1) >= 0 && grid[r-1][c] != "#" {
                nex = (r-1, c, d)
            } else if r == 0 {
                done = true
            } else {
                nex = (r, c, ">")
            }
        case ">":
            if c + 1 < grid[0].count && grid[r][c+1] != "#" {
                nex = (r, c+1, d)
            } else if c + 1 == grid[0].count {
                done = true
            } else {
                nex = (r, c, "v")
            }
        case "v":
            if (r+1) < grid.count && grid[r+1][c] != "#" {
                nex = (r+1, c, d)
            } else if r+1 == grid.count {
                done = true
            } else {
                nex = (r, c, "<")
            }
        case "<":
            if c - 1 >= 0 && grid[r][c-1] != "#" {
                nex = (r, c-1, d)
            } else if c - 1 == 0 {
                done = true
            } else {
                nex = (r, c, "^")
            }
        default:
            print("err")
            break
        }
        let hsh = nex.0 * grid[0].count + nex.1
        history.insert(hsh)
        cur = nex
    }
    
    print("Silver ", history.count)
}

func willItLoop(start: (Int, Int, String), grid: [[String]]) -> Bool {
    var history: Set<String> = Set()
    var cur = start
    history.insert("\(String(format: "%03d", cur.0))--\(String(format: "%03d", cur.1))--\(cur.2)")
    var done = false
    var nex = cur
    while !done {
        let (r, c, d) = cur
        switch d {
        case "^":
            if (r-1) >= 0 && grid[r-1][c] != "#" {
                nex = (r-1, c, d)
            } else if r == 0 {
                done = true
                return false
            } else {
                nex = (r, c, ">")
            }
        case ">":
            if c + 1 < grid[0].count && grid[r][c+1] != "#" {
                nex = (r, c+1, d)
            } else if c + 1 == grid[0].count {
                done = true
                return false
            } else {
                nex = (r, c, "v")
            }
        case "v":
            if (r+1) < grid.count && grid[r+1][c] != "#" {
                nex = (r+1, c, d)
            } else if r+1 == grid.count {
                done = true
                return false
            } else {
                nex = (r, c, "<")
            }
        case "<":
            if c - 1 >= 0 && grid[r][c-1] != "#" {
                nex = (r, c-1, d)
            } else if c - 1 == 0 {
                done = true
                return false
            } else {
                nex = (r, c, "^")
            }
        default:
            print("err")
            break
        }
        cur = nex
        let hsh = "\(String(format: "%03d", cur.0))--\(String(format: "%03d", cur.1))--\(cur.2)"
        if history.contains(hsh) { return true }
        history.insert(hsh)
    }
    return false
}

func gold6(_ raw: String) {
    var total = 0
    let (start, grid) = processInput(raw)
    for r in 0..<grid.count {
        for c in 0..<grid[0].count {
            if grid[r][c] == "." {
                var newgrid = grid
                newgrid[r][c] = "#"
                if willItLoop(start: start, grid: newgrid) {
                    total += 1
                }
            }
        }
    }
    print("Gold   ", total)
    for row in grid {
        print(row.joined())
    }
}
