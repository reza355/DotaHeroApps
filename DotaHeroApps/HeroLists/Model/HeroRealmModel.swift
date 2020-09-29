//
//  HeroRealmModel.swift
//  DotaHeroApps
//
//  Created by Fathureza Januarza on 29/09/20.
//  Copyright © 2020 Fathureza Januarza. All rights reserved.
//

import Foundation
import RealmSwift

internal class Hero: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var heroName: String = ""
    @objc dynamic var primaryAttribute: String = ""
    @objc dynamic var attackType: String = ""
    @objc dynamic var str: Int = 0
    @objc dynamic var agi: Int = 0
    @objc dynamic var int: Int = 0
    @objc dynamic var maxAttack: Int = 0
    @objc dynamic var baseHealth: Int = 0
    @objc dynamic var icon: String = ""
    @objc dynamic var image: String = ""
    var roles = List<String>()
}

internal class listOfHero: Object {
    let heroes = List<Hero>()
}
