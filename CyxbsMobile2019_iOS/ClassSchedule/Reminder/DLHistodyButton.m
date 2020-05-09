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
//        self.backgroundColor = [UIColor colorWithHexString:@"#F2F3F7"];
        self.alpha = 0.5;
        self.layer.backgroundColor = [UIColor colorWithHexString:@"#F2F3F7"].CGColor;
        self.layer.cornerRadius = 15*kRateX;
        self.layer.masksToBounds = YES;
        
        self.titleLabel.frame = self.frame;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont fontWithName:@".PingFang SC-Regular" size:12*kRateX];
        [self setTitleColor:[UIColor colorWithHexString:@"#15315B"] forState:UIControlStateNormal];
    }
    return self;
}

@end
