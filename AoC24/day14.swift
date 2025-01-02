//
//  day14.swift
//  AoC24
//
//  Created by Edward Kish on 12/14/24.
//

import Foundation

infix operator %%

extension Int {
    static  func %% (_ left: Int, _ right: Int) -> Int {
        if left >= 0 { return left % right }
        if left >= -right { return (left+right) }
        return ((left % right)+right)%right
    }
}

struct Robot {
    var x,y, vx, vy: Int
    func step(H: Int, W: Int) -> Robot {
        return Robot(x: (x + vx) %% W, y: (y + vy) %% H, vx: vx, vy: vy)
    }
    func whichQuad(H: Int, W: Int) -> Int? {
        if self.x < W / 2 && self.y < H / 2 { return 0 }
        if self.x > W / 2 && self.y < H / 2 { return 1 }
        if self.x < W / 2 && self.y > H / 2 { return 2 }
        if self.x > W / 2 && self.y > H / 2 { return 3 }
        return nil
    }
}

func processInput14(_ raw: String) -> [Robot] {
    var bots: [Robot] = []
    
    for line in raw.🍌(){
        let halves = line.split(separator: " ", maxSplits: 2)
        let pvals = halves[0].split(separator: "=")[1].split(separator: ",").map { Int($0)! }
        let vvals = halves[1].split(separator: "=")[1].split(separator: ",").map { Int($0)! }
        bots.append(Robot(x: pvals[0], y: pvals[1], vx: vvals[0], vy: vvals[1]))
    }
    return bots
}


func silver14(_ raw: String) {
    let (h, w) = (103, 101)
    var robutts = processInput14(raw)
    for _ in 0..<100 {
        robutts = robutts.map { $0.step(H: h, W: w)}
    }
    let counts = robutts.map {$0.whichQuad(H: h, W: w)}.reduce(into: [0, 0, 0 ,0]) {q, val in if let idx = val {q[idx] += 1}}
    let soln = counts.reduce(1, *)
    print("Silver: ", soln)
}


func printBots(bots: [Robot], H: Int, W: Int) -> String {
    var grid: [[String]] = []
    for row in 0..<H+1 {
        var l: [String] = []
        for col in 0..<W+1{
            l.append(".")
        }
        grid.append(l)
    }
    for bot in bots {
        grid[bot.y][bot.x] = "R"
    }
    var s = ""
    for row in grid {
        s += row.joined() + "\n"
    }
    return s
}

func gold14(_ raw: String) {
    let (h, w) = (103, 101)
    var robutts = processInput14(raw)
    var ct = 0
    while true {
        ct += 1
        robutts = robutts.map { $0.step(H: h, W: w)}
        let string = printBots(bots: robutts, H: h, W: w)
        if string.contains("RRRRRRRRRRR") {
            print(string)
            print("Gold:   ", ct)
            return
        }
    }
}
