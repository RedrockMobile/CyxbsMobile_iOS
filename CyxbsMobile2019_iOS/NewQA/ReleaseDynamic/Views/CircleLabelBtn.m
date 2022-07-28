//
//  CircleLabelBtn.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/2/14.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "CircleLabelBtn.h"

@implementation CircleLabelBtn

- (instancetype)init{
    self = [super init];
    if (self) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(MAIN_SCREEN_W * 0.056);
            make.right.equalTo(self).offset(-MAIN_SCREEN_W * 0.056);
        }];
        //设置button宽度随title文本长度自适应
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        //设置圆角,此处为全圆角，设置弧度为高度的一半
        self.layer.cornerRadius = MAIN_SCREEN_H * 0.0382 * 0.5;
        self.layer.masksToBounds = YES;
        //字体
        self.titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:12];
        
        if(@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F1F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#3F3F3F" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
    }
    return self;
}


@end
