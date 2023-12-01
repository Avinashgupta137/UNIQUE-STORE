//
//  ProductsCollectionViewCell.swift
//  Shopping-App-eCommerce
//
//  Created by Avinash on 1.12.2023.
//

import UIKit

class ProductsCollectionViewCell: UICollectionViewCell {

    //MARK: - Properties
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productRateLabel: UILabel!
    @IBOutlet weak var productPriceLabe: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //koseleri yuvarlaklastirma
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }

}
