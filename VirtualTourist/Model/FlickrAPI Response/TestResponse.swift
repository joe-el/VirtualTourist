//
//  TestResponse.swift
//  VirtualTourist
//
//  Created by Kenneth Gutierrez on 7/1/22.
//

import Foundation

struct TestEchoService: Codable {
    struct Method: Codable {
        let methodContent: String
        
        enum CodingKeys: String, CodingKey {
            case methodContent = "_content"
        }
    }
    struct ApiKey: Codable {
        let apiKeyContent: String
        
        enum CodingKeys: String, CodingKey {
            case apiKeyContent = "_content"
        }
    }
    struct Format: Codable {
        let formatContent: String
        
        enum CodingKeys: String, CodingKey {
            case formatContent = "_content"
        }
    }
    
    let method: Method
    let apiKey: ApiKey
    let format: Format
    let stat: String
    
    enum CodingKeys: String, CodingKey {
        case method
        case apiKey = "api_key"
        case format
        case stat
    }
}
