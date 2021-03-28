//
//  ProductDetailViewController.swift
//  AdidasCodingChallenge
//
//  Created by Agha Saad Rehman on 27/03/2021.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var productDetailTable: UITableView!
    var product = Product()
    var service : ReviewService!
    var viewModel : ReviewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service = ReviewService()
        if let id = product.id {
            viewModel = ReviewViewModel(productId: id, service: service)
            viewModel.getReviews { (res, err)  in
                if res{
                    DispatchQueue.main.async {
                        self.productDetailTable.reloadSections(IndexSet(integer: 1), with: .automatic)
                    }
                }
                else{
                    print(err?.localizedDescription)
                }
            }
        }
        
    }
    
    
    
    @IBAction func addReviewTapped(_ sender: UIButton) {
        guard let sb = storyboard else {
            return
        }
        
        let vc = sb.instantiateViewController(identifier: "ReviewViewController") as! ReviewViewController
        vc.productId = product.id
        vc.delegate = self
        present(vc, animated: true)
        
    }
}


extension ProductDetailViewController: ReviewDelegate{
    func reviewSent(review: Review) {
        
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel.reviews.append(review)
            strongSelf.productDetailTable.insertRows(at: [IndexPath(row: strongSelf.viewModel.reviews.count-1, section: 1)], with: .automatic)
        }
    }
}


extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else{
            return viewModel.reviews.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return "Reviews"
        } else {
            return product.name
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailTableViewCell") as! ProductDetailTableViewCell
            cell.configure(product: product)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell") as! ReviewTableViewCell
            cell.configure(review: viewModel.reviews[indexPath.row])
            return cell
        }
    }
    
    
}
