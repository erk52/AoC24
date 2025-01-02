//
//  main.swift
//  AoC24
//
//  Created by Edward Kish on 11/29/24.
//

import Foundation



extension String {
    func getChar(at index: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: index)
        let end = self.index(self.startIndex, offsetBy: index + 1)
        return String(self[start..<end])
    }
    
    func substring(from: Int, to: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: from)
        let end = self.index(self.startIndex, offsetBy: to)
        return String(self[start..<end])
    }
    
    func 🍌() -> [String] {
        return self.split(separator: "\n").map { String($0)}
    }
}

extension StringProtocol {
    var lines: [SubSequence] { split(whereSeparator: \.isNewline) }
}


let file = "/Users/ekish/Desktop/aoc/input25.txt"
let raw_input = try String(contentsOfFile: file, encoding: String.Encoding.utf8)


day25(raw_input)
