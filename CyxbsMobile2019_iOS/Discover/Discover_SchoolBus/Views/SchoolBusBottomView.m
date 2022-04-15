//
//  SchoolBusBottomView.m
//  CyxbsMobile2019_iOS
//
//  Created by Clutch Powers on 2022/4/7.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SchoolBusBottomView.h"

@implementation SchoolBusBottomView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
            if (@available(iOS 13.0, *)) {
                self.backgroundColor = [UIColor colorNamed:@"SchoolBusBottomColor"];
            } else {
                self.backgroundColor = [UIColor blackColor];
            }
            self.layer.cornerRadius = 16;
    
            [self addSubview:self.statusLabel];
    
        }
    return self;
}
 


- (UILabel *)statusLabel{
    if (!_statusLabel) {
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 150, 40)];
        statusLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
        statusLabel.text = @"校车运行中";
        if (@available(iOS 13.0, *)) {
            statusLabel.textColor = [UIColor colorNamed:@"SchoolBusLabelColor"];
        } else {
            statusLabel.textColor = [UIColor blackColor];
        }
        _statusLabel = statusLabel;
    }
    return _statusLabel;
}


@end
