//
//  Reviews.swift
//  AdidasCodingChallenge
//
//  Created by Agha Saad Rehman on 27/03/2021.
//

import Foundation

struct Review: Codable {
    var rating: Int?
    var text: String?
    var locale: String?
    var productId: String
}
