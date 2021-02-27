//
//  Router.swift
//  Task1
//
//  Created by Gag Mkrtchyan on 24.02.21.
//

import Foundation
import Alamofire
import UIKit

enum SFNetworkEnvironment {
    // production type use for live version
    case production
    // development type use for debug mode
    case development
    // adds to base url
    var root: String { return "/v1" }
    //
    // returns base url
    // by checking enum type
    //
    var url: String {
        switch self {
        case .production:
            return ""
        case .development:
            return ""
        }
    }
}

public enum SFNetworkRouterResult<Value> {
    case success(Value)
    case failure(Error)
}

protocol SFEndPointType {
    var path: String { get }
    var params: Data? { get }
    var formData: [Data]? { get }
    var headers: HTTPHeaders? { get }
    var queryItem: QueryItem? { get }
    var httpMethod: HTTPMethod { get }
    var encoding: SFNetworkEncodingType { get }
    var cancelable: Bool { get }
}

struct BaseEndPoint: SFEndPointType {
    //
    // url path for data request
    //
    var path: String
    //
    // params adds to reqest body
    // default is nil
    //
    var params: Data?
    //
    // form data param
    // default is nil
    //
    var formData: [Data]?
    //
    // query params dict
    // default is nil
    //
    var queryItem: QueryItem?
    //
    // header params
    // default is nil
    //
    var headers: HTTPHeaders?
    //
    // http request method enum type
    //
    var httpMethod: HTTPMethod
    //
    // data encoding type enum
    //
    var encoding: SFNetworkEncodingType
    //
    // cancel request
    //
    var cancelable: Bool
    //
    // init
    //
    init(path: String, params: Data? = nil, formData: [Data]? = nil, queryItem: QueryItem? = nil, headers: HTTPHeaders? = nil, httpMethod: HTTPMethod, encoding: SFNetworkEncodingType = .defaults, cancelable: Bool = false) {
        self.path = path
        self.params = params
        self.formData = formData
        self.queryItem = queryItem
        self.httpMethod = httpMethod
        self.encoding = encoding
        self.cancelable = cancelable

        headers != nil ? (self.headers(with: headers!)) : self.defaultHeader()
    }
    //
    // add default data to HTTPHeaders
    //
    mutating func defaultHeader() {
//        headers = [String: String]()
//
//        headers?["Content-Type"] = "application/json"
//        headers?["OsType"] = "2"
//
//        UIDevice.current.identifierForVendor.val { (value) in
//            headers?["DeviceId"] = "\(value.uuidString)"
//        }
////
////        Messaging.messaging().fcmToken.val { (value) in
////            headers?["DeviceToken"] = value
////        }
////
//        SettingsManager.token.val { (value) in
//            headers?["Authorization"] = "Bearer \(value)"
//            print(value)
//        }

//        if let token = SFHelper.getSaveData(forKey: KeyPath.token) {
//            headers?["Authorization"] = token as? String
//            print("Bearer \(token)")
//
//        }
 }

    mutating func headers(with dict:[String: String]) {
//        self.defaultHeader()
//        for (key, value) in dict {
//            headers?[key] = value
//        }
    }
}

/// A dictionary of query params  to apply to a `URLComponents`.
public typealias QueryItem = [String: Any]

public typealias SFNetworkRouterCompletion<T: Codable> = ((SFNetworkRouterResult<T>) -> Void)

extension SFNetworkRouterResult {
    func sync<T: Codable>(completion: @escaping SFNetworkRouterCompletion<T>) {
        switch self {
        case .success(let data):
            print(data)
            completion(.success(data as! T))
        case .failure(let error):
            print("fail")
            completion(.failure(error))
        }
    }
}

//class SettingsManager {
//    class var token: String? {
//        get {
//            return UserDefaults.get(forKey: "tokken") as? String
//        }
//        set {
//            if let value = newValue {
//                UserDefaults.save(value: value, forKey: "tokken")
//            } else {
//                UserDefaults.delete(forKey: "tokken")
//            }
//        }
//    }
//}
//
//extension UserDefaults {
//
//    internal static func save(value: Any, forKey: String) {}
//
//    internal static func get(forKey: String) -> Any? { return forKey}
//
//    internal static func delete(forKey: String) {}
//
//}
