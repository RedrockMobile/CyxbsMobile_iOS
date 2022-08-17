//
//  YYZpopView.m
//  CyxbsMobile2019_iOS
//
//  Created by 杨远舟 on 2020/12/6.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "YYZpopView.h"

@implementation YYZpopView

-(void) showPop{
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *tipsLable = [[UILabel alloc]init];
    tipsLable.frame = CGRectMake(30, 175, 194, 65);
    tipsLable.text = @"你的密码未曾修改，请试试初始密码:身份证后六位/2020级为统一认证码后六位";
    tipsLable.textColor = [UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1.0];
    tipsLable.numberOfLines = 3;
    [tipsLable setFont:[UIFont fontWithName:PingFangSCRegular size:11]];
    [self addSubview:tipsLable];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(25, 28, 178, 144);
    UIImage *image1 = [UIImage imageNamed:@"yyzPop"];
    imageView.image = image1;
    [self addSubview:imageView];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(59, 266, 145, 34)];
    self.backBtn = backBtn;
    [backBtn setTitle:@"重新登录" forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor colorWithRed:93/255.0 green:93/255.0 blue:247/255.0 alpha:1.0];
    [backBtn.layer setCornerRadius:18.0];
    [self addSubview:backBtn];
//    self.backgroundColor = [UIColor redColor];
}


@end
