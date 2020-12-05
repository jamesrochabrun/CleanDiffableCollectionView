//
//  TOMMultiColumnCouponViewModel.swift
//  CleanDiffableCollectionView
//
//  Created by james rochabrun on 9/3/20.
//  Copyright © 2020 james rochabrun. All rights reserved.
//

import UIKit

struct ProductViewModel: Identifiable {
    
    let id: UUID = UUID()
    let title: String
    let subTitle: String
    let image: UIImage?
    let icon: UIImage?
    
    static var models: [ProductViewModel] {
        [ProductViewModel(title: "Nike", subTitle: "SOme shoes", image: nil, icon: nil),
         ProductViewModel(title: "Nike", subTitle: "SOme shoes", image: nil, icon: nil),
        ProductViewModel(title: "Nike", subTitle: "SOme shoes", image: nil, icon: nil),
        ProductViewModel(title: "Nike", subTitle: "SOme shoes", image: nil, icon: nil),
        ProductViewModel(title: "Nike", subTitle: "SOme shoes", image: nil, icon: nil),
        ProductViewModel(title: "Nike", subTitle: "SOme shoes", image: nil, icon: nil),
        ProductViewModel(title: "Nike", subTitle: "SOme shoes", image: nil, icon: nil),
        ProductViewModel(title: "Nike", subTitle: "SOme shoes", image: nil, icon: nil),
        ProductViewModel(title: "Nike", subTitle: "SOme shoes", image: nil, icon: nil),
        ProductViewModel(title: "Nike", subTitle: "SOme shoes", image: nil, icon: nil),
        ProductViewModel(title: "Nike", subTitle: "SOme shoes", image: nil, icon: nil),
        ProductViewModel(title: "Nike", subTitle: "SOme shoes", image: nil, icon: nil),
        ProductViewModel(title: "Nike", subTitle: "SOme shoes", image: nil, icon: nil),
        ProductViewModel(title: "Nike", subTitle: "SOme shoes", image: nil, icon: nil),
        ProductViewModel(title: "Nike", subTitle: "SOme shoes", image: nil, icon: nil),
        ProductViewModel(title: "Nike", subTitle: "SOme shoes", image: nil, icon: nil),
        ProductViewModel(title: "Nike", subTitle: "SOme shoes", image: nil, icon: nil)]
    }
}


class MessageCouponModel {
    var maxCouponsInCompactView: Int { 4 }
    var isExpanded: Bool = false
}

class MessageContactModel {
    
}

final class TOMMultiColumnCouponViewModel {
    
    var cardModels: [ProductViewModel] = ProductViewModel.models
    var isContactCardAvailable = true
    var maxCouponsInCompactView = 4
    
    var couponModel: MessageCouponModel = MessageCouponModel()
    var couponSectionFooterTitle: String {
        "some title"
    }

    var isCouponsExpanded: Bool {
          get {
              couponModel.isExpanded
          }
          set {
              couponModel.isExpanded = newValue
          }
      }
    // Returns an array of `TOMDiffableContent.Feed` depending on the `isCouponsExpanded` state.
    var diffableContent: [TOMDiffableContent.Feed]  {
        return isCouponsExpanded ? expandedContent : nonExpandedContent
    }
    
    // Returns an array of `TOMDiffableContent.Feed` objects prefixed by `maxCouponsInCompactView`
    private var nonExpandedContent: [TOMDiffableContent.Feed]  {
//        guard let couponModel = couponModel else { return [] }
        let couponsToDisplay = Array(cardModels.prefix(couponModel.maxCouponsInCompactView))
        return couponsToDisplay.map { TOMDiffableContent.Feed.coupon($0, couponModel) }
    }
    
    // Returns an array of `TOMDiffableContent.Feed` objects instantiated with all the
    // available couponModels.
    private var expandedContent: [TOMDiffableContent.Feed]  {
//        guard let couponModel = couponModel else { return [] }
        return cardModels.map { TOMDiffableContent.Feed.coupon($0, couponModel) }
    }
}


final class TOMDiffableContent {
    
    enum Feed: Hashable {
        
        var id: UUID { UUID() }
        
        static func == (lhs: TOMDiffableContent.Feed, rhs: TOMDiffableContent.Feed) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        case coupon(ProductViewModel, MessageCouponModel)
    }
}
