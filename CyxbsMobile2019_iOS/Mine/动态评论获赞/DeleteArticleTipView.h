//
//  DeleteArticleTipView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/2/23.
//  Copyright © 2021 Redrock. All rights reserved.
//点击删除动态后跳出的弹窗(包含背景蒙板，self就是蒙板)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DeleteArticleTipViewDelegate <NSObject>
- (void)sureBtnClicked;
@end

@interface DeleteArticleTipView : UIView
@property(nonatomic,weak)id<DeleteArticleTipViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
