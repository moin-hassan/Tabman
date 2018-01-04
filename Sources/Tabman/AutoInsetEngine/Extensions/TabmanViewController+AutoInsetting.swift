//
//  TabmanViewController+AutoInsetting.swift
//  Tabman
//
//  Created by Merrick Sapsford on 22/11/2017.
//  Copyright © 2017 UI At Six. All rights reserved.
//

import UIKit

internal extension TabmanViewController {
    
    /// Notify the view controller that the current child view controller requires an inset update.
    func setNeedsChildAutoInsetUpdate() {
        setNeedsChildAutoInsetUpdate(for: currentViewController)
    }
    
    /// Notify the view controller that a child view controller requires an inset update.
    func setNeedsChildAutoInsetUpdate(for childViewController: UIViewController?) {
        calculateRequiredBarInsets()
        guard let childViewController = childViewController else {
            return
        }
        autoInsetEngine.inset(childViewController, requiredInsets: bar.requiredInsets)
    }
}

// MARK: - Bar inset calculation
private extension TabmanViewController {
    
    /// Reload the required bar insets for the current bar.
    func calculateRequiredBarInsets() {
        
        var layoutInsets: UIEdgeInsets = .zero
        if #available(iOS 11, *) {
            layoutInsets = view.safeAreaInsets
        } else {
            layoutInsets.top = topLayoutGuide.length
            layoutInsets.bottom = bottomLayoutGuide.length
        }
        
        self.bar.requiredInsets = BarInsets(safeAreaInsets: layoutInsets,
                                            bar: self.actualBarInsets())
    }
    
    /// Calculate the actual required insets for the current bar.
    ///
    /// - Returns: The required bar insets
    private func actualBarInsets() -> UIEdgeInsets {
        guard self.embeddingContainer == nil && self.attachedBarView == nil else {
            return .zero
        }
        guard self.activeBarView?.isHidden != true else {
            return .zero
        }
        
        let frame = self.activeBarView?.frame ?? .zero
        var insets = UIEdgeInsets.zero
        
        var location = self.bar.location
        if location == .preferred {
            location = self.bar.style.preferredLocation
        }
        
        switch location {
        case .bottom:
            insets.bottom = frame.size.height
            
        default:
            insets.top = frame.size.height
        }
        return insets
    }
}
