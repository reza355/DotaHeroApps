//
//  HomeListMoyaTarget.swift
//  DotaHeroApps
//
//  Created by Fathureza Januarza on 28/09/20.
//  Copyright © 2020 Fathureza Januarza. All rights reserved.
//

import Foundation
import Moya
import RxSwift

internal enum HeroListMoyaTarget {
    case getHeroList
}

extension HeroListMoyaTarget: TargetType {
    internal var baseURL: URL {
        
        guard let url = URL(string: "https://api.opendota.com/api/herostats") else {
            return NSURL() as URL
        }
        return  url
    }

    internal var path: String {
        switch self {
        case .getHeroList:
            return ""
        }
    }

    internal var method: Moya.Method {
        return .get
    }

    internal var params: [String: Any]? {
          switch self {
              case .getHeroList:
                return nil
              }
    }

    internal var task: Task {
        return .requestPlain
    }

    internal var headers: [String: String]? {
        return nil
    }

    internal var sampleData: Data {
        return Data()
    }
}
