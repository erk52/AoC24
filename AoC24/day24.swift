//
//  day24.swift
//  AoC24
//
//  Created by Edward Kish on 12/24/24.
//

import Foundation

struct Gate: Hashable {
    var src1, src2, op, dst: String
    
    func doop() -> (Int, Int) -> Int {
        func and(a: Int, b: Int) -> Int { return a & b }
        func or(a: Int, b: Int) -> Int { return a | b }
        func xor(a: Int, b: Int) -> Int { return a ^ b }
        if self.op == "AND" { return and }
        if self.op == "OR" { return or }
        else { return xor }
    }
}

struct GateOp: Hashable {
    var src1, src2, op: String
}

func parseInput24(_ raw: String) -> ([String: Int], [Gate]) {
    let chunks = raw.split(separator: "\n\n").map {String($0)}
    assert(chunks.count == 2)
    var wires: [String: Int] = [:]
    var gates: [Gate] = []
    for line in chunks[0].split(separator: "\n") {
        let parts = line.split(separator: ": ").map {String($0)}
        assert(parts.count == 2)
        wires[parts[0]] = Int(parts[1])!
    }
    for line in chunks[1].split(separator: "\n") {
        let parts = line.split(separator: " ").map{String($0)}
        assert(parts.count == 5)
        gates.append(Gate(src1: parts[0], src2: parts[2], op: parts[1], dst: parts[4]))
    }
    return (wires, gates)
}

func silver24(_ raw: String) {
    var (wires, gates) = parseInput24(raw)
    while !gates.isEmpty {
        for (i, g) in gates.enumerated() {
            if wires.keys.contains(g.src1) && wires.keys.contains(g.src2) {
                wires[g.dst] = g.doop()(wires[g.src1]!, wires[g.src2]!)
                gates.remove(at: i)
                break
            }
        }
    }
    var zbin = ""
    var zval = 0
    var pow = 1
    for zg in wires.keys.filter({$0.starts(with: "z") }).sorted() {
        zbin += String(wires[zg]!)
        zval += wires[zg]! * pow
        pow = pow * 2
    }
    print(zbin)
    print(zval)
}

func checkAdder(wires: [String: Int], gates: [Gate], idx: Int) -> Bool {
    var gates = gates
    var wires = wires
    let x0 = String(format: "x%02d", arguments: [idx])
    let y0 = String(format: "y%02d", arguments: [idx])
    let x1 = String(format: "x%02d", arguments: [idx+1])
    let y1 = String(format: "y%02d", arguments: [idx+1])
    
    
 
    return true
}

func findGates(_ raw: String) {
    var (wires, gates) = parseInput24(raw)
    var forwardMap: [GateOp: String] = [:]
    var revMap: [String: GateOp] = [:]
    for g in gates {
        if g.src1 < g.src2 {
            let gop = GateOp(src1: g.src1, src2: g.src2, op: g.op)
            forwardMap[gop] = g.dst
            revMap[g.dst] = gop
        } else {
            let gop = GateOp(src1: g.src2, src2: g.src1, op: g.op)
            forwardMap[gop] = g.dst
            revMap[g.dst] = gop
        }
    }
    
    func checkAdder(idx: Int) -> Bool {
        let x0 = String(format: "x%02d", arguments: [idx])
        let y0 = String(format: "y%02d", arguments: [idx])
        let x1 = String(format: "x%02d", arguments: [idx+1])
        let y1 = String(format: "y%02d", arguments: [idx+1])
        let z0 = String(format: "z%02d", arguments: [idx+1])
        let z1 = String(format: "z%02d", arguments: [idx+2])
        
        let and1 = forwardMap[GateOp(src1: x0, src2: y0, op: "AND")]
        let xor1 = forwardMap[GateOp(src1: x0, src2: y0, op: "XOR")]
        
        
        return true
    }
    
}
