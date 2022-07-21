//
//  SZHPhotoImageView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/2/13.
//  Copyright © 2021 Redrock. All rights reserved.
//
/**添加图片的UIImageView*/
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SZHPhotoImageViewDelegate <NSObject>

/// 删除图片框
/// @param imageView 需要删除的图片框
- (void)clearPhotoImageView:(UIImageView *)imageView;

@end
@interface SZHPhotoImageView : UIImageView
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, weak) id<SZHPhotoImageViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
