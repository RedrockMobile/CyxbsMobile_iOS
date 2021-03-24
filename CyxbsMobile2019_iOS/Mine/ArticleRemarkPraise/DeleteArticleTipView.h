//
//  DeleteArticleTipView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/2/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/// 点击删除动态后跳出的弹窗(包含背景蒙板，self就是蒙板)
@interface DeleteArticleTipView : UIView
@property(nonatomic,strong)UILabel *titleLabel;

/// 唯一测试方法
/// @param block 点击删除按钮后执行的操作
- (instancetype)initWithDeleteBlock:(void(^)(void))block;
@end

NS_ASSUME_NONNULL_END
