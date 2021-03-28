//
//  ProductServiceMockAPI.swift
//  AdidasCodingChallengeUITests
//
//  Created by Agha Saad Rehman on 28/03/2021.
//

import Foundation
@testable import AdidasCodingChallenge

enum ErrorType{
    case internalError, parsingError, serverError, noError
}


class ProductServiceMockAPI {
    
    var error : ErrorType
    
    var mockResponse = [Product(id: "123", name: "Shoes", description: "Superstars", imgUrl: "www.google.com", price: 1.1, reviews: nil)]
    
    init(with error: ErrorType){
        self.error = error
    }
    
}

extension ProductServiceMockAPI : ProductServiceProtocol {
    func getProducts(completion: @escaping ((Result<[Product], APIError>) -> Void)) {
        switch self.error {
        case .internalError:
            completion(.failure(.internalError))
        case .parsingError:
            completion(.failure(.parsingError))
        case .serverError:
            completion(.failure(.serverError("Mocked Server Error")))
        case .noError:
            completion(.success(mockResponse))
        }
        
    }
}
