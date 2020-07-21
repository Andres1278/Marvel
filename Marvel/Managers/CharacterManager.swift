//
//  CharacterManager.swift
//  Marvel
//
//  Created by Pedro Andres Villamil on 14/07/20.
//  Copyright © 2020 Pedro Andres Villamil. All rights reserved.
//

import Foundation
import Alamofire

struct CharacterManager {
    
    struct CharacterListResponse: Codable {
        
        struct CharacterData: Codable {
            let results: [Character]
        }
        let code: Int
        let data: CharacterData
    }
    
    static func getAllCharacters(completion: @escaping (([Character]?) -> () )) {
        ServiceManger.request(to: .characters,encoding: URLEncoding.queryString) { (response: CharacterListResponse?, error) in
            completion(response?.data.results)
        }
    }
    
    static func getURLs(from urlString: String, completion: @escaping (ResourceURL?) -> ()) {
        ServiceManger.request(to: urlString.replacingOccurrences(of: "http", with: "https"), encoding: URLEncoding.queryString , keypath: "data") { (response: ResourceURL.ResourceURLResponse?, error) in
            completion(response?.results.first)
        }
    }
}
