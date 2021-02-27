//
//  HomeService.swift
//  Task1
//
//  Created by Gag Mkrtchyan on 24.02.21.
//

import Foundation
import Alamofire

enum HomeServicePaths: String {
    case get = "/api?results=50"
}


class HomeService {
    class func getList(completion: @escaping SFNetworkRouterCompletion<[ResultModel]>) {
        let rout = BaseEndPoint(path: HomeServicePaths.get.rawValue, httpMethod:.get)
        SFNetworkService.request(route: rout) { (result: SFNetworkRouterResult<[ResultModel]>) in
            result.sync(completion: completion)
        }
    }
}
