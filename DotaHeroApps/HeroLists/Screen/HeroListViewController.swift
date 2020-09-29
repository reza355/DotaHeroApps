//
//  HeroListViewController.swift
//  DotaHeroApps
//
//  Created by Fathureza Januarza on 28/09/20.
//  Copyright © 2020 Fathureza Januarza. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Moya

internal final class HeroListViewController: UIViewController {
    
    private var viewModel: HeroListViewModel = HeroListViewModel()
    let userProvider = MoyaProvider<HeroListMoyaTarget>()

    let disposeBag = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    private func bindViewModel() {
    
        let input = HeroListViewModel.Input(didLoadTrigger: Driver.just(()))
        
        let output = viewModel.transform(input: input)
        
        output.heroList
            .drive(onNext: { (response) in
                print(response)
            }).disposed(by: disposeBag)
    }
}
