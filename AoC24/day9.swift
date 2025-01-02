//
//  day9.swift
//  AoC24
//
//  Created by Edward Kish on 12/9/24.
//

import Foundation


func silver9(_ raw: String) {
    var mem: [Int] = []
    var space = false
    var idnum = 0
    // Parse input
    for i in 0..<raw.count {
        let c = Int(raw.getChar(at: i))!
        for _ in 0..<c {
            if space { mem.append(-1) }
            else { mem.append(idnum)}
        }
        if !space {
            idnum += 1
        }
        space = !space
    }

    // Moving pointers
    var low_ptr = 0
    var high_ptr = mem.count - 1
    
    repeat {
        while low_ptr <= high_ptr && mem[low_ptr] != -1 {
            low_ptr += 1
        }
        while high_ptr >= low_ptr && mem[high_ptr] == -1 {
            high_ptr -= 1
        }
        if mem[high_ptr] != -1 && mem[low_ptr] == -1 {
            (mem[high_ptr], mem[low_ptr]) = (mem[low_ptr], mem[high_ptr])
            high_ptr -= 1
            low_ptr += 1
        }
    } while low_ptr < high_ptr
    
    // Find checksum
    var checksum = 0
    for (i, num) in mem.enumerated() {
        if num > 0 {
            checksum += num * i
        }
    }
    print("Silver: ", checksum)
}


struct Block {
    let id: Int
    let size: Int
}

func consolidateSpaces(_ blox: [Block]) -> [Block] {
    var blox = blox
    var new_blox: [Block] = [blox.removeFirst()]
    for block in blox {
        if block.id == -1 && new_blox.last!.id == -1 {
            let old = new_blox.popLast()
            new_blox.append(Block(id: -1, size: block.size + old!.size))
        } else {
            new_blox.append(block)
        }
    }
    return new_blox
}


func gold9(_ raw: String) {
    var blocks: [Block] = []
    var num = 0
    // Parse input
    for i in 0..<raw.count {
        if i % 2 == 0 {
            blocks.append(Block(id: num, size: Int(raw.getChar(at: i))!))
            num += 1
        } else {
            blocks.append(Block(id: -1, size: Int(raw.getChar(at: i))!))
        }
    }
    num -= 1
    // Check each block id sequentially
    while num >= 0 {
        let loc = blocks.firstIndex(where: {$0.id == num})!
        let new_loc = blocks.firstIndex(where: {$0.id == -1 && $0.size >= blocks[loc].size})
        if new_loc != nil && new_loc! < loc {
            let delta = blocks[new_loc!].size - blocks[loc].size
            if delta == 0 {
                (blocks[loc], blocks[new_loc!]) = (blocks[new_loc!], blocks[loc])
                if blocks[loc.advanced(by: 1)].id == -1 || blocks[loc.advanced(by: -1)].id == -1 {
                    blocks = consolidateSpaces(blocks)
                }
            } else {
                blocks[new_loc!] = Block(id: -1, size: blocks[loc].size)
                (blocks[loc], blocks[new_loc!]) = (blocks[new_loc!], blocks[loc])
                blocks.insert(Block(id:-1, size:delta), at: new_loc!.advanced(by: 1))
                blocks = consolidateSpaces(blocks)
            }
        }
        num -= 1
    }
    // Calc checksum
    var checksum = 0
    var idx = 0
    for block in blocks{
        for _ in 0..<block.size {
            if block.id != -1 {
                checksum += idx*block.id
            }
            idx += 1
        }
    }
    print("Gold: ", checksum)
}
