//
//  ResourceURLs.swift
//  Marvel
//
//  Created by Pedro Andres Villamil on 14/07/20.
//  Copyright © 2020 Pedro Andres Villamil. All rights reserved.
//

import Foundation

struct ResourceURL: Codable {
    
    struct ResourceURLResponse: Codable {
        let results: [ResourceURL]
    }
    
    struct URL: Codable {
        let type: String
        let url: String
    }
    
    let urls: [URL]
}
