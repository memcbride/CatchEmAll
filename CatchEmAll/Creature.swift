//
//  Creature.swift
//  CatchEmAll
//
//  Created by Mark McBride on 6/29/24.
//

import Foundation

struct Creature: Codable, Identifiable {
    let id = UUID().uuidString
    var name: String
    var url: String // url for detail on Pokeman
    
    enum CodingKeys: CodingKey {
        case name, url
    }
}
