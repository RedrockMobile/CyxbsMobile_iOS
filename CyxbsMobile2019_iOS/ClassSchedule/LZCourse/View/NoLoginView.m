//
//  NoLoginView.m
//  MoblieCQUPT_iOS
//
//  Created by 李展 on 2016/12/20.
//  Copyright © 2016年 Orange-W. All rights reserved.
//

#import "NoLoginView.h"
#import "LoginViewController.h"
#import "UIFont+AdaptiveFont.h"
@implementation NoLoginView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/4, frame.size.height/4, frame.size.width/2, frame.size.width/2)];
        imageView.image = [UIImage imageNamed:@"courseMengbi.jpg"];
        [self addSubview:imageView];
        CGRect btnFrame = imageView.frame;
        btnFrame.origin.y = btnFrame.origin.y+btnFrame.size.height+20;
        btnFrame.size.height = 20;
         self.loginButton = [[UIButton alloc]initWithFrame:btnFrame];
        [self.loginButton.titleLabel setFont:[UIFont adaptFontSize:16]];
        [self.loginButton setTitle:@"点击登录,拯救课表菌!!!" forState: UIControlStateNormal];
        [self.loginButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [self addSubview:self.loginButton];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end
