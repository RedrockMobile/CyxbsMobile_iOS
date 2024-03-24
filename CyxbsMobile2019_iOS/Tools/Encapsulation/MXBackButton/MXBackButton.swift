//
//  MXBackButton.swift
//  CyxbsMobile2019_iOS
//
//  Created by Max Xu on 2024/3/15.
//  Copyright © 2024 Redrock. All rights reserved.
//

import UIKit

class MXBackButton: UIButton {
    
    private var isAutoHotspotExpand: Bool?
    
    
    /**
     isAutoHotspotExpand为是否自动扩大点击热区，默认关闭。
     如果开启，并且按钮width 或 height 小于44 ，则将相应的小于44的
     边长的点击范围设置为44
     */
    init(frame: CGRect, isAutoHotspotExpand: Bool? = false) {
        super.init(frame: frame)
        self.isAutoHotspotExpand = isAutoHotspotExpand
        setImage(UIImage(named: "activityBack"), for: .normal)
        imageView?.contentMode = .scaleAspectFit
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///参考SSR的SSRButton类思路重写UIButton的point方法
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        var top: CGFloat?
        var bottom: CGFloat?
        var left: CGFloat?
        var right: CGFloat?
        if(isAutoHotspotExpand ?? false) {
            if (frame.size.height < 44) {
                top = (44 - self.frame.size.height)/2.0
                bottom = (44 - self.frame.size.height)/2.0
            }
            if (frame.size.width < 44) {
                left = (44 - self.frame.size.width)/2.0
                right = (44 - self.frame.size.width)/2.0
            }
            let hotSpotExpandEdge = UIEdgeInsets(top: -(top ?? 0), left: -(left ?? 0), bottom: -(bottom ?? 0), right: -(right ?? 0))
            if hotSpotExpandEdge == .zero || !isEnabled || isHidden {
                return super.point(inside: point, with: event)
            } else {
                // 获取按钮相对于其父视图的边界
                let relativeBounds = self.bounds
                let hotSpotExpand = relativeBounds.inset(by: hotSpotExpandEdge)
                return hotSpotExpand.contains(point)
            }
        } else {
            return super.point(inside: point, with: event)
        }
    }
    
}
