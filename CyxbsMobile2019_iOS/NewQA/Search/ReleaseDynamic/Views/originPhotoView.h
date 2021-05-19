//
//  originPhotoView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/2/13.
//  Copyright © 2021 Redrock. All rights reserved.
//
/**
 是否勾选原图的view
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//@protocol originPhotoViewDelegate <NSObject>
///// 选择勾选状态
//- (void)choseState;
//@end
@protocol OriginPhotoViewDelegate <NSObject>

/// 选择勾选状态
- (void)choseState;

@end
@interface originPhotoView : UIView
@property id <OriginPhotoViewDelegate> delegate;
@property (nonatomic, strong) UIButton *clickBtn;
@property (nonatomic, strong) UILabel *label;
@end

NS_ASSUME_NONNULL_END
