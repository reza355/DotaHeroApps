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
    
    private var useCase: HeroListUseCaseProtocol
    private var realm: Realm?
    
    internal struct Input {
        let didLoadTrigger: Driver<Void>
        let selectedRolesTrigger: Driver<HeroRole>
        let selectedHeroTrigger: Driver<Hero>
    }
    
    internal struct Output {
        let heroList: Driver<[Hero]>
        let toHeroDetail: Driver<(Hero, [String])>
        let error: Driver<String>
    }
    
    init(useCase: HeroListUseCaseProtocol) {
        
        self.useCase = useCase
        
        do {
            self.realm = try Realm()
        } catch let error as NSError {
            print(error)
        }
    }
    
    internal func transform(input: HeroListViewModel.Input) -> HeroListViewModel.Output {
        
        let errorSubject = PublishSubject<String>()
        
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
            .flatMapLatest { [useCase, errorSubject] _ -> Driver<[HeroListResponse]> in
                return useCase.getHeroList()
                    .catchError({ error in
                        errorSubject.onNext(error.localizedDescription)
                        return .empty()
                    })
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
                        heroRealmModel.mana = hero.mana
                        heroRealmModel.speed = hero.speed

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
        
        let toHeroDetail = input.selectedHeroTrigger
            .withLatestFrom(heroList) { (selectedHero: Hero, heroList: [Hero]) -> (Hero, [String]) in
                
                let selectedHeroAttribute = selectedHero.primaryAttribute
                
                let heroAttribute = heroList
                    .filter { (hero) -> Bool in
                        return hero.primaryAttribute == selectedHeroAttribute && hero.heroName != selectedHero.heroName
                    }
                
                var sortedHero: [Hero] = []
                
                if selectedHeroAttribute == "int" {
                    sortedHero = heroAttribute.sorted { (hero1, hero2) -> Bool in
                        return hero1.mana > hero2.mana
                    }
                } else if selectedHeroAttribute == "agi" {
                    sortedHero = heroAttribute.sorted { (hero1, hero2) -> Bool in
                        return hero1.speed > hero2.speed
                    }
                } else if selectedHeroAttribute == "str" {
                    sortedHero = heroAttribute.sorted { (hero1, hero2) -> Bool in
                        return hero1.str > hero2.str
                    }
                }
                
                let arraySlice = sortedHero[0..<3]
                let newArray = Array(arraySlice)
                
                let topThreeHeroImage = newArray
                    .map({ (hero: Hero) -> String in
                        return hero.image
                    })
                
                return (selectedHero, topThreeHeroImage)
            }
            
        
        return Output(
            heroList: heroList.asDriver(),
            toHeroDetail: toHeroDetail.asDriver(),
            error: errorSubject.asDriver(onErrorDriveWith: .empty())
        )
    }
}

