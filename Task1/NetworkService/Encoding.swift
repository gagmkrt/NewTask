//
//  Encoding.swift
//  Task1
//
//  Created by Gag Mkrtchyan on 24.02.21.
//

import Foundation
import Alamofire

public typealias SFParameters = [String:Any]

enum SFNetworkEncodingType {
    case applicationJson
    case query
    case defaults

    public var getEncodingType: ParameterEncoding {
        switch self {
        case .applicationJson:
            return JSONEncoding.default
        case .defaults:
            return URLEncoding.default
        case .query:
            return URLEncoding.queryString
        }
    }
}

class SFEncoding {
    class func multipartParsing<T: Codable>(response: SessionManager.MultipartFormDataEncodingResult, completion: @escaping SFNetworkRouterCompletion<T>) {
        switch response {
        case .success(let upload, _, _):
            upload.responseJSON { result in
                jsonParsing(response: result, completion: completion)
            }
        case .failure(let encodingError):
            print("ERROR RESPONSE: \(encodingError)")
            
            completion(.failure(encodingError))
        }
    }
    
    class func jsonParsing<T: Codable>(response: DataResponse<Any>, completion: @escaping SFNetworkRouterCompletion<T>) {

        switch response.result {
        case .success(let value):
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                let responseData = try JSONDecoder().decode(ResponseModel<T>.self, from: jsonData)
                print(responseData)
                completion(.success(responseData.results!))
            } catch {
                debugPrint("Error parsing response data to JSON: \(error.localizedDescription)")
            }
        case .failure(let _error): break

        }
    }
}
