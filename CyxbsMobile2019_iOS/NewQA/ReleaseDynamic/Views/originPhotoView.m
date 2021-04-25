//
//  originPhotoView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/2/13.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "originPhotoView.h"

@implementation originPhotoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addClickBtn];
    }
    return self;
}
- (void)addClickBtn{
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage imageNamed:@"原图圈圈"] forState:UIControlStateNormal];
    [btn addTarget:self.delegate action:@selector(choseState) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(14);
    }];
    self.clickBtn = btn;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"原图";
    label.font = [UIFont fontWithName:PingFangSCMedium size:13];
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"SZHClearBtnTextColor"];
    } else {
        // Fallback on earlier versions
    }
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.mas_equalTo(12);
//        make.left.equalTo(btn.mas_right).offset(MAIN_SCREEN_W * 0.0427);
        make.left.equalTo(btn.mas_right).offset(11);
    }];
    
    self.label = label;
    
}
@end
