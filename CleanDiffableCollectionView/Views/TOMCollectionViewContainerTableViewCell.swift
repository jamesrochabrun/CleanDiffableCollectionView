//
//  TOMCollectionViewContainerTableViewCell.swift
//  CleanDiffableCollectionView
//
//  Created by james rochabrun on 9/3/20.
//  Copyright © 2020 james rochabrun. All rights reserved.
//

import UIKit


protocol TOMCollectionViewContainerTableViewCellDelegate: AnyObject {
    func updateUI()
}


final class TOMCollectionViewContainerTableViewCell: GenericTableViewCell<TOMMultiColumnCouponViewModel> {
    @IBOutlet private var containerCollectionView: TOMDiffableCollectionView! {
        didSet {
            containerCollectionView.delegate = self
        }
    }
    weak var delegate: TOMCollectionViewContainerTableViewCellDelegate?
    
    override func setupSubviews() {
        contentView.addBorder(.green, borderWidth: 1.0)
    }
    
    override func setupWith(_ viewModel: TOMMultiColumnCouponViewModel) {
        containerCollectionView.viewModel = viewModel
      //  contentView.layoutIfNeeded()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
            // `collectionView.contentSize` has a wrong width because in this nested example, the sizing pass occurs before the layout pass,
            // so we need to force a layout pass with the correct width.
            self.contentView.frame = self.bounds
        
            self.contentView.layoutIfNeeded()
            // Returns `collectionView.contentSize` in order to set the UITableVieweCell height a value greater than 0.
        let size = self.containerCollectionView.collectionView.contentSize
        let newSize: CGSize = .init(width: size.width, height: size.height + 20)
        return newSize// self.containerCollectionView.collectionView.contentSize
        }
}


// MARK:- TOMDiffableCollectionViewDelegate
extension TOMCollectionViewContainerTableViewCell: TOMDiffableCollectionViewDelegate {
    
    func updateContainerHeight(_ value: CGFloat) {

    }
    
    func performBatchUpdate() {

        delegate?.updateUI()
    }
}
