//
//  Product.swift
//  AdidasCodingChallenge
//
//  Created by Agha Saad Rehman on 27/03/2021.
//

import Foundation


struct Product: Codable {
    var id: String?
    var name: String?
    var description: String?
    var imgUrl: String?
    var price: Float?
    var reviews : [Review]?
}
