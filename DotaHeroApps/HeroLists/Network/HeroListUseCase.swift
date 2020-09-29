//
//  HomeListUseCase.swift
//  DotaHeroApps
//
//  Created by Fathureza Januarza on 28/09/20.
//  Copyright © 2020 Fathureza Januarza. All rights reserved.
//

import Foundation
import Moya
import RxSwift

internal protocol HeroListUseCaseProtocol {
    func getHeroList() -> Observable<[HeroListResponse]>
}

internal class HeroListUseCase: HeroListUseCaseProtocol {
    
    private let provider: MoyaProvider<HeroListMoyaTarget> = MoyaProvider<HeroListMoyaTarget>(plugins: [NetworkLoggerPlugin()])
    private let decoder: JSONDecoder = JSONDecoder()
    
    internal func getHeroList() -> Observable<[HeroListResponse]> {
        return provider.rx.request(.getHeroList).debug("BROOOOOOO")
            .map([HeroListResponse].self)
            .asObservable()
    }
    
}
