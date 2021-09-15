//
//  PMPTextButton.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPBasicActionView.h"

NS_ASSUME_NONNULL_BEGIN

/// 一个简单地按钮
@interface PMPTextButton : PMPBasicActionView

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * subtitleLabel;

- (void)setTitle:(NSString *)title
        subtitle:(NSString *)subtitle;

@end

NS_ASSUME_NONNULL_END
