//
//  AlertView.h
//  CyxbsMobile2019_iOS
//
//  Created by 小艾同学 on 2022/8/6.
//  Copyright © 2022 Redrock. All rights reserved.
// 弹窗view，左右按钮确定为左边“取消”，右边“确定”，取消按钮方法确定。自定义title和hint，以及“确定”按钮方法

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol rightButtonTouchDelegate <NSObject>



@end

@interface AlertView : UIView
/// 左按钮
@property (nonatomic, strong) UIButton *leftButton;
/// 右按钮
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, weak) id <rightButtonTouchDelegate>delegate;

- (instancetype)initWithTitle:(NSString *)titleString AndHintTitle:(NSString *)hintString;


@end

NS_ASSUME_NONNULL_END
