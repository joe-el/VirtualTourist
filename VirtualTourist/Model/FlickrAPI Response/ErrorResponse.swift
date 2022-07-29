//
//  ErrorResponse.swift
//  VirtualTourist
//
//  Created by Kenneth Gutierrez on 7/1/22.
//

import Foundation

struct ErrorResponse: Codable {
    let stat: String
    let code: Int
    let message: String
}

// conform to localized error, now we can provide an error message that's more readable
extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
