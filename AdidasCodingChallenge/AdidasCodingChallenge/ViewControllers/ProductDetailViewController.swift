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
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

}

extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else{
            return product.reviews!.count
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
            cell.configure(review: product.reviews![indexPath.row])
            return cell
        }
    }
    
    
}
