//
//  DLHistodyButton.m
//  CyxbsMobile2019_iOS
//
//  Created by 丁磊 on 2020/4/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "DLHistodyButton.h"

#define kRateX [UIScreen mainScreen].bounds.size.width/375   //以iPhoneX为基准
@implementation DLHistodyButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"HistodayButtonBackGroundColor"];
        } else {
             self.backgroundColor = [UIColor colorWithHexString:@"#5E5E5E"];
        }
//        self.alpha = 0.5;
//        self.layer.backgroundColor = [UIColor colorWithHexString:@"#F2F3F7"].CGColor;
        self.layer.cornerRadius = 15*kRateX;
        self.layer.masksToBounds = YES;
        
        self.titleLabel.frame = self.frame;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont fontWithName:@".PingFang SC-Regular" size:12*kRateX];
        
        if (@available(iOS 11.0, *)) {
            [self setTitleColor:[UIColor colorNamed:@"HistodayButtonLabelColor"] forState:UIControlStateNormal];
        } else {
            [self setTitleColor:[UIColor colorWithHexString:@"F0F0F2"] forState:UIControlStateNormal];
        }
//        self.titleLabel.textColor = UIColor.redColor;
//        self.backgroundColor = UIColor.redColor;
        
    }
    return self;
}

@end
