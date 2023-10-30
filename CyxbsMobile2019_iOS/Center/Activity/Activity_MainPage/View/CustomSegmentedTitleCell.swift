//
//  CustomSegmentedTitleCell.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/10/28.
//  Copyright © 2023 Redrock. All rights reserved.
//
import JXSegmentedView

class CustomSegmentedTitleCell: JXSegmentedTitleCell {
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.contentView.backgroundColor = .gray // 选中时的背景颜色
            } else {
                self.contentView.backgroundColor = UIColor.clear // 非选中时的背景颜色
            }
        }
    }
}

