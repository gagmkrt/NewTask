//
//  SFNetworking.swift
//  Task1
//
//  Created by Gag Mkrtchyan on 24.02.21.
//

import Foundation
import Alamofire

extension SFNetworkService {
    static var environment: SFNetworkEnvironment {
        return .development
    }
    
    private static var networkManager: SessionManager {
        return Alamofire.SessionManager.default
    }
    
    private class func buildPath(_ route: EndPoint) -> URL {
        let baseUrl = "https://randomuser.me"
        var url = URL(string: (baseUrl + route.path).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        if let query = route.queryItem {
            query.forEach { (item) in
                url?.appending(item.key, value: "\(item.value)")
            }
        }
        return url!
    }
}

class SFNetworkService<EndPoint: SFEndPointType> {
    //MARK: - Base networking
    public class func request<T: Codable>(route: EndPoint, completion: @escaping SFNetworkRouterCompletion<T> ) {
        let request = buildRequest(from: route)
//        if !CheckInternet.Connection() {
//            print("No internet connection")
//            return
//        }
        if let formData = route.formData {
            multipartRequest(request: request, formData: formData, completion: completion)
            return
        }
        networkManager.request(request).validate().responseJSON { (response) in
            SFEncoding.jsonParsing(response: response, completion: completion)
        }
    }
    
    public class func multipartRequest<T: Codable>(request: URLRequest, formData: [Data], completion: @escaping SFNetworkRouterCompletion<T> ) {
        networkManager.upload(multipartFormData: { multipartFormData in
            formData.forEach {_ in
                //                multipartFormData.append($0, withName: STRINGKEYS.PHOTO.photo, fileName: String.randomJPG(), mimeType: STRINGKEYS.PHOTO.jpeg)
            }
        }, with: request, encodingCompletion: { response in
            SFEncoding.multipartParsing(response: response, completion: completion)
        })
    }
    
    public class func path(from route: EndPoint) -> URL {
        return buildPath(route)
    }
    
    private class func buildRequest(from route: EndPoint) -> URLRequest {
        
        if route.cancelable {
            networkManager.session.getAllTasks {
                $0.forEach {
                    if $0.originalRequest?.url?.absoluteString.contains(route.path) ?? false {
                        $0.cancel()
                    }
                }
            }
        }
        
        let url = buildPath(route)
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        request.httpBody = route.params
        request.httpMethod = route.httpMethod.rawValue
        request.allHTTPHeaderFields = route.headers
        
        return request
    }
}

extension URL {
    
    mutating func appending(_ queryItem: String, value: String?) {
        
        guard var urlComponents = URLComponents(string: absoluteString) else {
            self = absoluteURL
            return
        }
        
        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        
        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)
        
        // Append the new query item in the existing query items array
        queryItems.append(queryItem)
        
        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems
        
        urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        // Returns the url from new url components
        self = urlComponents.url!
    }
}
