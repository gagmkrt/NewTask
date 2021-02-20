//
//  NetworkService.swift
//  Task1
//
//  Created by Gag Mkrtchyan on 18.02.21.
//

import Foundation
import Alamofire

class NetWorkService {
    
    private static let baseUrl = "https://randomuser.me"
    private static let alamofireSessionMeneger = Alamofire.Session.default
    
    class func request<T:Codable>(url: String, method: HTTPMethod, param:Parameters?, encoding: JSONEncoding, complition: @escaping (T) -> Void ) {
        alamofireSessionMeneger.request(baseUrl + url, method: method, parameters: param, encoding: encoding).responseJSON { (resp) in
            switch resp.result {
            case.success(let data):
                print(data)
                do {
                    let json = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    let responseData = try JSONDecoder().decode(BaseResponse.self, from: json)
                    if responseData.info != nil {
                        print("success")
                    } else {
                        print("error")
                    }
                } catch {
                    print(error)
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


