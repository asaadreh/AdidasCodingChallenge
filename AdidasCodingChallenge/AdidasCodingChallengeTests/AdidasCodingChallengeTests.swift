//
//  AdidasCodingChallengeTests.swift
//  AdidasCodingChallengeTests
//
//  Created by Agha Saad Rehman on 26/03/2021.
//

import XCTest
@testable import AdidasCodingChallenge

class AdidasCodingChallengeTests: XCTestCase {
    
    var mockProductService: ProductServiceProtocol!
    var productVM: ProductViewModel!
    
    var mockReviewService: ReviewServiceProtocol!
    var reviewVM : ReviewViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testHappyPathForReviewServiceGetReview() {
        
        //if
        mockReviewService = ReviewServiceMockAPI(with: .noError)
        reviewVM = ReviewViewModel(productId: "ABC123", service: mockReviewService)
        
        //given
        reviewVM.getReviews { (success, err) in
            XCTAssertTrue(success)
            XCTAssertEqual(err, nil, "No error")
        }
    }
    
    func testIncorrectProductForReviewServiceGetReview(){
        //if
        mockReviewService = ReviewServiceMockAPI(with: .noError)
        reviewVM = ReviewViewModel(productId: "ABC124", service: mockReviewService)
        
        //given
        reviewVM.getReviews { (success, err) in
            
            //then
            XCTAssertFalse(success)
            XCTAssertNotNil(err)
        }
    }
    
    func testHappyPathForReviewServicePostReview() {
        
        //if
        mockReviewService = ReviewServiceMockAPI(with: .noError)
        reviewVM = ReviewViewModel(productId: "ABC123", service: mockReviewService)
        
        //given
        
        let review = Review(rating: 1, text: "Lovely Shoes", locale: "us-GB", productId: "ABC123")
        
        reviewVM.submitReview(review: review) { (success, review, err) in
            
            // then
            XCTAssertTrue(success)
            XCTAssertEqual(err, nil, "No error")
            XCTAssertNotNil(review)
        }
    }
    
    func testIncorrectProductForReviewServicePostReview() {
        
        //if
        mockReviewService = ReviewServiceMockAPI(with: .noError)
        reviewVM = ReviewViewModel(productId: "ABC123", service: mockReviewService)
        
        //given
        
        let review = Review(rating: 1, text: "Lovely Shoes", locale: "us-GB", productId: "ABC124")
        
        reviewVM.submitReview(review: review) { (success, review, err) in
            
            // then
            XCTAssertFalse(success)
            XCTAssertNil(review)
            XCTAssertNotNil(err)
        }
    }
    
    func testOverallRating() {
        let reviews = [Review(rating: 2, text: "", locale: "", productId: ""),
                       Review(rating: 4, text: "", locale: "", productId: "")]
        let product = Product(id: "", name: "", description: "", imgUrl: "", price: 0, reviews: reviews)
        let rating = product.getOverallRating()
        
        XCTAssertEqual(rating, "3")
        
    }
    
    func testHappyPathForProductService() {
        
        //if
        mockProductService = ProductServiceMockAPI(with: .noError)
        productVM = ProductViewModel(service: mockProductService)
        
        //given
        productVM.getProducts { (success, err) in
            XCTAssertTrue(success)
            XCTAssertEqual(err, nil, "No error")
        }
    }
    
    func testInternalErrorForProductService() {
        
        //if
        mockProductService = ProductServiceMockAPI(with: .internalError)
        productVM = ProductViewModel(service: mockProductService)
        
        //given
        productVM.getProducts { (success, err) in
            XCTAssertFalse(success)
            XCTAssertEqual(err, "Internal Error: ", "Internal error")
        }
    }
    
    func testServerErrorForProductService() {
        
        //if
        mockProductService = ProductServiceMockAPI(with: .serverError)
        productVM = ProductViewModel(service: mockProductService)
        
        //given
        productVM.getProducts { (success, err) in
            XCTAssertFalse(success)
            XCTAssertEqual(err, "Server Error: Mocked Server Error", "Server error is appended with a custom msg")
        }
    }
    
    func testParsingErrorForProductService() {
        
        //if
        mockProductService = ProductServiceMockAPI(with: .parsingError)
        productVM = ProductViewModel(service: mockProductService)
        
        //given
        productVM.getProducts { (success, err) in
            XCTAssertFalse(success)
            XCTAssertEqual(err, "Parsing Error: ", "Parsing Error")
        }
    }
    
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    

}
