//
//  ViewController.swift
//  AdidasCodingChallenge
//
//  Created by Agha Saad Rehman on 26/03/2021.
//

import UIKit

class ProductsViewController: BaseViewController {

    @IBOutlet weak var productsTableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var refreshControl = UIRefreshControl()
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
        service = ProductService()
        viewModel = ProductViewModel(service: service)
        
        getProducts()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        productsTableView.addSubview(refreshControl)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Products"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @objc func refresh(_ sender: AnyObject) {
        getProducts()
    }
    
    func getProducts() {
        
        viewModel.getProducts { (done, err) in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.refreshControl.endRefreshing()
                if done{
                    
                    strongSelf.productsTableView.reloadData()
                    if strongSelf.viewModel.products.isEmpty {
                        strongSelf.productsTableView.tableFooterView = strongSelf.createErrorView(msg: "No Products have been listed yet.")
                    }
                }
                else{
                    if let err = err {
                        DispatchQueue.main.async { [weak self] in
                            guard let strongSelf = self else {
                                return
                            }
                            strongSelf.productsTableView.tableFooterView = strongSelf.createErrorView(msg: err)
                        }
                    }
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
        if let text = searchBar.text {
            filterContentForSearchText(text)
        }
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
