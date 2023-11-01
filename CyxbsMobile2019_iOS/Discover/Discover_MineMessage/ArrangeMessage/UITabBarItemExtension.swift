//
//  UITabBarItemExtension.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/10/14.
//  Copyright © 2023 Redrock. All rights reserved.
//

extension UITabBarItem {
    static let SMALL_BADGE_TAG = 237
    var needShowBadgePoint: Bool {
        get {
            badgeValue != nil
        }
        set {
            guard let view = self.value(forKey: "view") as? UIView else { return }
            if newValue {
                badgeValue = ""
                guard
                let badgeViewClass = NSClassFromString("_UIBadgeView"),
                (view.subviews.last?.isKind(of: badgeViewClass) ?? false) else {
                    return
                }
                view.subviews.last?.removeFromSuperview()
                let imgView = view.subviews[0]
                let width: CGFloat = 7
                let customBadge = UIView(frame: CGRect(x: imgView.frame.maxX - width + 1, y: imgView.frame.minY - 1, width: width, height: width))
                customBadge.tag = UITabBarItem.SMALL_BADGE_TAG
                customBadge.backgroundColor = .red
                customBadge.layer.cornerRadius = width / 2
                customBadge.layer.masksToBounds = true
                customBadge.layer.zPosition = 2
                view.addSubview(customBadge)
            } else {
                badgeValue = nil
                view.subviews.first { $0.tag == UITabBarItem.SMALL_BADGE_TAG }?.removeFromSuperview()
            }
        }
    }
}
