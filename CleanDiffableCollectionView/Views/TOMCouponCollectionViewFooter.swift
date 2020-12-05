//
//  TOMCouponCollectionViewFooter.swift
//  CleanDiffableCollectionView
//
//  Created by james rochabrun on 9/3/20.
//  Copyright © 2020 james rochabrun. All rights reserved.
//

import UIKit

final class TOMCouponCollectionViewFooter: BaseXibView {
        
    var viewMoreTapped: (() -> String)?
    
    @IBOutlet private var viewMoreButton: UIButton!

    // MARK:- Configuration
    func configureButtonTitle(_ title: String) {
        viewMoreButton?.setTitle(title, for: .normal)
    }
    
    @IBAction func viewMoreTapped(_ sender: UIButton) {
        let title = viewMoreTapped?() ?? ""
        configureButtonTitle(title)
    }
}
