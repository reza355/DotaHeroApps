//
//  HeroListViewModel.swift
//  DotaHeroApps
//
//  Created by Fathureza Januarza on 28/09/20.
//  Copyright © 2020 Fathureza Januarza. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

internal final class HeroListViewModel {
    
    private var useCase: HeroListUseCase = HeroListUseCase()
    
    internal struct Input {
        let didLoadTrigger: Driver<Void>
    }
    
    internal struct Output {
        let heroList: Driver<[HeroListResponse]>
    }
    
    internal func transform(input: HeroListViewModel.Input) -> HeroListViewModel.Output {
        
        let getHeroList = input.didLoadTrigger
            .flatMapLatest { [useCase] _ -> Driver<[HeroListResponse]> in
                return useCase.getHeroList()
                    .asDriver(onErrorJustReturn: [])
            }
     
        return Output(heroList: getHeroList)
    }
}

