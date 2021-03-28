//
//  ReviewViewModel.swift
//  AdidasCodingChallenge
//
//  Created by Agha Saad Rehman on 27/03/2021.
//

import Foundation




class ReviewViewModel {
    var reviews : [Review] = []
    var service : ReviewService
    var productId : String
    
    init(productId : String, service: ReviewService) {
        self.service = service
        self.productId = productId
        
        
    }
    
    func getReviews(completion: @escaping (Bool, Error?) -> Void) {
        service.getReviews(productId: productId) { (res) in
            switch res{
            case .success(let reviews):
                self.reviews = reviews
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
    
}
