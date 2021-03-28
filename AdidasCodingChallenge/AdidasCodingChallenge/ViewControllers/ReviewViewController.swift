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

class ReviewViewController: BaseViewController, UITextViewDelegate {

    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var reviewAlertView: UIView!
    var delegate : ReviewDelegate!
    
    var service: ReviewServiceProtocol!
    var productId: String?
    var viewModel : ReviewViewModel!
    
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
        ratingView.rating = 2
    }


    @IBAction func doneButtonTapped(_ sender: Any) {
        
        
        guard let reviewText = reviewTextView.text,
              let locale = NSLocale.current.languageCode,
              let id = productId else {
            // show error
            return
        }
        let rating = Int(ratingView.rating)
        let review = Review(rating: rating, text: reviewText, locale: locale, productId: id)
        
        service = ReviewService()
        viewModel = ReviewViewModel(productId: id, service: service)
        viewModel.submitReview(review: review) { (success,review,err) in
            DispatchQueue.main.async {
                if success {
                    if let review = review {
                        self.delegate.reviewSent(review: review)
                    }
                    self.dismiss(animated: true)
                }
                else {
                    if let err = err {
                        self.presentAlert(title: "Error", msg: err, handler: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
