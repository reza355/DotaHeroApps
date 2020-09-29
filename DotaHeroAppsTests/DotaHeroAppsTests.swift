//
//  DotaHeroAppsTests.swift
//  DotaHeroAppsTests
//
//  Created by Fathureza Januarza on 28/09/20.
//  Copyright © 2020 Fathureza Januarza. All rights reserved.
//

import XCTest
import RxSwift

@testable import DotaHeroApps

class DotaHeroAppsTests: XCTestCase {

    internal var useCase: HeroListUseCaseMock!
    internal var viewModel: HeroListViewModel!
    
    override func setUp() {
        super.setUp()
        self.useCase = HeroListUseCaseMock()
        self.viewModel = HeroListViewModel(useCase: useCase)
    }
    
    override func tearDown() {
        self.useCase = nil
        self.viewModel = nil
    }
        
    
    

}

internal class HeroListUseCaseMock: HeroListUseCaseProtocol {
    
    internal var heroListResponse: Observable<[HeroListResponse]>!
    
    func getHeroList() -> Observable<[HeroListResponse]> {
        return heroListResponse
    }
}
