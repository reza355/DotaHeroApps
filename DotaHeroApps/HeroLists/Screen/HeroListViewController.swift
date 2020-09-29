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
        return 1
    }

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroList.count
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroCharacterCell", for: indexPath) as? HeroCharacterCell else { return UICollectionViewCell() }

        let hero = self.heroList[indexPath.row]
        cell.setupView(hero: hero)

        return cell
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
