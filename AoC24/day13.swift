//
//  day13.swift
//  AoC24
//
//  Created by Edward Kish on 12/12/24.
//

import Foundation

func processInput13(_ raw: String) -> [((Int, Int), (Int, Int), (Int, Int))] {
    var out: [((Int, Int), (Int, Int), (Int, Int))] = []
    for chunk in raw.split(separator: "\n\n") {
        let lines = chunk.split(separator: "\n", maxSplits: 3)
        let ma = lines[0].matches(of: /X\+(\d+), Y\+(\d+)/)
        let A = (Int(ma[0].output.1)!, Int(ma[0].output.2)!)
        let mb = lines[1].matches(of: /X\+(\d+), Y\+(\d+)/)
        
        let B = (Int(mb[0].output.1)!, Int(mb[0].output.2)!)
        let mp = lines[2].matches(of: /X\=(\d+), Y\=(\d+)/)
        let P = (Int(mp[0].output.1)!, Int(mp[0].output.2)!)
        out.append((A, B, P))
    }
    return out
}

func solveLinearEqns(A: (Int, Int), B: (Int, Int), P: (Int, Int)) -> (Int, Int)? {
    // nA0 + mB0 = P0
    // nA1 + mB1 = P1
    //m = (P1 - nA1) / B.1
    // nA0 + P1*B0/B1 - nA1B0/B1 = P0
    // n(A0 - A1*B0/B1) = P0 - (B0/B1)*P1
    //n = [B1*P0 - (B0*P1)] / [B1*A0 - A1*B0]
    
    let num = B.1*P.0 - (B.0*P.1)
    let den = B.1*A.0 - A.1*B.0
    if num % den != 0 {
        return nil
    }
    let n = num / den
    let num2 = P.1 - n*A.1
    if num2 % B.1 != 0 {
        return nil
    }
    let m = num2 / B.1
    return (n, m)
}

func silver13(_ raw: String) {
    let claws = processInput13(raw)
    var tokens = 0
    for (A, B, P) in claws {
        if let S = solveLinearEqns(A: A, B: B, P: P) {
            tokens += 3 * S.0 + S.1
        }
    }
    print("Silver ", tokens)
    
}

func gold13(_ raw: String) {
    let claws = processInput13(raw)
    var tokens = 0
    for (A, B, P) in claws {
        if let S = solveLinearEqns(A: A, B: B, P: (P.0+10000000000000, P.1+10000000000000)) {
            tokens += 3 * S.0 + S.1
        }
    }
    print("Gold ", tokens)
    
}
