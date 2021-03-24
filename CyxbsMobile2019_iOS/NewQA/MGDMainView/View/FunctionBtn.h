//
//  FunctionBtn.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FunctionBtn : UIButton

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *countLabel;

- (void)setIconViewSelectedImage:(UIImage *)selectedImage AndUnSelectedImage:(UIImage *)unSelectedImnage;

@end

NS_ASSUME_NONNULL_END
