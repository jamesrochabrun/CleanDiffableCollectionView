//
//  CompositionalLayout.swift
//  CleanDiffableCollectionView
//
//  Created by james rochabrun on 9/3/20.
//  Copyright © 2020 james rochabrun. All rights reserved.
//

import UIKit

extension NSDirectionalEdgeInsets {
    
    static func all(_ value: CGFloat) -> NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets(top: value, leading: value, bottom: value, trailing: value)
    }
}

enum TOMDiffableCollectionViewSection: Int, CaseIterable {
    
    case contact
    case coupons
    
    // Return:- The height dimension for a header in a section.
    
    @available(iOS 13.0, *)
    var headerHeightDimension: NSCollectionLayoutDimension {
        switch self {
        case .contact: return .estimated(contactSectiontHeaderHeight)
        case .coupons: return .absolute(couponSectiontHeaderHeight)
        }
    }
    
    // Return:- Padding around a header in a section.
    var sectionHeaderInsets: NSDirectionalEdgeInsets {
        .zero
    }
    
    // Return:- Represents the footer height for a section.
    var footerHeight: CGFloat {
        switch self {
        case .contact: return .zero
        case .coupons: return couponSectionFooterHeight
        }
    }
    
    /// Return:- Padding around a footer in a section.
    var sectionFooterInsets: NSDirectionalEdgeInsets {
        .zero
    }
}

/// MARK:- Sections

// 1 - Contacts
private let contactSectiontHeaderHeight: CGFloat = 125 // Represents a contact card height.

// 2 - Coupons
private let couponSectiontHeaderHeight: CGFloat = 40 // Represents a deal title header height
private let couponSectionItemHeight: CGFloat = 96 // Represents a coupon height.
private let couponSectionItemInset: NSDirectionalEdgeInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 8) // Padding around each coupon.
private let couponSectionFooterHeight: CGFloat = 64 // Represents the footer height.
private let estimatedGroupHeightdimensionCouponSection: CGFloat = 350 // The estimated size of a group.

// General
private let tomSectionInset: NSDirectionalEdgeInsets = .zero // Padding around a section.


/**
 Understanding `UICollectionViewCompositionalLayout`
 
 - Every section (`NSCollectionLayoutSection`)  contains a group (`NSCollectionLayoutGroup`).
 - Every group contains an item (`NSCollectionLayoutItem`) <- your cell.
 - Every group can also have nested groups.
 - A group is a set of blocks that determines how your UI will look inside a section.
 */

let minWidthForCoupon: CGFloat = 500


@available(iOS 13, *)
extension UICollectionViewCompositionalLayout {
    
    static func tomCouponLayoutForModel(_ model: TOMMultiColumnCouponViewModel,
                                        scrollBehaviour: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none) -> UICollectionViewLayout {
        
        let sectionProvider = {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = TOMDiffableCollectionViewSection(rawValue: sectionIndex) else { return nil }
            
            let section: NSCollectionLayoutSection
            
            // - Headers and Footer dimensions for sections
            switch sectionKind {
            case .contact:
                // This is a default layout, contact section does not have items, when they do accomodate layout based on design.
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = tomSectionInset
                section.orthogonalScrollingBehavior = scrollBehaviour
                if model.isContactCardAvailable {
                    let sectionHeader = Self.headerConfigurationForSection(.contact)
                    section.boundarySupplementaryItems = [sectionHeader]
                }
            case .coupons:
                
                let columnsCount = Int(round(layoutEnvironment.container.contentSize.width / minWidthForCoupon))

                // - Item
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .absolute(couponSectionItemHeight))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = couponSectionItemInset
                
                // - Group
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(estimatedGroupHeightdimensionCouponSection))
                
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitem: item,
                                                               count: max(columnsCount, 1)) // prevents crash, if count is 0
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = scrollBehaviour
                /// if no coupons no need to display coupons header or footer
                if model.cardModels.isEmpty { break }
                section.contentInsets = .init(top: 0, leading: 8, bottom: 8, trailing: 8)

                var boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
                let sectionHeader = Self.headerConfigurationForSection(.coupons)
                boundarySupplementaryItems = [sectionHeader]
                // Append a view more footer only if there are more coupons than the already displayed.
                if model.cardModels.count > model.maxCouponsInCompactView {
                    let sectionFooter = Self.footerConfigurationForSection(.coupons)
                    boundarySupplementaryItems += [sectionFooter]
                }
                section.boundarySupplementaryItems = boundarySupplementaryItems
            }
            return section
        }
        return  UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    /// Configures a header for specific section
    private static func headerConfigurationForSection(_ section: TOMDiffableCollectionViewSection) -> NSCollectionLayoutBoundarySupplementaryItem {

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: section.headerHeightDimension)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        sectionHeader.contentInsets = section.sectionHeaderInsets
        return sectionHeader
    }
    
    /// Configures a footer for specific section
    private static func footerConfigurationForSection(_ section: TOMDiffableCollectionViewSection) -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(section.footerHeight))
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                                        elementKind: UICollectionView.elementKindSectionFooter,
                                                                        alignment: .bottom)
        sectionFooter.contentInsets = section.sectionFooterInsets
        return sectionFooter
    }
}
