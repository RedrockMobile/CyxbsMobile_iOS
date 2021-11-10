//
//  ToDoDetailRemarkView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/9/19.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "ToDoDetailCurrencyView.h"
#import "TodoDataModel.h"
NS_ASSUME_NONNULL_BEGIN
/**
 这是写备注的一个View
 主要有：
 父类的控件
 自己的一个编辑备注的UITextView
 */
@interface ToDoDetailRemarkView : ToDoDetailCurrencyView

@property (nonatomic, strong) TodoDataModel *model;

/// remarkView本身的size
@property (nonatomic, assign) CGSize remarkViewSize;

/// 文本的TextView
@property (nonatomic, strong) UITextView *textView;

///用于在外界改变该View的高的的block
@property (nonatomic, copy) void(^changeTitleViewHeightBlock)(CGFloat height);
@end

NS_ASSUME_NONNULL_END
