//
//  LoginTextFieldView.m
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2022/8/9.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "LoginTextFieldView.h"

@implementation LoginTextFieldView


#pragma mark - Method

- (void)setTextTield {
    if (self.isLoginVC) {
        [self setLoginVCTextField];
    }else {
        [self setforgetPwdVCTextField];
    }
    // 左视图
    self.leftView = self.iconImgView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

/// 登陆界面的输入框样式
- (void)setLoginVCTextField {
    self.backgroundColor =
    [UIColor dm_colorWithLightColor:
        [UIColor colorWithHexString:@"#F6F6F6" alpha:1.0]
                          darkColor:
        [UIColor colorWithHexString:@"#010101" alpha:1.0]];
    self.textColor =
    [UIColor dm_colorWithLightColor:
        [UIColor colorWithHexString:@"#202F56" alpha:1.0]
                          darkColor:
        [UIColor colorWithHexString:@"#DFDEE3" alpha:1.0]];
    self.borderStyle = UITextBorderStyleNone;
    self.font = [UIFont fontWithName:PingFangSCRegular  size:18];
    self.textAlignment = NSTextAlignmentLeft;

    // placeHolder
    UIColor *placeHolderColor =
    [UIColor dm_colorWithLightColor:
        [UIColor colorWithHexString:@"#BFC0C4" alpha:1.0]
                          darkColor:
        [UIColor colorWithHexString:@"#48464B" alpha:1.0]];
    
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:@" " attributes:
    @{
        NSForegroundColorAttributeName:placeHolderColor,
                   NSFontAttributeName:
            [UIFont fontWithName:PingFangSCRegular size:18]
    }];
    self.attributedPlaceholder = att;
}

/// 忘记密码界面的输入框样式
- (void)setforgetPwdVCTextField {
    self.backgroundColor =
    [UIColor dm_colorWithLightColor:
        [UIColor colorWithHexString:@"#F1F5F9" alpha:0.8]
                          darkColor:
        [UIColor colorWithHexString:@"#282828" alpha:1.0]];
    self.borderStyle = UITextBorderStyleRoundedRect;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
    self.textColor =
    [UIColor dm_colorWithLightColor:
        [UIColor colorWithHexString:@"#242424" alpha:1.0]
                          darkColor:
        [UIColor colorWithHexString:@"#E9E9E9" alpha:1.0]];
    self.borderStyle = UITextBorderStyleNone;
    self.font = [UIFont fontWithName:PingFangSCBold size:16];
    self.textAlignment = NSTextAlignmentLeft;

    // placeHolder
    UIColor *placeHolderColor =
    [UIColor dm_colorWithLightColor:
        [UIColor colorWithHexString:@"#8B8B8B" alpha:1.0]
                          darkColor:
        [UIColor colorWithHexString:@"#C2C2C2" alpha:1.0]];
    
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:@" " attributes:
    @{
        NSForegroundColorAttributeName:placeHolderColor,
                   NSFontAttributeName:
            [UIFont fontWithName:PingFangSCMedium size:14]
    }];
    self.attributedPlaceholder = att;
}

// 控制左边图片位置
- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = bounds;
    if (self.isLoginVC) {
        iconRect = [super leftViewRectForBounds:bounds];
    }else {
        iconRect = [super leftViewRectForBounds:bounds];
        iconRect.origin.x += 15.5;
        iconRect.size.width += 1;
        iconRect.size.height += 2;
    }
    return iconRect;
}

// 控制placeHolder的位置，左右缩20
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x + 46, bounds.origin.y, bounds.size.width - 65, bounds.size.height);
   return inset;
}

// 控制显示文本的位置
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x + 46, bounds.origin.y, bounds.size.width - 65, bounds.size.height);

    return inset;
}

// 控制编辑文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
   CGRect inset = CGRectMake(bounds.origin.x + 46, bounds.origin.y, bounds.size.width - 65, bounds.size.height);
   return inset;
}

#pragma mark - Getter

- (UIImageView *)iconImgView {
    if (_iconImgView == nil) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImgView;
}


- (UILabel *)keyboardPlaceholderLab {
    if (_keyboardPlaceholderLab == nil) {
        _keyboardPlaceholderLab = [[UILabel alloc] init];
        _keyboardPlaceholderLab.font = [UIFont systemFontOfSize:13];
        _keyboardPlaceholderLab.alpha = 0.8;
        _keyboardPlaceholderLab.textColor = [UIColor systemGrayColor];
    }
    return _keyboardPlaceholderLab;
}

@end
