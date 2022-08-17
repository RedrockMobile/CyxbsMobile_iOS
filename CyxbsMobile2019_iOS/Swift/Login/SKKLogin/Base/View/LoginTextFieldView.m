//
//  LoginTextFieldView.m
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2022/8/9.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "LoginTextFieldView.h"

@implementation LoginTextFieldView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F1F5F9" alpha:0.8];
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8;
        self.textColor = [UIColor colorWithHexString:@"#8B8B8B" alpha:1.0];
        self.borderStyle = UITextBorderStyleNone;
        self.font = [UIFont fontWithName:PingFangSCMedium size:14];
        self.textAlignment = NSTextAlignmentLeft;
        // 左视图
        self.leftView = self.iconImgView;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

#pragma mark - Method

// 控制左边图片位置
- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 15.5;
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
