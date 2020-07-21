//
//  Character.swift
//  Marvel
//
//  Created by Pedro Andres Villamil on 14/07/20.
//  Copyright © 2020 Pedro Andres Villamil. All rights reserved.
//

import Foundation

struct Character: Codable {
    
    struct Thumbnail: Codable {
        let path: String
        let `extension`: String
        var url: URL? {
            return URL(string: "\(path.replacingOccurrences(of: "http", with: "https"))/portrait_incredible.\(`extension`)")
        }
    }
    
    struct Item: Codable {
        let name: String
        let resourceURI: String
    }
    
    struct Comic: Codable {
        let available: Int
        let items: [Item]
    }
    
    struct Serie: Codable {
        let available: Int
        let items: [Item]
    }

    let name: String
    let description: String
    let thumbnail: Thumbnail
    let comics: Comic
    let series: Serie
}
