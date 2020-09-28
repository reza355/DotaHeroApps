//
//  HeroListViewController.swift
//  DotaHeroApps
//
//  Created by Fathureza Januarza on 28/09/20.
//  Copyright © 2020 Fathureza Januarza. All rights reserved.
//

import UIKit

internal final class HeroListViewController: UIViewController {
    
    private let viewModel: HeroListViewModel = HeroListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }
    
    private func bindViewModel() {
        
        let input = HeroListViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
    }
}
