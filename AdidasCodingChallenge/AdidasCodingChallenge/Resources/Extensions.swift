//
//  Extensions.swift
//  AdidasCodingChallenge
//
//  Created by Agha Saad Rehman on 27/03/2021.
//

import Foundation

extension Encodable {
    var asJson: Data? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            return jsonData
        } catch {
            return nil
        }
    }
}
