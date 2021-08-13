//
//  TodoTitleInputTextField.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/7.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "TodoTitleInputTextField.h"

#define RectToString(r) ^(CGRect rect){\
    return [NSString stringWithFormat:@"%.2f,%.2f,  %.2f,%.2f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];\
}(r)

@interface TodoTitleInputTextField () {
    double offset;
}
@end


@implementation TodoTitleInputTextField
- (instancetype)init {
    self = [super init];
    if (self) {
        offset = 0.04533333333*SCREEN_WIDTH;
        self.layer.cornerRadius = 22;
        self.backgroundColor = [UIColor colorNamed:@"232_241_252&"];
        self.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
        self.font = [UIFont fontWithName:PingFangSCMedium size:15];
        self.placeholder = @"添加代办事项";
    }
    return self;
}
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, offset, 0);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, offset, 0);
}


@end
