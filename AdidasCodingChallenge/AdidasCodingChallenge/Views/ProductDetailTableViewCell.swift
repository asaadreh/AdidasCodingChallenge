//
//  ProductDetailTableViewCell.swift
//  AdidasCodingChallenge
//
//  Created by Agha Saad Rehman on 27/03/2021.
//

import UIKit
import Kingfisher

class ProductDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configure(product: Product) {
        
        productImage.kf.setImage(with: URL(string: product.imgUrl ?? ""))
        productDescription.text = product.description
        productName.text = product.name
        productPrice.text = String(product.price ?? 0.0)
    }
    
}
