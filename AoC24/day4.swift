//
//  day4.swift
//  AoC24
//
//  Created by Edward Kish on 12/4/24.
//

import Foundation

enum Direction: CaseIterable { case N, S, E, W, NW, NE, SW, SE }

func silver4(_ raw: String) {
    let next_letter = ["X": "M", "M":"A", "A": "S"]
    let next_pos: [Direction: (row: Int, col: Int)] = [
        .N: (-1, 0), .S: (1, 0), .E: (0, 1), .W: (0, -1),
        .NW: (-1, -1), .NE: (-1, 1), .SW: (1, -1), .SE: (1, 1)
    ]
    var queue: [(Int, Int, Direction)] = []
    
    let grid = raw.split(separator: "\n").map {String($0)}
    let W = grid[0].count
    let H = grid.count
    
    for row in 0..<H {
        for col in 0..<W {
            if grid[row].getChar(at: col) == "X" {
                for d in Direction.allCases {
                    queue.append((row, col, d))
                }
            }
        }
    }
    var count = 0
    while !queue.isEmpty {
        let (r, c, d) = queue.removeFirst()
        let l = grid[r].getChar(at: c)

        if l == "S" {
            count += 1
            continue
        }
        let (dr, dc) = next_pos[d]!
        let nr = r + dr
        let nc = c + dc
        if (nr >= 0 && nr < H) && (nc >= 0 && nc < W) && grid[nr].getChar(at: nc) == next_letter[l] {
            queue.append((nr, nc, d))
        }
    }
    print("Silver: ", count)
}

func gold4(_ raw: String) {
    let winners = Set(["MSMS", "SSMM", "MMSS", "SMSM"])
    let grid = raw.split(separator: "\n").map {String($0)}
    let W = grid[0].count
    let H = grid.count
    var count = 0
    for row in 1..<(H-1) {
        for col in 1..<(W-1) {
            if grid[row].getChar(at: col) == "A" {
                let cross = [(row-1, col-1), (row-1, col+1), (row+1, col-1), (row+1, col+1)].map { grid[$0].getChar(at: $1) }
                if winners.contains(cross.joined()) {
                    count += 1
                }
            }
        }
    }
    
    print("Gold: ", count)
}
