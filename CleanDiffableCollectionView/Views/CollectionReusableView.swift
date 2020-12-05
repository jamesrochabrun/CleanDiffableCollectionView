//
//  CollectionReusableView.swift
//  CleanDiffableCollectionView
//
//  Created by james rochabrun on 9/3/20.
//  Copyright © 2020 james rochabrun. All rights reserved.
//

import UIKit

final class CollectionReusableView<T: UIView>: UICollectionReusableView {
    
    typealias ContentConfiguration = (T) -> Void
    
    private let content: T = {
        T()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    func initialize() {
        addSubview(content)
    }
    
    func configureContent(_ configuration: ContentConfiguration) {
        configuration(content)
    }
}
