//
//  NetworkService.swift
//  Task1
//
//  Created by Gag Mkrtchyan on 24.04.21.
//

import UIKit

class NetworkService {
    
    private var baseApi = BaseApi()
    static let shared = NetworkService()
    
    //MARK: - Public Methods -
    
    public func getRequest(params: [String:Any]?,
                           headers: [String:Any]?,
                           urlString: String,
                           completion:@escaping ([String: Any]?, Error?)->Void) {
        
        let url = urlString + makeQuerryParams(from: params)
        
        
        self.baseApi.executeRequest(with: nil,
                                    requestType: "GET",
                                    headers: headers,
                                    urlString: url) { (result, error) in
            completion(result,error)
        }
    }
    
//    public func getArrayRequest(params: [String:Any]?,
//                           headers: [String:Any]?,
//                           urlString: String,
//                           completion:@escaping ([[String: Any]]?, Error?)->Void) {
//
//        let url = urlString + makeQuerryParams(from: params)
//        self.baseApi.executeArrayRequest(with: nil,
//                                    requestType: "GET",
//                                    headers: headers,
//                                    urlString: url) { (result, error) in
//            completion(result,error)
//        }
//    }
    
    public func postRequest(params: [String:Any]?,
                           headers: [String:Any]?,
                           urlString: String,
                           completion:@escaping ([String: Any]?, Error?)->Void) {
        
        self.baseApi.executeRequest(with: params,
                                    requestType: "POST",
                                    headers: headers,
                                    urlString: urlString) { (result, error) in
            completion(result,error)
        }
    }

    public func putRequest(params: [String:Any]?,
                           headers: [String:Any]?,
                           urlString: String,
                           completion:@escaping ([String: Any]?, Error?)->Void) {
        
        self.baseApi.executeRequest(with: params,
                                    requestType: "PUT",
                                    headers: headers,
                                    urlString: urlString) { (result, error) in
            completion(result,error)
        }
    }
    
    //MARK: - Private Methods -
    
    private func makeQuerryParams(from dict: [String: Any]?) -> String {
        
        guard let dict = dict else {return ""}
        var querry = "?"
        for key in dict.keys {

            if let value = dict[key] {
                
                if value is [String] {
                    
                    let str = key + "=" + makeStringFromArray(array: value as! [String]) + "&"
                    querry += str
                } else if value is String {
                    
                    let str = key + "=" + (value as! String) + "&"
                    querry += str
                } else if let value = value as? Double  {
                    
                    let str = key + "=" + String(value) + "&"
                    querry += str
                }
            }
        }
        
        
        
        return String(querry.dropLast())
    }
    
    private func makeStringFromArray(array: [String]) -> String {
        
        var str = ""
        array.enumerated().forEach { (index, string) in
            
            if index != 0 {
                str += ","
            }
            str += string
        }
        return str
    }
}
