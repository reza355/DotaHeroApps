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
import RealmSwift

internal final class HeroListViewModel {
    
    private var useCase: HeroListUseCase = HeroListUseCase()
    private var realm: Realm?
    
    internal struct Input {
        let didLoadTrigger: Driver<Void>
        let selectedRolesTrigger: Driver<HeroRole>
    }
    
    internal struct Output {
        let heroList: Driver<[Hero]>
    }
    
    init() {
        do {
            self.realm = try Realm()
        } catch let error as NSError {
            print(error)
        }
    }
    
    internal func transform(input: HeroListViewModel.Input) -> HeroListViewModel.Output {
        
        let firstLoadData = input.didLoadTrigger
            .map { [weak self] _ -> [Hero] in
                
                guard let `self` = self, let realm = self.realm else { return [] }
                
                let heroes = realm.objects(Hero.self)
                
                let heroList: [Hero] = heroes
                    .map { hero -> Hero in
                        return hero
                    }
                
                return heroList
            }
        
        let getHeroList = input.didLoadTrigger
            .flatMapLatest { [useCase] _ -> Driver<[HeroListResponse]> in
                return useCase.getHeroList()
                    .asDriver(onErrorJustReturn: [])
            }
        
        let saveToRealm = getHeroList
            .map { [weak self] response -> [Hero] in
                guard let `self` = self, let realm = self.realm else { return [] }
                
                let realmModel: [Hero] = response
                    .map { (hero: HeroListResponse) -> Hero in
                        let heroRealmModel = Hero()
                        heroRealmModel.id = hero.id
                        heroRealmModel.attackType = hero.attackType.rawValue
                        heroRealmModel.heroName = hero.heroName
                        heroRealmModel.primaryAttribute = hero.primaryAttribute.rawValue
                        heroRealmModel.roles.append(objectsIn: hero.roles)
                        heroRealmModel.baseHealth = hero.baseHealth
                        heroRealmModel.agi = hero.agi
                        heroRealmModel.int = hero.int
                        heroRealmModel.str = hero.str
                        heroRealmModel.maxAttack = hero.maxAttack
                        heroRealmModel.icon = hero.icon
                        heroRealmModel.image = hero.image

                        return heroRealmModel
                    }

                realm.beginWrite()
                realm.add(realmModel)
            
                do {
                    try realm.commitWrite()
                } catch let error as NSError {
                    print(error)
                }
                
                return realmModel
            }
        
        let filteredHero = Driver.combineLatest(
                input.selectedRolesTrigger, Driver.merge(firstLoadData, saveToRealm)
            )
            .map { (role: HeroRole, heroList: [Hero]) -> [Hero] in
                
                guard role != .all else { return heroList }
                
                return heroList.filter { (hero) -> Bool in
                    for heroRole in hero.roles where heroRole == role.rawValue {
                        return true
                    }
                    
                    return false
                }
            }
            
        let heroList = Driver.merge(firstLoadData, saveToRealm, filteredHero)
        
        return Output(heroList: heroList.asDriver())
    }
}

