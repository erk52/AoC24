//
//  day23.swift
//  AoC24
//
//  Created by Edward Kish on 12/23/24.
//

import Foundation

func day23(_ raw: String) {
    var lan_party: [String: Set<String>] = [:]
    for line in raw.split(separator: "\n") {
        let parts = line.split(separator: "-").map{ String($0) }
        assert(parts.count == 2)
        let (a, b) = (parts[0], parts[1])
        lan_party[a] =  (lan_party[a] ?? Set()).union(Set([b]))
        lan_party[b] =  (lan_party[b] ?? Set()).union(Set([a]))
    }
    var triples: Set<String> = []
    for n1 in lan_party.keys {
        if !n1.starts(with: "t") { continue }
        for n2 in lan_party.keys {
            for n3 in lan_party.keys {
                if lan_party[n1]!.contains(n2) && lan_party[n2]!.contains(n3) && lan_party[n3]!.contains(n1) {
                    triples.insert([n1, n2, n3].sorted().joined(separator: ","))
                }
            }
        }
    }
    print("Silver: ", triples.count)
    
    var winner: Set<String> = Set()
    for seed in lan_party.keys {
        var group = Set([seed])
        for node in lan_party.keys {
            if group.allSatisfy({ lan_party[$0]!.contains(node) }) {
                group.insert(node)
            }
        }
        if group.count > winner.count { winner = group }
    }
    print("Gold:   ", winner.sorted().joined(separator: ","))
}
