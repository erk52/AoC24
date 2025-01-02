//
//  day3.swift
//  AoC24
//
//  Created by Edward Kish on 12/3/24.
//

import Foundation

func silver3(_ raw: String) {
    let matches = raw.matches(of: /mul\([0-9]{1,3},[0-9]{1,3}\)/)
    let values = matches.map {$0.output.matches(of: /\d{1,3}/)}
    let products = values.map {Int($0[0].output)! * Int($0[1].output)!}
    let total = products.reduce(0, +)
    print("Silver: ", total)
}

func gold3(_ raw: String) {
    let matches = raw.matches(of: /mul\([0-9]{1,3},[0-9]{1,3}\)|don\'t\(\)|do\(\)/)
    var doing = true
    var total = 0
    for m in matches {
        if m.output == "do()" { doing = true }
        else if m.output == "don't()" { doing = false }
        else {
            if doing {
                let nums = m.output.matches(of: /\d{1,3}/)
                total += Int(nums[0].output)! * Int(nums[1].output)!
            }
        }
    }
    print("Gold: ", total)
}
