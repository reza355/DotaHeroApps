//
//  RolesSelectionCell.swift
//  DotaHeroApps
//
//  Created by Fathureza Januarza on 29/09/20.
//  Copyright © 2020 Fathureza Januarza. All rights reserved.
//

import UIKit

internal class RolesSelectionCell: UICollectionViewCell {
    
    @IBOutlet private weak var rolesTextLabel: UILabel!

    internal func setupText(text: String) {
        rolesTextLabel.text = text
    }

}
