//
//  HeroListResponse.swift
//  DotaHeroApps
//
//  Created by Fathureza Januarza on 28/09/20.
//  Copyright © 2020 Fathureza Januarza. All rights reserved.
//

import Foundation

internal struct HeroListResponse: Decodable {
    
    let id: Int
    let heroName: String
    let primaryAttribute: String
    let attackType: String
    
    private enum CodingKeys : String, CodingKey {
        case id
        case heroName = "localized_name"
        case primaryAttribute = "primary_attr"
        case attackType = "attack_type"
    }
}
