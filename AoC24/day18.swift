//
//  day18.swift
//  AoC24
//
//  Created by Edward Kish on 12/18/24.
//

import Foundation

func day18(_ raw: String) {
    var blox: [Point] = []
    for line in raw.split(separator: "\n") {
        let v = line.split(separator: ",").map { Int($0)!}
        assert(v.count == 2)
        blox.append(Point(r: v[1], c: v[0]))
    }
    let GS = 71
    func checkbounds(_ p: Point) -> Bool {
        return p.r >= 0 && p.c >= 0 && p.r < GS && p.c < GS
    }
    func bfs(mark: Int) -> Int? {
        var q = [(Point(r: 0, c:0), 0)]
        var seen: Set<Point> = Set()
        while !q.isEmpty {
            let (cur, steps) = q.removeFirst()
            seen.insert(cur)
            if cur == Point(r: GS - 1, c: GS - 1) { return steps }
            for n in cur.getNeigh() {
                if !seen.contains(n) && checkbounds(n) && !blox[0..<mark].contains(n){
                    q.append((n, steps + 1))
                    seen.insert(n)
                }
            }
        }
        return nil
    }
    
    print("Silver: ", bfs(mark: 1024) ?? "You done goofed")
    
    // Binary search
    var lo = 0
    var hi = blox.count - 1
    while lo < hi {
        let mid = (hi - lo) / 2 + lo
        if bfs(mark: mid) != nil {
            lo = mid + 1
        } else {
            hi = mid - 1
        }
    }
    print("Gold:   \(blox[lo-1].c),\(blox[lo-1].r)")
}
