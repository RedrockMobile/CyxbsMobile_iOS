//
//  SameDrawUI.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/19.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SameDrawUI.h"

#import <Masonry/Masonry.h>

#import "RisingExtension.h"

const struct CyxbsEmptyImageName CyxbsEmptyImageName = {
    .error404 = @"empty.error404",
    .kebiao = @"empty.kebiao"
};

@implementation UIView (SameDrawUI)

- (void)addGradientBlueLayer {
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.SuperFrame;
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[
        (__bridge id)UIColorHex(#4841E2).CGColor,
        (__bridge id)UIColorHex(#5D5DF7).CGColor
    ];
    gl.locations = @[@(0),@(1.0f)];
    [self.layer addSublayer: gl];
}

+ (UIView *)placeholderViewWith:(void (^)(UIImageView *, UILabel *))block {
    UIView *view = [[UIView alloc] init];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"404"]];
    [view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view).offset(view.width / 2);
        make.width.equalTo(@170);
        make.height.equalTo(@105);
    }];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"无数据";
    lab.font = [UIFont fontWithName:FontName.PingFangSC.Medium size:12];
    lab.textColor =
    [UIColor Light:UIColorHex(#112C54) Dark:UIColorHex(#DFDFE3)];
    
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(imgView.mas_bottom).offset(20);
    }];
    
    if (block) {
        block(imgView, lab);
    }
    
    return view;
}

@end
