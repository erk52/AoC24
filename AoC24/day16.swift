//
//  day16.swift
//  AoC24
//
//  Created by Edward Kish on 12/16/24.
//

import Foundation

let DIRS = [(0, 1), (1, 0), (0, -1), (-1, 0)]

struct State16:Hashable {
    var r, c: Int
    var dr, dc: Int
    func forward() -> State16 {
        return State16(r: self.r+self.dr, c: self.c+self.dc, dr: self.dr, dc: self.dc)
    }
    func left_and_forward() -> State16 {
        let idx = DIRS.firstIndex(where: {$0 == (self.dr, self.dc)})!
        let (ndr, ndc) = DIRS[(idx + 1) %% 4]
        return State16(r: self.r+ndr, c: self.c+ndc, dr: ndr, dc: ndc)
    }
    func right_and_forward() -> State16 {
        let idx = DIRS.firstIndex(where: {$0 == (self.dr, self.dc)})!
        let (ndr, ndc) = DIRS[(idx - 1) %% 4]
        return State16(r: self.r+ndr, c: self.c+ndc, dr: ndr, dc: ndc)
    }
    
    func backward() -> State16 {
        return State16(r: self.r - self.dr, c: self.c-self.dc, dr: self.dr, dc: self.dc)
    }
    func left_and_backward() -> State16 {
        let idx = DIRS.firstIndex(where: {$0 == (self.dr, self.dc)})!
        let (ndr, ndc) = DIRS[(idx + 1) %% 4]
        return State16(r: self.r-self.dr, c: self.c-self.dc, dr: ndr, dc: ndc)
    }
    func right_and_backward() -> State16 {
        let idx = DIRS.firstIndex(where: {$0 == (self.dr, self.dc)})!
        let (ndr, ndc) = DIRS[(idx - 1) %% 4]
        return State16(r: self.r-self.dr, c: self.c-self.dc, dr: ndr, dc: ndc)
    }
}

func forwardBFS(start: (Int, Int), end: (Int, Int), graph: [[String]]) -> [State16: Int] {
    var queue = [(0, State16(r: start.0, c: start.1, dr: 0, dc: 1))]
    var min_score: [State16: Int] = [:]
    
    while !queue.isEmpty {
        let (score, state) = queue.removeFirst()
        min_score[state] = min(min_score[state] ?? 9999999, score)
        
        if state.r == end.0 && state.c == end.1 {
            continue
        }

        // Move forward
        let new_s = state.forward()
        if graph[new_s.r][new_s.c] != "#" && (score + 1 < min_score[new_s] ?? 9999999){
            queue.append((score+1, new_s))
        }
        let ls = state.left_and_forward()
        let rs = state.right_and_forward()
        if graph[ls.r][ls.c] != "#" &&  (score + 1001 < min_score[ls] ?? 9999999){
            queue.append((score+1001, ls))
        }
        if graph[rs.r][rs.c] != "#" && (score + 1001 < min_score[rs] ?? 9999999){
            queue.append((score+1001, rs))
        }
    }
    return min_score
}

func backwardBFS(start: (Int, Int), end: (Int, Int), graph: [[String]], max_len: Int) -> [State16: Int] {
    var queue = [
        (0, State16(r: end.0, c: end.1, dr: 0, dc: 1)),
        (0, State16(r: end.0, c: end.1, dr: -1, dc: 0)),
    ]
    var min_score: [State16: Int] = [:]
    
    while !queue.isEmpty {
        let (score, state) = queue.removeFirst()
        min_score[state] = min(min_score[state] ?? 9999999, score)
        if state == State16(r: start.0, c: start.1, dr: 0, dc: 1) {
            continue
        } else if score > max_len { continue }

        // Move backward
        let new_s = state.backward()
        if graph[new_s.r][new_s.c] != "#" && (score + 1 < min_score[new_s] ?? 9999999){
            queue.append((score+1, new_s))
        }
        let ls = state.left_and_backward()
        let rs = state.right_and_backward()
        if graph[ls.r][ls.c] != "#" &&  (score + 1001 < min_score[ls] ?? 9999999){
            queue.append((score+1001, ls))
        }
        if graph[rs.r][rs.c] != "#" && (score + 1001 < min_score[rs] ?? 9999999){
            queue.append((score+1001, rs))
        }
    }
    return min_score
}

func day16(_ raw: String) {
    let g = raw.split(separator: "\n").map {String($0)}
    var S, E: (Int, Int)?
    var gmap: [[String]] = []
    for r in 0..<g.count {
        var ln: [String] = []
        for c in 0..<g[r].count {
            ln.append(g[r].getChar(at: c))
            if ln[c] == "E" { E = (r, c) }
            if ln[c] == "S" { S = (r, c) }
        }
        gmap.append(ln)
    }
    let scores = forwardBFS(start: S!, end: E!, graph: gmap)
    let winners = scores.keys.filter { ($0.r, $0.c) == E! }
    let winscore = winners.map {scores[$0] ?? 999999 }
    let MIN_LEN = winscore.min()!
    print("Silver: ", MIN_LEN)
    let backscores = backwardBFS(start: S!, end: E!, graph: gmap, max_len: MIN_LEN+1)
    var spaces: [(Int, Int)] = []
    for r in 0..<g.count {
        for c in 0..<g[r].count {
            let states = [
                State16(r: r, c: c, dr: 0, dc: 1),
                State16(r: r, c: c, dr: 1, dc: 0),
                State16(r: r, c: c, dr: 0, dc: -1),
                State16(r: r, c: c, dr: -1, dc: 0),
            ]
            for s in states{
                if (scores[s] ?? 9999) + (backscores[s] ?? 99999) == MIN_LEN {
                    spaces.append((r, c))
                    break
                }
            }
        }
    }
    print("Gold   ", spaces.count)
}
