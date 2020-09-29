//
//  HeroCharacterCell.swift
//  DotaHeroApps
//
//  Created by Fathureza Januarza on 29/09/20.
//  Copyright © 2020 Fathureza Januarza. All rights reserved.
//

import UIKit
import Kingfisher

internal class HeroCharacterCell: UICollectionViewCell {
    
    @IBOutlet private weak var heroImages: UIImageView!
    @IBOutlet private weak var heroNameText: UILabel!

    internal func setupView(hero: Hero) {
        let url = URL(string: "https://api.opendota.com\(hero.image)")
        self.heroImages.kf.setImage(with: url)
        self.heroNameText.text = hero.heroName
    }
}
