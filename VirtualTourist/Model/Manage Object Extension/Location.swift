//
//  Location.swift
//  VirtualTourist
//
//  Created by Kenneth Gutierrez on 7/4/22.
//

import Foundation

struct Location: Codable {
    let latitude: Double
    let longitude: Double
    let location: String
    let country: String
    
    enum CodingKeys: String, CodingKey {
        case location, country, latitude, longitude
    }
}
