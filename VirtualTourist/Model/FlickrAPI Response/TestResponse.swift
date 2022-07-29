//
//  TestResponse.swift
//  VirtualTourist
//
//  Created by Kenneth Gutierrez on 7/1/22.
//

import Foundation

struct FormatContent: Codable {
    let formatContent: String
    
    enum CodingKeys: String, CodingKey {
        case formatContent = "_content"
    }
}

struct ApiContent: Codable {
    let apiContent: String
    
    enum CodingKeys: String, CodingKey {
        case apiContent = "_content"
    }
}

struct NameContent: Codable {
    let nameContent: String
    
    enum CodingKeys: String, CodingKey {
        case nameContent = "_content"
    }
}

struct MethodContent: Codable {
    let methodContent: String
    
    enum CodingKeys: String, CodingKey {
        case methodContent = "_content"
    }
}

// root object
struct TestResponse: Codable {
    let method: MethodContent
    let name: NameContent
    let apiKey: ApiContent
    let format: FormatContent
    let stat: String
    
    enum CodingKeys: String, CodingKey {
        case method
        case name
        case apiKey = "api_key"
        case format
        case stat
    }
}
