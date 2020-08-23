//
//  DLTextFiled.m
//  CyxbsMobile2019_iOS
//
//  Created by 丁磊 on 2020/4/9.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "DLTextFiled.h"

#define rateX [UIScreen mainScreen].bounds.size.width / 375
@implementation DLTextFiled

- (instancetype)init
{
    self = [super init];
    if (self) {
//        CGFloat rateY = [UIScreen mainScreen].bounds.size.height / 812;
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"DLTextFieldColor"];
        } else {
             self.backgroundColor = [UIColor colorWithHexString:@"#F2F3F7"];
            // Fallback on earlier versions
        }
        
        
        self.layer.cornerRadius = 0.033867*MAIN_SCREEN_H;
        self.layer.masksToBounds = YES;
        if (@available(iOS 11.0, *)) {
            self.textColor = [UIColor colorNamed:@"titleLabelColor"];
        } else {
             self.textColor = [UIColor colorWithHexString:@"#15315B"];
            // Fallback on earlier versions
        }
        self.font = [UIFont fontWithName:@".PingFang SC-Semibold" size:21*rateX];
        if (@available(iOS 11.0, *)) {
            self.tintColor = [UIColor colorNamed:@"tintColor"];
        } else {
             self.tintColor = [UIColor colorWithHexString:@"#4841E2"];
            // Fallback on earlier versions
        }
        self.leftView.frame = CGRectMake(28*rateX, 0, 3, 10);  //光标偏移
    }
    return self;
}

//设置光标偏移
- (CGRect)textRectForBounds:(CGRect)bounds {
    bounds.origin.x += 30*rateX;
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    bounds.origin.x += 30*rateX;
    return bounds;
}
@end
