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

    var filteredProducts: [ProductViewModel] = []
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    var viewModel = [ProductViewModel]()
    var service : ProductServiceProtocol?
    
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
    
    func filterContentForSearchText(_ searchText: String) {
        filteredProducts = viewModel.filter { (vm: ProductViewModel) -> Bool in
            return (vm.product.name?.lowercased().contains(searchText.lowercased()) ?? false || vm.product.description?.lowercased().contains(searchText.lowercased()) ?? false)
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
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsTableViewCell") as! ProductsTableViewCell
        let product : ProductViewModel
        if isFiltering {
            product = filteredProducts[indexPath.row]
          } else {
            product = viewModel[indexPath.row]
          }
        
        cell.configure(product: product.product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let productVm: ProductViewModel
        if isFiltering {
          productVm = filteredProducts[indexPath.row]
        } else {
          productVm = viewModel[indexPath.row]
        }

        productVm.selection()
    }
}
