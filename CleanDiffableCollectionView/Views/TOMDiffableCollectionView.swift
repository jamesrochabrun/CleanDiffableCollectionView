//
//  TOMDiffableCollectionView.swift
//  CleanDiffableCollectionView
//
//  Created by james rochabrun on 9/3/20.
//  Copyright © 2020 james rochabrun. All rights reserved.
//

import UIKit

// MARK:- Protocol
protocol TOMDiffableCollectionViewDelegate: AnyObject {
    // UI related
    
    // updates the height of the cell container and
    // performs a table view batch update.
    func performBatchUpdate()

}

@available(iOS 13, *)
final class TOMDiffableCollectionView: BaseXibView {
    
    // MARK:- Constants
    static let collectionViewContentSizePath = "contentSize"
    static let footerKind = "UICollectionElementKindSectionFooter"
    
    // MARK:- Type Aliasese
    private typealias DiffDataSource = UICollectionViewDiffableDataSource<TOMDiffableCollectionViewSection, TOMDiffableContent.Feed>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<TOMDiffableCollectionViewSection, TOMDiffableContent.Feed>
    
    // MARK:- Diffable Data Source
    private var dataSource: DiffDataSource?
    private var currentSnapshot: Snapshot?
    
    // MARK:- Public properties
    weak var delegate: TOMDiffableCollectionViewDelegate?
    
    // MARK:- UI
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            
            collectionView.isScrollEnabled = false
            collectionView.showsVerticalScrollIndicator = false
            /// Represents the Contact Card.
            collectionView.registerHeader(CollectionReusableView<TOMContactCardActionableView>.self, kind: UICollectionView.elementKindSectionHeader)
            /// Represents a coupons section title.
            collectionView.registerHeader(CollectionReusableView<TOMCouponBrandTitleHeaderView>.self, kind: UICollectionView.elementKindSectionHeader)
            /// Represents a coupon.
            collectionView.registerNib(ProductCollectionViewCell.self)
            /// Represents the `view More` button placed as footer
            collectionView.registerHeader(CollectionReusableView<TOMCouponCollectionViewFooter>.self, kind: UICollectionView.elementKindSectionFooter)
        }
    }
        
    // MARK:- Dependency injection
    var viewModel: TOMMultiColumnCouponViewModel? {
        didSet {
            guard let model = viewModel else { return }
            setupLayoutWith(viewModel: model)
            registerHeadersAndFootersFor(viewModel: model)
            applySnapshot(viewModel: model, animatingDifferences: false)
        }
    }
    
    // MARK:- LifeCycle
    override func setUpViews() {
        backgroundColor = .clear
        addBorder(.red, borderWidth: 3.0)
        collectionView.addBorder(.yellow, borderWidth: 2.0)
        configureTheme()
        configureDataSource()
       // observe(.ConversationDetailDisplayModeWillChange, onReceived: displayModeWillChange)
    }

    func displayModeWillChange(_ notification: Notification) {
        currentSnapshot?.reloadSections([.contact])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK:- Theme
    func configureTheme() {
        collectionView?.backgroundColor = .white
    }

    // MARK:- 1: DataSource Configuration
    private func configureDataSource() {
        dataSource = DiffDataSource(collectionView: collectionView) { collectionView, indexPath, model in
            let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            switch model {
            case .coupon(let couponCard, _):
                cell.item = couponCard
            }
            return cell
        }
    }
//
    // MARK:- 2: Layout Configuration
    /**
     Compositional layout handles the layout based in sections, available sections are part of `TOMDiffableCollectionViewSection`  cases.
     - Contacts:
        - Displays the contact card as a header.
        - Does not contain any element inside the section, we can add them easily if  design or product requires  it.
     - Coupons:
        - Displays a `TOMCouponBrandTitleHeaderView` as a header.
        - Contains an array of  coupons for the section.
     */
    private func setupLayoutWith(viewModel: TOMMultiColumnCouponViewModel) {
        self.collectionView?.collectionViewLayout = UICollectionViewCompositionalLayout.tomCouponLayoutForModel(viewModel)
    }
    
    /// Headers and footers configurtaion are part of the data source configuration.
    private func registerHeadersAndFootersFor(viewModel: TOMMultiColumnCouponViewModel) {
        
        dataSource?.supplementaryViewProvider = { [weak self] (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            switch kind {
            case Self.footerKind:
                let reusableViewFooter: CollectionReusableView<TOMCouponCollectionViewFooter> = collectionView.dequeueSuplementaryView(of: UICollectionView.elementKindSectionFooter, at: indexPath)
                reusableViewFooter.configureContent { footer in
                    footer.addBorder(.yellow, borderWidth: 2.0)
                    footer.fillSuperview(withinSafeArea: true, padding: .verticalPadding(0))
                    footer.addBorder(.yellow, borderWidth: 1.0)
                    footer.configureButtonTitle(viewModel.couponSectionFooterTitle)
                    footer.viewMoreTapped = { [weak self] in
                        self?.toggleCouponsExpansion() ?? ""
                    }
                }
                return reusableViewFooter
            default:
                switch self?.currentSnapshot?.sectionIdentifiers[indexPath.section] {
                case .contact:
                    let reusableViewHeader: CollectionReusableView<TOMContactCardActionableView> = collectionView.dequeueSuplementaryView(of: UICollectionView.elementKindSectionHeader, at: indexPath)
                    reusableViewHeader.configureContent { contactCardView in
                        contactCardView.addBorder(.yellow, borderWidth: 2.0)
                        contactCardView.fillSuperview(withinSafeArea: true, padding: .padding(top: 16, left: 16, bottom: 5, right: 16))
                    //    contactCardView.configureWithViewModel(viewModel)
                        // Handlers
//                        contactCardView.viewMoreTapped = { [weak self] in
//                            self?.toggleCouponsExpansion() ?? ""
//                        }
                    }
                    return reusableViewHeader
                default:
                    let reusableViewHeader: CollectionReusableView<TOMCouponBrandTitleHeaderView> = collectionView.dequeueSuplementaryView(of: UICollectionView.elementKindSectionHeader, at: indexPath)
                    reusableViewHeader.configureContent { brandTitleHeaderView in
                        brandTitleHeaderView.fillSuperview(withinSafeArea: true, padding: .horizontalPadding(8))
                    }
                    return reusableViewHeader
                }
            }
        }
    }
    
    // MARK:- 3: DataSource updates `NSDiffableDataSourceSnapshot`
    private func applySnapshot(viewModel: TOMMultiColumnCouponViewModel, animatingDifferences: Bool) {
        
        guard let delegate = delegate else { return }
        currentSnapshot = Snapshot()
        currentSnapshot?.appendSections(TOMDiffableCollectionViewSection.allCases)
        currentSnapshot?.appendItems(viewModel.diffableContent, toSection: .coupons)
        guard let snapshot = currentSnapshot else { return }
        if  #available(iOS 14, *), !animatingDifferences {// && ios 14 {
            self.dataSource?.apply(snapshot, animatingDifferences: false)
            self.dataSource?.apply(snapshot, animatingDifferences: false)
        } else {
            self.dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
        }
        
      //  self.dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
        print("zizou on snapshot layout size \(collectionView.collectionViewLayout.collectionViewContentSize)")
        print("zizou on snapshot content size \(collectionView.contentSize)")
        
    }
    
    //  MARK:- Expand/Collapse card
    private func toggleCouponsExpansion() -> String {
        guard let viewModel = viewModel else { return "" }
        viewModel.isCouponsExpanded.toggle()
      //  applySnapshot(viewModel: viewModel, animatingDifferences: true)
        delegate?.performBatchUpdate()
        return viewModel.couponSectionFooterTitle
    }
}


@objc extension UIView {
    
    // Layout debug helper.
    func addBorder(_ color: UIColor?, borderWidth: CGFloat) {
        layer.borderColor = color?.cgColor
        layer.borderWidth = borderWidth
    }
}
