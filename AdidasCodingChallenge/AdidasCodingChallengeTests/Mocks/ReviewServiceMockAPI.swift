//
//  ReviewServiceMockAPI.swift
//  AdidasCodingChallengeTests
//
//  Created by Agha Saad Rehman on 28/03/2021.
//

import Foundation
@testable import AdidasCodingChallenge


class ReviewServiceMockAPI {
    
    var error : ErrorType
    
    var mockResponse = Review(rating: 4, text: "Amazing Shoes!", locale: "en-US", productId: "ABC123")
    
    var existingReviews = [Review(rating: 4, text: "Amazing Shoes!", locale: "en-US", productId: "ABC123")]
    
    init(with error: ErrorType){
        self.error = error
    }
    
}

extension ReviewServiceMockAPI : ReviewServiceProtocol {
    func getReviews(productId: String, completion: @escaping ((Result<[Review], APIError>) -> Void)) {
        switch self.error {
        case .internalError:
            completion(.failure(.internalError))
        case .parsingError:
            completion(.failure(.parsingError))
        case .serverError:
            completion(.failure(.serverError("Mocked Server Error")))
        case .noError:
            if existingReviews.contains(where: { (existingReview) -> Bool in
               productId == existingReview.productId
            }) {
                completion(.success(existingReviews))
            }
            else{
                completion(.failure(.serverError("Id does not Exist")))
            }
            
        }
    }
    
    func submitReview(review: Review, completion: @escaping ((Result<Review, APIError>) -> Void)) {
        switch self.error {
        case .internalError:
            completion(.failure(.internalError))
        case .parsingError:
            completion(.failure(.parsingError))
        case .serverError:
            completion(.failure(.serverError("Mocked Server Error")))
        case .noError:
            if existingReviews.contains(where: { (existingReview) -> Bool in
                review.productId == existingReview.productId
            }) {
                completion(.success(mockResponse))
            }
            else{
                completion(.failure(.serverError("Id does not Exist")))
            }
            
        }
    }
}


