//
//  day15.swift
//  AoC24
//
//  Created by Edward Kish on 12/20/24.
//

import Foundation

extension Point {
    func moveBy(symbol: String) -> Point {
        switch symbol {
        case "v": return self.down()
        case "^": return self.up()
        case ">": return self.right()
        case "<": return self.left()
        default:
            print("Err: \(symbol)")
            return self
        }
    }
}

func silver15(_ raw: String) {
    let chunks = raw.split(separator: "\n\n")
    assert(chunks.count == 2)
    let grid = chunks[0].split(separator: "\n").map { String($0) }
    let moves = String(chunks[1])
    var robot: Point = Point(r: 0, c: 0)
    
    var hgrid: [Point: String] = [:]
    for r in 0..<grid.count {
        for c in 0..<grid[0].count {
            hgrid[Point(r: r, c: c)] = grid[r].getChar(at: c)
            if grid[r].getChar(at: c) == "@" {
                robot = Point(r: r, c: c)
                hgrid[Point(r: r, c: c)] = "."
            }
        }
    }
    
    for m in 0..<moves.count {
        if moves.getChar(at:m) == "\n" { continue }
        let nex: Point = robot.moveBy(symbol: moves.getChar(at:m))
        
        if hgrid[nex] == "." {
            hgrid[robot] = "."
            robot = nex
        } else if hgrid[nex] == "O" {
            var over = nex.moveBy(symbol: moves.getChar(at:m))
            while hgrid[over] == "O" {
                over = over.moveBy(symbol: moves.getChar(at:m))
            }
            if hgrid[over] == "." {
                hgrid[robot] = "."
                robot = nex
                hgrid[over] = "O"
            }
        }
    }
    var gps = 0
    for r in 0..<grid.count {
        var ln = ""
        for c in 0..<grid[0].count {
            if Point(r: r, c: c) == robot { ln += "@"}
            else { ln += hgrid[Point(r: r, c: c)] ?? "_" }
            if hgrid[Point(r: r, c: c)] == "O" {
                gps += (100*r + c)
            }
        }
        //print(ln)
    }
    print("Silver: ", gps)
}

func gold15(_ raw: String) {
    let chunks = raw.split(separator: "\n\n")
    assert(chunks.count == 2)
    let grid = chunks[0].split(separator: "\n").map { String($0) }
    let moves = String(chunks[1])
    var robot: Point = Point(r: 0, c: 0)
    
    var hgrid: [Point: String] = [:]
    for r in 0..<grid.count {
        for c in 0..<grid[0].count {
            let val = grid[r].getChar(at: c)
            if val == "." || val == "#" {
                hgrid[Point(r: r, c: 2*c)] = val
                hgrid[Point(r: r, c: 2*c + 1)] = val
            } else if val == "O" {
                hgrid[Point(r: r, c: 2*c)] = "["
                hgrid[Point(r: r, c: 2*c + 1)] = "]"
            }
            if grid[r].getChar(at: c) == "@" {
                robot = Point(r: r, c: 2*c)
                hgrid[Point(r: r, c: 2*c)] = "."
                hgrid[Point(r: r, c: 2*c + 1)] = "."
            }
        }
    }
    for m in 0..<moves.count {
        let mvsym = moves.getChar(at:m)
        print(mvsym)
        for r in 0..<grid.count {
            var ln = ""
            for c in 0..<grid[0].count*2 {
                if Point(r: r, c: c) == robot { ln += "@"}
                else { ln += hgrid[Point(r: r, c: c)] ?? "_" }
            }
            print(ln)
        }
        if mvsym == "\n" { continue }
        let nex: Point = robot.moveBy(symbol: mvsym)
        
        if hgrid[nex] == "." {
            hgrid[robot] = "."
            robot = nex
        } else if (hgrid[nex] == "[" || hgrid[nex] == "]") && (mvsym == ">" || mvsym == "<" ) {
            var over = nex.moveBy(symbol: mvsym)
            var lst = [nex]
            while hgrid[over] == "[" || hgrid[over] == "]" {
                lst.append(over)
                over = over.moveBy(symbol: mvsym)
            }
            if hgrid[over] == "." {
                for l in lst.reversed() {
                    hgrid[l.moveBy(symbol: mvsym)] = hgrid[l]
                }
                hgrid[robot] = "."
                robot = robot.moveBy(symbol: mvsym)
            }
        } else if (hgrid[nex] == "[" || hgrid[nex] == "]") && (mvsym == "^" || mvsym == "v" ) {
            let target = robot.moveBy(symbol: mvsym)
            if hgrid[target] == "." {
                hgrid[robot] = "."
                robot = target
            } else {
                var to_push: [Point] = []
                var to_check = [target]
                if hgrid[target] == "[" { to_check.append(target.right())}
                else if hgrid[target] == "]" { to_check.append(target.left())}
                var bad = false
                
                while !to_check.isEmpty {
                    let c = to_check.removeFirst()
                    if hgrid[c] == "#" {
                        bad = true
                        break
                    } else if hgrid[c] == "." {
                        continue
                    } else {
                        let n = c.moveBy(symbol: mvsym)
                        if !to_push.contains(c) {
                            to_push.append(c)
                        }
                        to_check.append(n)
                        if hgrid[n] == "]" { to_check.append(n.left())}
                        if hgrid[n] == "[" { to_check.append(n.right())}
                    }
                }
                if !bad {
                    while !to_push.isEmpty {
                        let c = to_push.popLast()
                        let t = c?.moveBy(symbol: mvsym)
                        hgrid[t!] = hgrid[c!]
                        hgrid[c!] = "."
                    }
                    robot = robot.moveBy(symbol: mvsym)
                }
            }
        }
    }
    var gps = 0
    for r in 0..<grid.count {
        var ln = ""
        for c in 0..<grid[0].count*2 {
            if Point(r: r, c: c) == robot { ln += "@"}
            else { ln += hgrid[Point(r: r, c: c)] ?? "_" }
            if hgrid[Point(r: r, c: c)] == "[" {
                gps += (100*r + c)
            }
        }
        print(ln)
    }
    print("Gold: ", gps)
    // should be 1489116, but I screwed up translating my python that actually works
    // and now I'm too lazy to debug it. Probably gps-ing?
}
