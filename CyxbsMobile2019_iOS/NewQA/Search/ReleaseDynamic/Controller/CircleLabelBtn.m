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
            make.left.equalTo(self).offset(MAIN_SCREEN_W * 0.0573);
            make.right.equalTo(self).offset(-MAIN_SCREEN_W * 0.0573);
        }];
        //设置button宽度随title文本长度自适应
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        //设置圆角
        self.layer.cornerRadius = MAIN_SCREEN_W * 0.0333;
        self.layer.masksToBounds = YES;
        //字体
        self.titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:12];
        
        if(@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"圈子标签按钮未选中时背景颜色"];
        } else {
            // Fallback on earlier versions
        }
    }
    return self;
}


@end
