//
//  HeroDetailViewController.swift
//  DotaHeroApps
//
//  Created by Fathureza Januarza on 29/09/20.
//  Copyright © 2020 Fathureza Januarza. All rights reserved.
//

import UIKit
import Kingfisher

class HeroDetailViewController: UIViewController {
    
    @IBOutlet private weak var heroImage: UIImageView!
    @IBOutlet private weak var heroRoleLabel: UILabel!
    @IBOutlet private weak var heroTypeLabel: UILabel!
    @IBOutlet private weak var healthLabel: UILabel!
    @IBOutlet private weak var speedLabel: UILabel!
    @IBOutlet private weak var attackLabel: UILabel!
    @IBOutlet private weak var attributeLabel: UILabel!
    @IBOutlet private weak var firstSimilarImage: UIImageView!
    @IBOutlet private weak var secondSimilarImage: UIImageView!
    @IBOutlet private weak var thirsSimilarImage: UIImageView!
    @IBOutlet private weak var heroNameLabel: UILabel!
    
    
    private var hero: Hero?
    private var similarLink = [String]()

    internal init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, hero: Hero, similarLink: [String])   {
        self.hero = hero
        self.similarLink = similarLink
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let hero = self.hero else { return }
        
        title = "Detail of \(hero.heroName)"
        
        let url = URL(string: "https://api.opendota.com\(hero.image)")
        self.heroImage.kf.setImage(with: url)
        self.heroNameLabel.text = hero.heroName
        self.heroRoleLabel.text = hero.roles.joined(separator: ",")
        self.heroTypeLabel.text = "Type: \(hero.attackType)"
        self.healthLabel.text = "Health: \(hero.baseHealth)"
        self.attackLabel.text = "Attack: \(hero.attackType)"
        self.speedLabel.text = "Speed: \(hero.speed)"
        self.attributeLabel.text = "Attribute: \(hero.primaryAttribute)"
        self.firstSimilarImage.kf.setImage(with: URL(string: "https://api.opendota.com\(similarLink[0])"))
        self.secondSimilarImage.kf.setImage(with: URL(string: "https://api.opendota.com\(similarLink[1])"))
        self.thirsSimilarImage.kf.setImage(with: URL(string: "https://api.opendota.com\(similarLink[2])"))
    }
}
