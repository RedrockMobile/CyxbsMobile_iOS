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
        self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E8F1FC" alpha:1] darkColor:[UIColor colorWithHexString:@"#1F1F1F" alpha:1]];
        self.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
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
