//
//  ViewController.swift
//  AdidasCodingChallenge
//
//  Created by Agha Saad Rehman on 26/03/2021.
//

import UIKit

class ProductsViewController: UIViewController {

    @IBOutlet weak var productsTableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)

    var filteredProducts: [Product] = []
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    var viewModel : ProductViewModel!
    var service : ProductServiceProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Adidas Products"
        
        setUp()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Products"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func setUp() {
        service = ProductService()
        viewModel = ProductViewModel(service: service)
        viewModel.getProducts { (done) in
            if done{
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.productsTableView.reloadData()
                }
            }
        }
    }
    
    func select(product: Product) {
        
        guard let sb = storyboard else {
            return
        }
        let vc = sb.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        vc.product = product
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
//    func handleResult(_ result: Result<[ProductViewModel],APIError>) {
//        switch result {
//        case .success(let vm):
//            self.viewModel = vm
//            productsTableView.reloadData()
//        case .failure(let error):
//            print(error)
//        }
//    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredProducts = viewModel.products.filter { (product: Product) -> Bool in
            return (product.name?.lowercased().contains(searchText.lowercased()) ?? false || product.description?.lowercased().contains(searchText.lowercased()) ?? false)
      }
      
      productsTableView.reloadData()
    }

}

extension ProductsViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)

  }
}



extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
           return filteredProducts.count
         }
        return viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsTableViewCell") as! ProductsTableViewCell
        let product : Product
        if isFiltering {
            product = filteredProducts[indexPath.row]
          } else {
            product = viewModel.products[indexPath.row]
          }
        
        cell.configure(product: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product: Product
        if isFiltering {
            product = filteredProducts[indexPath.row]
        } else {
            product = viewModel.products[indexPath.row]
        }

       select(product: product)
    }
}
