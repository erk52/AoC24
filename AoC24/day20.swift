//
//  day20.swift
//  AoC24
//
//  Created by Edward Kish on 12/20/24.
//

import Foundation

func day20(_ raw: String) {
    var grid: [Point: String] = [:]
    var start, end: Point?
    for (r, row) in raw.split(separator: "\n").enumerated() {
        for c in 0..<row.count {
            let square = String(row).getChar(at: c)
            grid[Point(r: r, c: c)] = square
            if square == "E" { end = Point(r: r, c: c)}
            else if square == "S" { start = Point(r: r, c: c)}
        }
    }
    func getDistFrom(source: Point) -> [Point: Int]{
        var q: [(Point, Int)] = [(source, 0)]
        var distances: [Point: Int] = [:]
        while !q.isEmpty {
            let (loc, dist) = q.removeFirst()
            distances[loc] = dist
            for n in loc.getNeigh() {
                if (grid[n] ?? "#") != "#" && (distances[n] ?? 99999) > dist + 1 {
                    q.append((n, dist + 1))
                }
            }
        }
        return distances
    }
    
    let from_start = getDistFrom(source: start!)
    let from_end = getDistFrom(source: end!)
    
    let fair_dist = from_start[end!]!
    
    // Silver
    var cheats: [Int: Int] = [:] // savings: count
    for p in grid.keys {
        if (grid[p] ?? "#") == "#" { continue }
        let right = Point(r: p.r, c: p.c + 2)
        let down = Point(r: p.r + 2, c: p.c)
        
        let rd = min(from_start[p]! + (from_end[right] ?? 9999), from_end[p]! + (from_start[right] ?? 99999)) + 2
        let dd = min(from_start[p]! + (from_end[down] ?? 9999), from_end[p]! + (from_start[down] ?? 99999)) + 2
        
        if rd < fair_dist {
            let rsav = fair_dist - rd
            cheats[rsav] = (cheats[rsav] ?? 0) + 1
        }
        if dd < fair_dist {
            let dsav = fair_dist - dd
            cheats[dsav] = (cheats[dsav] ?? 0) + 1
        }
        
    }
    print("Silver: ", cheats.keys.filter { $0 >= 100 }.map {cheats[$0]!}.reduce(0, +))
    
    var gold_cheats: [Int: Int] = [:]
    for cstart in from_start.keys {
        for cend in cstart.getNeighborsWithinManhattanDistance(of: 20) {
            if cstart == cend || grid[cstart]! == "#" || grid[cend] == "#" { continue }
            let dist = abs(cstart.r - cend.r) + abs(cstart.c - cend.c)
            if dist <= 20 {
                let cheat = (from_start[cstart] ?? 99999) + (from_end[cend] ?? 99999) + dist
                let savings = fair_dist - cheat
                gold_cheats[savings] = (gold_cheats[savings] ?? 0) + 1
            }
        }
    }
    print("Gold: ", gold_cheats.keys.filter { $0 >= 100 }.map {gold_cheats[$0]!}.reduce(0, +))
    
}

extension Point {
    func getNeighborsWithinManhattanDistance(of distance: Int) -> Set<Point> {
        var neigh: Set<Point> = Set()
        for D in 1...distance {
            for dr in 0...D {
                let dc = D - dr
                neigh.insert((Point(r: self.r + dr, c: self.c + dc)))
                neigh.insert((Point(r: self.r - dr, c: self.c + dc)))
                neigh.insert((Point(r: self.r + dr, c: self.c - dc)))
                neigh.insert((Point(r: self.r - dr, c: self.c - dc)))
            }
        }
        return neigh
    }
}
