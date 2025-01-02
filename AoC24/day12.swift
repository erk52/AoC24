//
//  day12.swift
//  AoC24
//
//  Created by Edward Kish on 12/12/24.
//

import Foundation

struct Point: Hashable {
    var r: Int
    var c: Int
    func getNeigh() -> [Point] {
        return [
            Point(r: r+1, c: c), Point(r: r-1, c: c),
            Point(r: r, c: c+1), Point(r: r, c: c-1)
        ]
    }
    
    func up() -> Point { return Point(r: r-1, c: c)}
    func down() -> Point { return Point(r: r+1, c: c)}
    func left() -> Point { return Point(r: r, c: c-1)}
    func right() -> Point { return Point(r: r, c: c+1)}
}

func buildGrid12(raw: String) -> [Point: String] {
    var grid: [Point: String] = [:]
    for (r, row) in raw.🍌().enumerated() {
        for col in 0..<row.count {
            grid[Point(r:r, c:col)] = row.getChar(at: col)
        }
    }
    return grid
}



func floodFill(grid: [Point: String]) -> [[Point]] {
    var regions: [[Point]] = []
    var unseen = Set(grid.keys)
    
    while !unseen.isEmpty {
        var cur = unseen.popFirst()
        let cur_val = grid[cur!]!
        var stack = [cur!]
        var cur_region: [Point] = []
        while !stack.isEmpty {
            cur = stack.popLast()!
            if !cur_region.contains(cur!){
                cur_region.append(cur!)
            }
            if unseen.contains(cur!) {
                unseen.remove(cur!)
            }
            
            for n in cur!.getNeigh() {
                if (grid[n] ?? nil) == cur_val && unseen.contains(n) {
                    stack.append(n)
                }
            }
        }
        regions.append(cur_region)
    }
    
    return regions
}

func silver12(_ raw: String) {
    let grid = buildGrid12(raw: raw)
    let regions = floodFill(grid: grid)
    var tot = 0
    for region in regions {
        let area = region.count
        var perim = 0
        for p in region {
            perim += p.getNeigh().filter {grid[$0] != grid[p] }.count
        }
        tot += area * perim
    }
    print("Silver: ", tot)
}

class UnionF {
    var data: [Set<Point>] = []
    var grid: [Point: String]
    
    init(grid: [Point:String]) {
        self.grid = grid
    }
    func insert(point: Point, neighbors: [Point]) {
        var hits: [Int] = []
        for i in 0..<self.data.count {
            if !self.data[i].intersection(Set(neighbors)).isEmpty {
                hits.append(i)
            }
        }
        if hits.isEmpty {
            self.data.append(Set([point]))
        } else if hits.count == 1 {
            self.data[hits[0]].insert(point)
        } else if hits.count == 2 {
            self.data[hits[0]].insert(point)
            self.data[hits[0]].formUnion(self.data[hits[1]])
            self.data.remove(at: hits[1])
        }
    }
    func size() -> Int {
        return self.data.count
    }
}


func getSidesBetter(region: [Point], grid: [Point:String]) -> Int {
    let up = UnionF(grid: grid)
    let down = UnionF(grid: grid)
    let left = UnionF(grid: grid)
    let right = UnionF(grid: grid)
    
    for p in region {
        if grid[p.up()] != grid[p] {
            up.insert(point: p.up(), neighbors: [p.up().left(), p.up().right()])
        }
        if grid[p.down()] != grid[p] {
            down.insert(point: p.down(), neighbors: [p.down().left(), p.down().right()])
        }
        if grid[p.left()] != grid[p] {
            left.insert(point: p.left(), neighbors: [p.left().up(), p.left().down()])
        }
        if grid[p.right()] != grid[p] {
            right.insert(point: p.right(), neighbors: [p.right().up(), p.right().down()])
        }
    }
    
    return up.size() + down.size() + left.size() + right.size()
}

func getSides(region: [Point], grid: [Point:String]) -> Int {
    var up: [Set<Point>] = []
    var down: [Set<Point>] = []
    var left: [Set<Point>] = []
    var right: [Set<Point>] = []
    
    for p in region {
        // Check horizontal sides
        if grid[p.up()] != grid[p] {
            var hits: [Int] = []
            for i in 0..<up.count {
                if up[i].contains(p.up().left()) || up[i].contains(p.up().right()) {
                    hits.append(i)
                }
            }
            if hits.isEmpty {
                up.append(Set([p.up()]))
            } else if hits.count == 1 {
                up[hits[0]].insert(p.up())
            } else if hits.count == 2 {
                up[hits[0]].insert(p.up())
                up[hits[0]].formUnion(up[hits[1]])
                up.remove(at: hits[1])
            }
        }
        if grid[p.down()] != grid[p] {
            var hits: [Int] = []
            for i in 0..<down.count {
                if down[i].contains(p.down().left()) || down[i].contains(p.down().right()) {
                    hits.append(i)
                }
            }
            if hits.isEmpty {
                down.append(Set([p.down()]))
            } else if hits.count == 1 {
                down[hits[0]].insert(p.down())
            } else if hits.count == 2 {
                down[hits[0]].insert(p.down())
                down[hits[0]].formUnion(down[hits[1]])
                down.remove(at: hits[1])
            }
        }
        /// VERTICALS
        if grid[p.right()] != grid[p] {
            var hits: [Int] = []
            for i in 0..<right.count {
                if right[i].contains(p.right().down()) || right[i].contains(p.right().up()) {
                    hits.append(i)
                }
            }
            if hits.isEmpty {
                right.append(Set([p.right()]))
            } else if hits.count == 1 {
                right[hits[0]].insert(p.right())
            } else if hits.count == 2 {
                right[hits[0]].insert(p.right())
                right[hits[0]].formUnion(right[hits[1]])
                right.remove(at: hits[1])
            }
        }
        if grid[p.left()] != grid[p] {
            var hits: [Int] = []
            for i in 0..<left.count {
                if left[i].contains(p.left().down()) || left[i].contains(p.left().up()) {
                    hits.append(i)
                }
            }
            if hits.isEmpty {
                left.append(Set([p.left()]))
            } else if hits.count == 1 {
                left[hits[0]].insert(p.left())
            } else if hits.count == 2 {
                left[hits[0]].insert(p.left())
                left[hits[0]].formUnion(left[hits[1]])
                left.remove(at: hits[1])
            }
        }
    }
    return up.count + down.count + left.count + right.count
}

func gold12(_ raw: String) {
    let grid = buildGrid12(raw: raw)
    let regions = floodFill(grid: grid)
    var tot = 0
    var tot2 = 0
    for region in regions {
        let area = region.count
        let sides = getSides(region: region, grid: grid)
        tot += sides * area
        tot2 += area * getSidesBetter(region: region, grid: grid)
    }
    print("Gold: ", tot, tot2)
}
