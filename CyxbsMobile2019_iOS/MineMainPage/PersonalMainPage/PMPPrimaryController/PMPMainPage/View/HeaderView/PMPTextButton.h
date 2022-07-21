//
//  PMPTextButton.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPBasicActionView.h"

NS_ASSUME_NONNULL_BEGIN

/// 一个简单的按钮
/*
  ----------
 |   title  |
 | subtitle |
  ----------
 */
@interface PMPTextButton : PMPBasicActionView

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * subtitleLabel;

@property (nonatomic, assign) NSUInteger index;

/// @param title 标题-第一行
/// @param subtitle 副标题-第二行
/// @param index 索引
- (void)setTitle:(NSString *)title
        subtitle:(NSString *)subtitle
           index:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
