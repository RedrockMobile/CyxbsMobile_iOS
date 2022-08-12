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
        self.backgroundColor = UIColor.clearColor;
        [self addSubview:self.iconImgView];
        [self addSubview:self.textLab];
        [self addSubview:self.textField];
        [self setPosition];
    }
    return self;
}

#pragma mark - Method

/// 设置位置
- (void)setPosition {
    // textField
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    
    // iconImgView
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField).offset(3);
        make.bottom.equalTo(self.textField.mas_top).offset(-6);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    // textLab
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.height.equalTo(self.iconImgView);
        make.right.equalTo(self.textField);
        make.left.equalTo(self.iconImgView.mas_right).offset(3);
    }];
}

#pragma mark - Getter

- (UIImageView *)iconImgView {
    if (_iconImgView == nil) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)textLab {
    if (_textLab == nil) {
        _textLab = [[UILabel alloc] init];
        _textLab.font = [UIFont systemFontOfSize:20];
        _textLab.textColor = UIColor.blackColor;
        _textLab.textAlignment = NSTextAlignmentLeft;
    }
    return _textLab;
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor lightGrayColor];
//        _textField.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6" alpha:1.0];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.layer.masksToBounds = YES;
        _textField.layer.cornerRadius = 10;
        _textField.textColor = [UIColor darkGrayColor];
        _textField.font = [UIFont systemFontOfSize:25];
        _textField.textAlignment = NSTextAlignmentLeft;
    }
    return _textField;
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
