//
//  ViewController.swift
//  AdidasCodingChallenge
//
//  Created by Agha Saad Rehman on 26/03/2021.
//

import UIKit

class ProductsViewController: UIViewController {

    @IBOutlet weak var productsTableView: UITableView!
    
    var products = [Product(id: "F213", name: "Boots", description: "Desc", imageUrl: "https://12312")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsTableViewCell") as! ProductsTableViewCell
        cell.configure(product: products[indexPath.row])
        return cell
    }
}
