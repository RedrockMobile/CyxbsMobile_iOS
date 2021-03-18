//
//  GYYShareView.m
//  CyxbsMobile2019_iOS
//
//  Created by 郭蕴尧 on 2021/1/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "GYYShareView.h"
@interface GYYShareView ()
@property(nonatomic, strong) UIButton *actionButton;
@end

@implementation GYYShareView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *shareimage = [UIImage imageNamed:@"圆角矩形 2536"];
        self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.actionButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.actionButton setTitle:@"APP内打开" forState:UIControlStateNormal];
        [self.actionButton setTitleColor:[UIColor colorWithLightColor:KUIColorFromRGB(0xffffff) DarkColor:KUIColorFromRGB(0xffffff)] forState:UIControlStateNormal];
        [self.actionButton setBackgroundImage:shareimage forState:UIControlStateNormal];
        [self addSubview:self.actionButton];
        [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_bottom).mas_offset(-0.0907*SCREEN_HEIGHT);
            make.width.mas_offset(shareimage.size.width);
            make.height.mas_offset(shareimage.size.height);
        }];
        [self.actionButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)shareAction:(UIButton*)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareViewAction)]) {
        [self.delegate shareViewAction];
    }
}
@end
