//
//  ViewController.swift
//  AdidasCodingChallenge
//
//  Created by Agha Saad Rehman on 26/03/2021.
//

import UIKit

class ProductsViewController: UIViewController {

    @IBOutlet weak var productsTableView: UITableView!
    
    var viewModel = [ProductViewModel]()
    
    var service : ProductServiceProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    func setUp() {
        service = ProductService()
        service?.getProducts(completion: { [self] (res) in
            DispatchQueue.main.async {
                handleResult(res.map({ products in
                    products.map({product in
                        ProductViewModel(product: product, selection: {
                            self.select(product: product)
                        })
                    })
                }))
            }
        })
    }
    
    func select(product: Product) {
        
        guard let sb = storyboard else {
            return
        }
        let vc = sb.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        vc.product = product
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func handleResult(_ result: Result<[ProductViewModel],APIError>) {
        switch result {
        case .success(let vm):
            self.viewModel = vm
            productsTableView.reloadData()
        case .failure(let error):
            print(error)
        }
    }
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsTableViewCell") as! ProductsTableViewCell
        cell.configure(product: viewModel[indexPath.row].product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel[indexPath.row].selection()
    }
}
