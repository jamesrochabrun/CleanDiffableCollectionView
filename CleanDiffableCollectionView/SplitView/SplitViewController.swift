//
//  SplitViewController.swift
//  CleanDiffableCollectionView
//
//  Created by james rochabrun on 9/3/20.
//  Copyright © 2020 james rochabrun. All rights reserved.
//

import UIKit


protocol DisplayModeUpdatable {
    func displayModeWillChangeTo(_ displayMode: UISplitViewController.DisplayMode)
    func displayModeDidChangeTo(_ displayMode: UISplitViewController.DisplayMode)
}

final class SplitViewController: UISplitViewController {
    
    // MARK:- UI
    lazy var displayModeCustomButton: Button = {
        let button = Button(type: .system, image:UIImage(systemName: "magnifyingglass"), target: self, selector: #selector(togglePrefferDisplayModeExecutingCompletion))
        button.constrainWidth(constant: 44.0)
        button.constrainHeight(constant: 44.0)
        button.imageEdgeInsets = .init(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        return button
    }()
    
    @objc private func changeDisplayMode() {
        togglePrefferDisplayModeExecutingCompletion()
    }
//
//    /**
//     Change `preferredDisplayMode` animated with a time duration of 0.25.
//     - Parameters:
//     - executing: Bool value that determines if DisplayModeUpdatable conformers should perform an update.
    //     */
    @objc func togglePrefferDisplayModeExecutingCompletion(_ executing: Bool = true) {
        UIView.animate(withDuration: 0.3, animations: {
            self.preferredDisplayMode = self.displayMode == .allVisible ? .primaryHidden : .allVisible
            self.displayModeCustomButton.setImage(SplitViewControllerViewModel.displayModeButtonImageFor(self.preferredDisplayMode), for: .normal)
            
        }) { _ in
            guard let detailViewOnDisplayModeChange = self.secondaryViewController as? UINavigationController,
                let displayModeUpdatable = detailViewOnDisplayModeChange.topViewController as? DisplayModeUpdatable
                else { return }
            displayModeUpdatable.displayModeDidChangeTo(self.displayMode)
        }
    }

    
    // MARK:- Lifecycle
     override func viewDidLoad() {
         super.viewDidLoad()
         displayModeButtonItem.customView = displayModeCustomButton
        
        let master = UINavigationController(rootViewController: UIViewController())
        let detail = UINavigationController(rootViewController: ViewController.instantiate(from: "Main"))
        self.viewControllers = [master, detail]
        preferredDisplayMode = .allVisible

     }
}

extension SplitViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        guard let detailViewOnDisplayModeChange = svc.secondaryViewController as? UINavigationController, let displayModeUpdatable = detailViewOnDisplayModeChange.topViewController as? DisplayModeUpdatable else {
            return }
        displayModeUpdatable.displayModeWillChangeTo(displayMode)
    }
    
    /**
     - Remark: Called when App expands from `CompactWidth` to `RegularWidth` in a mulittasking enviromment.
     */
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        if let masterAsNavigation = primaryViewController as? UINavigationController,
            let masterFirstChild = masterAsNavigation.viewControllers.first {
            masterAsNavigation.setViewControllers([masterFirstChild], animated: false)
        }
        guard let masterAsNavigation = primaryViewController as? UINavigationController,
            let lastShownDetailNavigationController = masterAsNavigation.viewControllers.last as? UINavigationController,
            let lastShownDetailContentViewController = lastShownDetailNavigationController.viewControllers.first else { return nil }
        return type(of: lastShownDetailNavigationController).init(rootViewController: lastShownDetailContentViewController)
    }
    
    /**
     - Remark: Called when App collapses from `RegularWidth` to `CompactWidth` in a mulittasking enviromment.
     */
//    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
//        return secondaryViewController is EmptyDetailViewcontroller
//    }
}

struct SplitViewControllerViewModel {
    
    static func displayModeButtonImageFor(_ displayMode: UISplitViewController.DisplayMode) -> UIImage? {
        displayMode == .allVisible ? UIImage(systemName: "arrow.up.left.and.arrow.down.right") : UIImage(systemName: "arrow.down.right.and.arrow.up.left")
    }
}

final class Button: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        tintColor = .black
    }
}


extension UISplitViewController {
    
    /// Return:- The master view controller.
    var primaryViewController: UIViewController? {
        viewControllers.first
    }
    /// Return:- The detail view controller.
    var secondaryViewController: UIViewController? {
        viewControllers.count > 1 ? viewControllers.last : nil
    }
    
    /// Convenience wrapper to display the detail embedded in a navigation controller if vc is not a navigation controller already.
    func showDetailInNavigationControllerIfNeeded(_ vc: UIViewController, sender: Any?) {
        let detail = vc is UINavigationController ? vc : UINavigationController(rootViewController: vc)
        showDetailViewController(detail, sender: sender)
    }
    
    /// Convenience method to detect if a view controller is a detail, this helps to detect pushes in navigation stack if needed.
    func isDetail(_ viewController: UIViewController) -> Bool {
        (viewController.navigationController ?? viewController) == secondaryViewController
    }
}

extension UIButton {
    
    convenience init(image: UIImage? = nil, title: String? = nil, titleColor: UIColor? = nil, titleFont: UIFont? = nil) {
        self.init()
        setImage(image, for: .normal)
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = titleFont
    }
    
    convenience init(type: UIButton.ButtonType, image: UIImage?, target: Any, selector: Selector) {
        self.init(type: type)
        setImage(image, for: .normal)
        addTarget(target, action: selector, for: .touchUpInside)
    }
}
