//
//  day21.swift
//  AoC24
//
//  Created by Edward Kish on 12/21/24.
//

import Foundation


struct codesstate: Hashable {
    var code: String
    var depth: Int
}

func day21() {
    let NUMPAD_MOVES = [
        "0": [
            "0" : [""],
            "1" : ["^<"],
            "2" : ["^"],
            "3" : [">^", "^>"],
            "4" : ["^^<"],
            "5" : ["^^"],
            "6" : [">^^", "^^>"],
            "7" : ["^^<"],
            "8" : ["^^^"],
            "9" : [">^^^", "^^^>"],
            "A" : [">"]
        ],
        "1": [
            "0" : [">v"],
            "1" : [""],
            "2" : [">"],
            "3" : [">>"],
            "4" : ["^"],
            "5" : ["^>"],
            "6" : ["^>>"],
            "7" : ["^^"],
            "8" : ["^^>"],
            "9" : ["^^>>"],
            "A" : [">>v"]
        ],
        "2": [
            "0" : ["v"],
            "1" : ["<"],
            "2" : [""],
            "3" : [">"],
            "4" : ["<^"],
            "5" : ["^"],
            "6" : ["^>"],
            "7" : ["<^^"],
            "8" : ["^^"],
            "9" : ["^^>"],
            "A" : ["v>"]
        ],
        "3": [
            "0" : ["<v"],
            "1" : ["<<"],
            "2" : ["<"],
            "3" : [""],
            "4" : ["<<^"],
            "5" : ["<^"],
            "6" : ["^"],
            "7" : ["<<^^"],
            "8" : ["<^^"],
            "9" : ["^^"],
            "A" : ["v"]
        ],
        "4": [
            "0" : [">vv"],
            "1" : ["v"],
            "2" : ["v>"],
            "3" : ["v>>"],
            "4" : [""],
            "5" : [">"],
            "6" : [">>"],
            "7" : ["^"],
            "8" : ["^>"],
            "9" : ["^>>"],
            "A" : [">>vv"],
        ],
        "5": [
            "0" : ["vv"],
            "1" : ["<v"],
            "2" : ["v"],
            "3" : ["v>"],
            "4" : ["<"],
            "5" : [""],
            "6" : [">"],
            "7" : ["<^"],
            "8" : ["^"],
            "9" : ["^>"],
            "A" : ["vv>"],
        ],
        "6": [
            "0" : ["<vv"],
            "1" : ["<<v"],
            "2" : ["<v"],
            "3" : ["v"],
            "4" : ["<<"],
            "5" : ["<"],
            "6" : [""],
            "7" : ["<<^"],
            "8" : ["<^"],
            "9" : ["^"],
            "A" : ["vv"]
        ],
        "7": [
            "0" : [">vvv"],
            "1" : ["vv"],
            "2" : ["vv>",],
            "3" : ["vv>>"],
            "4" : ["v"],
            "5" : ["v>"],
            "6" : ["v>>"],
            "7" : [""],
            "8" : [">"],
            "9" : [">>"],
            "A" : [">>vvv"]
        ],
        "8": [
            "0" : ["vvv"],
            "1" : ["<vv"],
            "2" : ["vv"],
            "3" : ["vv>"],
            "4" : ["<v"],
            "5" : ["v"],
            "6" : ["v>"],
            "7" : ["<"],
            "8" : [""],
            "9" : [">"],
            "A" : [">vvv"]
        ],
        "9": [
            "0" : ["<vvv"],
            "1" : ["<<vv"],
            "2" : ["<vv"],
            "3" : ["vv"],
            "4" : ["<<v"],
            "5" : ["<v"],
            "6" : ["v"],
            "7" : ["<<"],
            "8" : ["<"],
            "9" : [""],
            "A" : ["vvv"]
        ],
        "A": [
            "0" : ["<"],
            "1" : ["^<<"],
            "2" : ["<^"],
            "3" : ["^"],
            "4" : ["^^<<"],
            "5" : ["<^^"],
            "6" : ["^^"],
            "7" : ["^^^<<"],
            "8" : ["<^^^"],
            "9" : ["^^^"],
            "A" : [""]
        ],
    ]
    let DPAD_MOVES = [
        "^" : [
            "^": [""],
            "A": [">"],
            "<": ["v<"],
            "v": ["v"],
            ">": ["v>"]
        ],
        "A" : [
            "^": ["<"],
            "A": [""],
            "<": ["v<<"],
            "v": ["<v"],
            ">": ["v"]
        ],
        "<" : [
            "^": [">^"],
            "A": [">>^"],
            "<": [""],
            "v": [">"],
            ">": [">>"]
        ],
        "v" : [
            "^": ["^"],
            "A": ["^>"],
            "<": ["<"],
            "v": [""],
            ">": [">"]
        ],
        ">" : [
            "^": ["<^"],
            "A": ["^"],
            "<": ["<<"],
            "v": ["<"],
            ">": [""]
        ],
    ]
    
    func type_numpad(code : String)  -> String {
        var out = ""
        var cur = "A"
        for c in 0..<code.count {
            out += NUMPAD_MOVES[cur]![code.getChar(at: c)]!.first! + "A"
            cur = code.getChar(at: c)
        }
        return out
    }
    
    func type_dpad(code: String) -> String {
        var out = ""
        var cur = "A"
        for c in 0..<code.count {
            out += DPAD_MOVES[cur]![code.getChar(at: c)]!.first! + "A"
            cur = code.getChar(at: c)
        }
        return out
    }
    
    let INP = ["869A", "180A", "596A", "965A", "973A"]
    let NUM = [869, 180, 596, 965, 973]
    
    var tot = 0
    for (i, c) in INP.enumerated() {
        let nm = type_numpad(code: c)
        let first = type_dpad(code: nm)
        let second = type_dpad(code: first)
        tot += NUM[i] * second.count
    }
    print("Silver: ", tot)
    
    var mem: [codesstate: Int] = [:]
    func expand(code: String, depth: Int) -> Int {
        if code == "" { return 1 }
        if depth == 0 {return code.count}
        let st = codesstate(code: code, depth: depth)
        if depth == 1 {
            let newc = type_dpad(code: code)
            mem[st] = newc.count
            return newc.count
        }
        if mem.keys.contains(st) { return mem[st]! }
        var cur = "A"
        var total = 0
        for i in 0..<code.count {
            total += expand(code: DPAD_MOVES[cur]![code.getChar(at: i)]![0] + "A", depth: depth - 1)
            cur = code.getChar(at: i)
        }
        mem[st] = total
        return mem[st]!
        
    }
    tot = 0
    for (i, c) in INP.enumerated() {
        let nm = type_numpad(code: c)
        let sz = expand(code: nm, depth: 25)
        tot += NUM[i] * sz
    }
    print("Gold: ", tot)
}
