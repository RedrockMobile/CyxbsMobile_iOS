//
//  TodoTitleInputTextField.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/7.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "TodoTitleInputTextField.h"


@interface TodoTitleInputTextField () {
    //光标的偏移量
    double offset;
}
@end


@implementation TodoTitleInputTextField
- (instancetype)init {
    self = [super init];
    if (self) {
        offset = 0.04533333333*SCREEN_WIDTH;
        self.layer.cornerRadius = 22;
        self.backgroundColor = [UIColor colorNamed:@"232_241_252&31_31_31"];
        self.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
        self.font = [UIFont fontWithName:PingFangSCMedium size:15];
        self.placeholder = @"添加代办事项";
    }
    return self;
}

/// 重写后可以改变非编辑状态时光标的位置
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, offset, 0);
}

/// 重写后可以改变编辑时光标的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, offset, 0);
}


@end
