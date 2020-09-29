//
//  HeroListResponse.swift
//  DotaHeroApps
//
//  Created by Fathureza Januarza on 28/09/20.
//  Copyright © 2020 Fathureza Januarza. All rights reserved.
//

import Foundation

internal enum HeroRole: String, Decodable {
    case carry = "Carry"
    case escape = "Escape"
    case nuker = "Nuker"
    case initiator = "Initiator"
    case durable = "Durable"
    case disabler = "Disabler"
    case jungler = "Jungler"
    case support = "Support"
    case pusher = "Pusher"
}

internal enum HeroType: String, Decodable {
    case melee = "Melee"
    case ranged = "Ranged"
}

internal enum PrimaryAttribute: String, Decodable {
    case int = "int"
    case agi = "agi"
    case str = "str"
}

internal struct HeroListResponse: Decodable {
    
    let id: Int
    let heroName: String
    let primaryAttribute: PrimaryAttribute
    let attackType: HeroType
    let roles: [HeroRole]
    let str: Int
    let agi: Int
    let int: Int
    let maxAttack: Int
    let baseHealth: Int
    let icon: String    
    
    private enum CodingKeys : String, CodingKey {
        case id
        case heroName = "localized_name"
        case primaryAttribute = "primary_attr"
        case attackType = "attack_type"
        case roles = "roles"
        case str = "base_str"
        case agi = "base_agi"
        case int = "base_int"
        case maxAttack = "base_attack_max"
        case baseHealth = "base_health"
        case icon = "icon"
    }
}
