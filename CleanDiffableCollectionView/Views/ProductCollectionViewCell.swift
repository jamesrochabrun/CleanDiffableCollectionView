//
//  ProductCollectionViewCell.swift
//  CleanDiffableCollectionView
//
//  Created by james rochabrun on 9/3/20.
//  Copyright © 2020 james rochabrun. All rights reserved.
//

import UIKit


final class ProductCollectionViewCell: GenericCollectionViewCell<ProductViewModel> {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var accessoryLabel: UILabel!
    
    override func setupWith(_ item: ProductViewModel) {
        titleLabel.text = item.title
        subTitleLabel.text = item.subTitle
    }
}


