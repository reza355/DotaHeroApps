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
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let viewModel: HeroListViewModel = HeroListViewModel()
    private let disposeBag: DisposeBag = DisposeBag()
    
    private var heroList = [Hero]()
    private var roles = [
        HeroRole.carry,
        HeroRole.disabler,
        HeroRole.durable,
        HeroRole.escape,
        HeroRole.initiator,
        HeroRole.jungler,
        HeroRole.nuker,
        HeroRole.pusher
    ]
    
    internal override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "HeroCharacterCell", bundle: nil), forCellWithReuseIdentifier: "HeroCharacterCell")
        collectionView.register(UINib(nibName: "RolesSelectionCell", bundle: nil), forCellWithReuseIdentifier: "RolesSelectionCell")

        bindViewModel()
    }
    
    private func bindViewModel() {
    
        let input = HeroListViewModel.Input(didLoadTrigger: Driver.just(()))
        
        let output = viewModel.transform(input: input)
        
        output.heroList
            .drive(onNext: { [weak self] (response) in
                self?.heroList = response
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension HeroListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return roles.count
        } else {
            return heroList.count
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RolesSelectionCell", for: indexPath) as? RolesSelectionCell else { return UICollectionViewCell() }

            let roles = self.roles[indexPath.row]
            cell.setupText(text: roles.rawValue)

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroCharacterCell", for: indexPath) as? HeroCharacterCell else { return UICollectionViewCell() }

            let hero = self.heroList[indexPath.row]
            cell.setupView(hero: hero)

            return cell
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: 100, height: 30)
        } else {
            return CGSize(width: 100, height: 100)
        }
    }
}
