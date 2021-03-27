//
//  ProductViewModel.swift
//  AdidasCodingChallenge
//
//  Created by Agha Saad Rehman on 27/03/2021.
//

import Foundation

struct ProductViewModel {
    var product: Product
    var selection : () -> Void
    
    init(product: Product, selection: @escaping () -> Void) {
        self.product = product
        self.selection = selection
    }
}
