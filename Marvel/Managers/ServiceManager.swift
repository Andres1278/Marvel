//
//  ServiceManger.swift
//  Marvel
//
//  Created by Pedro Andres Villamil on 14/07/20.
//  Copyright © 2020 Pedro Andres Villamil. All rights reserved.
//

import Foundation
import Alamofire

struct ServiceManger {

    enum Endpoint: String {
        
        static let baseUrl = "https://gateway.marvel.com/v1/public/"
        case characters
        var urlString: String { return Endpoint.baseUrl + rawValue }
    }
       
       private static let publicKey = "2b24df99b9614b6466758d6f2ef5b708"
       private static let hash = "5b99a418a90697fb129bb92c7796a21c"
       private static let timeStamp = 1
    
    public static func request<T: Codable> (to endpoint: String, method: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil,encoding: ParameterEncoding = URLEncoding.default, keypath: String? = nil, completionHandler: ((T?, Error?) -> Void)? = nil) {
        
        request(to: endpoint, method: method, parameters: parameters, headers: headers, encoding: encoding) { (response, error) in
            
            guard var json: Any = response else {
                completionHandler?(nil, error)
                return
            }
            
            if let keyPath = keypath, let outterJson = json as? [String: Any], let innerJson = outterJson[keyPath] {
                json = innerJson
            }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: json, options: [])
                let entries = try JSONDecoder().decode(T.self, from: data as Data)
                completionHandler?(entries, nil)
            } catch {
                print("[ServiceManager] Codable decoding error: \(error)")
                completionHandler?(nil, error)
            }
            
        }
    }
       
    public static func request<T: Codable> (to endpoint: Endpoint, method: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil,encoding: ParameterEncoding = URLEncoding.default, keypath: String? = nil, completionHandler: ((T?, Error?) -> Void)? = nil) {
        
        request(to: endpoint.urlString, method: method, parameters: parameters, headers: headers, encoding: encoding, completionHandler: completionHandler)
    }
       
    public static func request(to endpoint: String, method: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, encoding: ParameterEncoding = URLEncoding.default, completionHandler: (([String : Any]?, NSError?) -> Void)? = nil) {
        
        var allParameters = parameters ?? [:]
        allParameters["ts"] = timeStamp
        allParameters["hash"] = hash
        allParameters["apikey"] = publicKey
        
        guard let url = URL(string: endpoint) else {
            completionHandler?(nil, nil)
            return
        }
        
        AF.request(url, method: method, parameters: allParameters, encoding: encoding, headers: headers).responseJSON { (response) in
            guard let response = response.value as? [String: Any] else {
                completionHandler?(nil, nil)
                return
            }
            
            completionHandler?(response, nil)
        }
    }
}

