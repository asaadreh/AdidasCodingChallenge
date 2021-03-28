//
//  ReviewViewController.swift
//  AdidasCodingChallenge
//
//  Created by Agha Saad Rehman on 27/03/2021.
//

import UIKit
import Cosmos


protocol ReviewDelegate {
    func reviewSent(review: Review)
}

class ReviewViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var reviewAlertView: UIView!
    var delegate : ReviewDelegate!
    
    var service: ReviewService?
    var productId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    
    func setUpUI() {
        reviewAlertView.layer.cornerRadius = 10.0
        reviewAlertView.layer.borderColor = UIColor.lightGray.cgColor
        reviewAlertView.layer.borderWidth = 1.0
        reviewTextView.delegate = self
    }


    @IBAction func doneButtonTapped(_ sender: Any) {
        service = ReviewService()
        
        guard let reviewText = reviewTextView.text,
              let locale = NSLocale.current.languageCode,
              let id = productId else {
            // show error
            return
        }
        let rating = Int(ratingView.rating)
        let review = Review(rating: rating, text: reviewText, locale: locale, productId: id)

        service?.submitReview(review: review, completion: { [weak self] (res) in
            switch res{
            case .success(let review):
                
                self?.delegate.reviewSent(review: review)
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
            
        })
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
