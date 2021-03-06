//
//  ProductService.swift
//  AdidasCodingChallenge
//
//  Created by Agha Saad Rehman on 27/03/2021.
//

import Foundation

enum APIError: Error {
    case internalError
    case serverError(String)
    case parsingError
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .serverError(let desc):
            return "Server Error: " + desc
        case .internalError:
            return "Internal Error: "
        case .parsingError:
            return "Parsing Error: "
        }
    }
}

protocol ProductServiceProtocol {
    func getProducts(completion: @escaping((Result<[Product],APIError>) -> Void))
}


class ProductService : ProductServiceProtocol {
    
    private let baseURL = "http://localhost:3001"
    let defaultSession = URLSession(configuration: .ephemeral)
    var dataTask: URLSessionDataTask?
    private enum EndPoint : String {
        case productList = "/product"
    }
    
    private enum Method: String {
        case GET
    }
    
    func getProducts(completion: @escaping ((Result<[Product], APIError>) -> Void)) {
        let endpoint :EndPoint = .productList
        let path = "\(baseURL)\(endpoint.rawValue)"
        guard let url = URL(string: path) else {
            completion(.failure(.internalError))
            return
        }
        
        dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.serverError(error.localizedDescription)))
            } else if let data = data {
                
                let decoder = JSONDecoder()
                
                do {
                    let products = try decoder.decode([Product].self, from: data)
                    completion(.success(products))
                } catch {
                    completion(.failure(.parsingError))
                }
            }
        }
        
        dataTask?.resume()
    }
    

    
}
