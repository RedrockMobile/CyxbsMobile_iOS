//
//  DLWeekButton.m
//  CyxbsMobile2019_iOS
//
//  Created by 丁磊 on 2020/4/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "DLWeekButton.h"

#define kRateX [UIScreen mainScreen].bounds.size.width/375
@implementation DLWeekButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"HistodayButtonBackGroundColor"];
        } else {
             self.backgroundColor = [UIColor colorWithHexString:@"#F2F3F7"];
            // Fallback on earlier versions
        }
//        self.alpha = 0.5;
        self.layer.cornerRadius = 15*kRateX;
        self.layer.masksToBounds = YES;
        
        self.titleLabel.frame = self.frame;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont fontWithName:@".PingFang SC-Regular" size:12*kRateX];
        if (@available(iOS 11.0, *)) {
            [self setTitleColor:[UIColor colorNamed:@"titleLabelColor"] forState:UIControlStateNormal];
        } else {
             [self setTitleColor:[UIColor colorWithHexString:@"#15315B"] forState:UIControlStateNormal];
            // Fallback on earlier versions
        }
        [self setTitleColor:[UIColor colorWithHexString:@"#FFA192"] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor colorWithHexString:@"#FFA192"] forState:UIControlStateSelected | UIControlStateHighlighted];
    }
    return self;
}

- (void)setIsChangeColor:(BOOL)isChangeColor{
    _isChangeColor = isChangeColor;
    if (isChangeColor) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7DAD7"];
    }
    else{
        self.backgroundColor = [UIColor colorWithHexString:@"#F2F3F7"];
    }
}
@end
