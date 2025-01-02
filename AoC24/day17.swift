//
//  day17.swift
//  AoC24
//
//  Created by Edward Kish on 12/17/24.
//

import Foundation


func powah(_ x: Int) -> Int {
    if x == 0 { return 1}
    var v = 1
    for _ in 0..<x {
        v = 2 * v
    }
    return v
}

class IntCodeMachine {
    var regA: Int
    var regB: Int
    var regC: Int
    var program: [Int]
    var IP: Int
    var output: [Int]
    
    init(regA: Int, regB: Int, regC: Int, program: [Int], IP: Int) {
        self.regA = regA
        self.regB = regB
        self.regC = regC
        self.program = program
        self.IP = IP
        self.output = []
    }
    func reset(regA: Int, regB: Int, regC: Int) {
        self.IP = 0
        self.output = []
        self.regA = regA
        self.regB = regB
        self.regC = regC
    }
    func comboArg(arg: Int) -> Int {
        switch arg {
        case 0...3: return arg
        case 4: return self.regA
        case 5: return self.regB
        case 6: return self.regC
        default: return -1
        }
    }
    func adv(arg: Int) {
        let d = powah(self.comboArg(arg: arg))
        let val = self.regA / d
        self.regA = Int(val)
        self.IP += 2
    }
    func bxl(arg: Int) {
        self.regB = self.regB ^ arg
        self.IP += 2
    }
    func bst(arg: Int) {
        self.regB = self.comboArg(arg: arg) % 8
        self.IP += 2
    }
    func jnz(arg: Int) {
        if self.regA != 0 {
            self.IP = arg
        } else {
            self.IP += 2
        }
    }
    func bxc(arg: Int) {
        self.regB = self.regB ^ self.regC
        self.IP += 2
    }
    func out(arg: Int) {
        self.output.append(self.comboArg(arg: arg) % 8)
        self.IP += 2
    }
    func dbv(arg: Int) {
        self.regB = self.regA / powah(self.comboArg(arg: arg))
        self.IP += 2
    }
    func cdv(arg: Int) {
        self.regC = self.regA / powah(self.comboArg(arg: arg))
        self.IP += 2
    }
    
    func runProgram() -> [Int] {
        while self.IP < (self.program.count - 1) {
            let (opcode, arg) = (self.program[self.IP], self.program[self.IP + 1])
            switch opcode {
            case 0: self.adv(arg: arg)
            case 1: self.bxl(arg: arg)
            case 2: self.bst(arg: arg)
            case 3: self.jnz(arg: arg)
            case 4: self.bxc(arg: arg)
            case 5: self.out(arg: arg)
            case 6: self.dbv(arg: arg)
            case 7: self.cdv(arg: arg)
            default: print("ERR")
            }
        }
        return self.output
    }
}

func testIntCode() {
    let M0 = IntCodeMachine(regA: 0, regB: 0, regC: 9, program: [2,6], IP: 0)
    assert(M0.runProgram() == [])
    assert(M0.regB == 1)
    
    let M1 = IntCodeMachine(regA: 10, regB: 0, regC: 0, program: [5,0,5,1,5,4], IP: 0)
    assert(M1.runProgram() == [0, 1, 2])

    let M3 = IntCodeMachine(regA: 2024, regB: 0, regC: 0, program: [0,1,5,4,3,0], IP: 0)
    assert(M3.runProgram() == [4,2,5,6,7,7,7,7,3,1,0])
    assert(M3.regA == 0)
    
}

func silver17() {
    let M = IntCodeMachine(regA: 27334280, regB: 0, regC: 0, program: [2,4,1,2,7,5,0,3,1,7,4,1,5,5,3,0], IP: 0)
    print(M.runProgram())
}

func checkArr(revArr: [Int], revMaster: [Int]) -> Bool {
    for i in 0..<revArr.count {
        if revArr[i] != revMaster[i] {
            return false
        }
    }
    return true
}

func icRun(a0: Int) -> [Int] {
    let M = IntCodeMachine(regA: a0, regB: 0, regC: 0, program: [2,4,1,2,7,5,0,3,1,7,4,1,5,5,3,0], IP: 0)
    return M.runProgram()
}

func gold17() {
    let masterP = [2,4,1,2,7,5,0,3,1,7,4,1,5,5,3,0]
    let revP = Array(masterP.reversed())
    var total = 0
    // Find three more bits for every entry, working backwards
    for _ in masterP {
        total <<= 3
        var a0 = total
        while !checkArr(revArr: icRun(a0: a0).reversed(), revMaster: revP){
            total += 1
            a0 = total
        }
    }
    print("Gold:  ", total)
}
