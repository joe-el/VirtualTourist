//
//  Flickr.swift
//  VirtualTourist
//
//  Created by Kenneth Gutierrez on 7/1/22.
//

import Foundation

// root of the entire JSON object—Flickr Search Photo.
struct FlickrPhotos: Codable {
    let photos: Photos
    
    struct Photos: Codable {
        let page: Int!
        let pages: Int!
        let perPage: Int!
        let total: Int!
        let photo: [Photo]
        
        enum CodingKeys: String, CodingKey {
            case page
            case pages
            case perPage = "perpage"
            case total
            case photo
        }
        
        struct Photo: Codable {
            let id: String
            let owner: String
            let secretKey: String
            let server: String
            let farm: Int!
            let title: String
            let isPublic: Int!
            let isFriend: Int!
            let url: URL?
            let heightMedium: Int!
            let widthMedium: Int!
            
            enum CodingKeys: String, CodingKey {
                case id
                case owner
                case secretKey = "secret"
                case server
                case farm
                case title
                case isPublic = "ispublic"
                case isFriend = "isfriend"
                case url = "url_m"
                case heightMedium = "height_m"
                case widthMedium = "width_m"
            }
        }
    }
    let stat: String
}
