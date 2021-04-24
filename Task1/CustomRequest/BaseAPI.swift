//
//  BaseAPI.swift
//  Task1
//
//  Created by Gag Mkrtchyan on 24.04.21.
//

import Foundation

class BaseApi {
    
    func executeRequest(with params: Dictionary<String, Any>?,
                        requestType: String,
                        headers: Dictionary<String, Any>?,
                        urlString: String,
                        completion:@escaping ([String: Any]?, Error?)->Void) {
        
            
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = requestType
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("ios", forHTTPHeaderField: "platform")
        
        if let headers = headers {
            for key in headers.keys {
                request.setValue(headers[key] as? String ?? "", forHTTPHeaderField: key)
            }
        }
       
        
        if let params = params {
            if let data = try? JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed) {
                request.httpBody = data
            }
        }
        
        request.timeoutInterval = 60
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, responce, error) in
            
            DispatchQueue.main.async {
                
                if error == nil {
                    if let responce = responce as? HTTPURLResponse, responce.statusCode >= 200 || responce.statusCode <= 300 {
                        if let data = data  {
                            
                            if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
                                completion(json, nil)
                            } else {
                                print("JSONSerialization failure")
                            }
                        } else {
                            completion(nil, nil)
                        }
                    } else {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil,error)
                }
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func executeArrayRequest(with params: Dictionary<String, Any>?,
                        requestType: String,
                        headers: Dictionary<String, Any>?,
                        urlString: String,
                        completion:@escaping ([[String: Any]]?, Error?)->Void) {
        
            
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = requestType
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("ios", forHTTPHeaderField: "platform")
        
        if let headers = headers {
            for key in headers.keys {
                request.setValue(headers[key] as? String ?? "", forHTTPHeaderField: key)
            }
        }
       
        
        if let params = params {
            if let data = try? JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed) {
                request.httpBody = data
            }
        }
        
        request.timeoutInterval = 60
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, responce, error) in
            
            DispatchQueue.main.async {
                
                if error == nil {
                    if let responce = responce as? HTTPURLResponse, responce.statusCode >= 200 || responce.statusCode <= 300 {
                        if let data = data  {
                            
                            if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:Any]] {
                                completion(json, nil)
                            } else {
                                print("JSONSerialization failure")
                            }
                        } else {
                            completion(nil, nil)
                        }
                    } else {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil,error)
                }
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
