//
//  Layout.swift
//  CleanDiffableCollectionView
//
//  Created by james rochabrun on 9/3/20.
//  Copyright © 2020 james rochabrun. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    
    
    /// - Returns: an instance of `UIEdgeInsets` with same value insets.
    /// - Parameters: The value that will be applied equally.
    static func allEqual(to value: CGFloat) -> UIEdgeInsets {
         self.init(top: value, left: value, bottom: value, right: value)
    }
    
    /// - Returns: an instance of `UIEdgeInsets` with a default value of 0 for each inset or with the value provided as param.
    /// - Parameters: the value that should be applied to each inset.
    static func padding(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> UIEdgeInsets {
         self.init(top: top, left: left, bottom: bottom, right: right)
    }
    
    /// - Returns: an instance of `UIEdgeInsets` with left and right insets with the parameter value applied.
    /// - Parameters: the value that should be applied to left and right inset.
    static func verticalPadding(_ value: CGFloat) -> UIEdgeInsets {
        /// And a left and right insets of 0
        .padding(top: value, bottom: value)
    }
    
    /// - Returns: an instance of `UIEdgeInsets` with top and bottom insets with the parameter value applied.
    /// And a top and bottom insets of 0
    /// - Parameters: the value that should be applied to each inset.
    static func horizontalPadding(_ value: CGFloat) -> UIEdgeInsets {
        .padding(left: value, right: value)
     }
}


@objc extension UIView {
    
    @objc public func anchor(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    
    @objc public func fillSuperview(withinSafeArea: Bool = false, padding: UIEdgeInsets = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }
        
        let superviewTopAnchor = withinSafeArea ? superview.safeAreaLayoutGuide.topAnchor : superview.topAnchor
        let superviewLeadingAnchor = withinSafeArea ? superview.safeAreaLayoutGuide.leadingAnchor : superview.leadingAnchor
        let superviewTrailingAnchor = withinSafeArea ? superview.safeAreaLayoutGuide.trailingAnchor : superview.trailingAnchor
        let superviewBottomAnchor = withinSafeArea ? superview.safeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor

        // Apple Doc: Typically, using this method is more efficient than activating each constraint individually.
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top),
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left),
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right),
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom)
        ])
        
    }
    
    @objc public func centerInSuperview(width: NSLayoutDimension? = nil, height: NSLayoutDimension? = nil, size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        } else if let h = height {
            heightAnchor.constraint(equalTo: h).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        } else if let w = width {
            widthAnchor.constraint(equalTo: w).isActive = true
        }
    }
    
    @objc public func anchorSize(to view: UIView, multiplier: CGFloat = 1.0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier).isActive = true
    }
    
    @objc public func constrainWidth(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    @objc public func constrainHeight(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
}
