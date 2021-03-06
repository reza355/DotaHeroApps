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
    
    private var viewModel: HeroListViewModel?
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let selectedRoleSubject = PublishSubject<HeroRole>()
    private let selectedHeroSubject = PublishSubject<Hero>()
    
    private let roles = [
        HeroRole.all,
        HeroRole.carry,
        HeroRole.disabler,
        HeroRole.durable,
        HeroRole.escape,
        HeroRole.initiator,
        HeroRole.jungler,
        HeroRole.nuker,
        HeroRole.pusher
    ]
    
    private var heroList = [Hero]()
    
    internal override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        let useCase = HeroListUseCase()
        self.viewModel = HeroListViewModel(useCase: useCase)
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
        
        title = "Dota Hero Guide"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "HeroCharacterCell", bundle: nil), forCellWithReuseIdentifier: "HeroCharacterCell")
        collectionView.register(UINib(nibName: "RolesSelectionCell", bundle: nil), forCellWithReuseIdentifier: "RolesSelectionCell")

        bindViewModel()
    }
    
    private func bindViewModel() {
        
        guard let viewModel = self.viewModel else { return }
    
        let input = HeroListViewModel.Input(
            didLoadTrigger: Driver.just(()),
            selectedRolesTrigger: selectedRoleSubject.asDriver(onErrorDriveWith: .empty()),
            selectedHeroTrigger: selectedHeroSubject.asDriver(onErrorDriveWith: .empty())
        )
        
        let output = viewModel.transform(input: input)
        
        output.heroList
            .drive(onNext: { [weak self] (response) in
                self?.heroList = response
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.toHeroDetail
            .drive(onNext: { (hero, heroImage) in
                
                let viewController = HeroDetailViewController(nibName: nil, bundle: nil, hero: hero, similarLink: heroImage)
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.error
            .drive(onNext: { [weak self] errorMessage in
                let alert = UIAlertController(title: "Network Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
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
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let selectedItem = roles[indexPath.row]
            self.selectedRoleSubject.onNext(selectedItem)
        } else {
            let selectedHero = heroList[indexPath.row]
            self.selectedHeroSubject.onNext(selectedHero)
        }
    }
}
