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

+ (instancetype)viewWithEmptyholderImageName:(NSString *)CyxbsEmptyImageName content:(NSString *)content {
    UIView *view = [[UIView alloc] init];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CyxbsEmptyImageName]];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(view).offset(10);
        if (view.width >= 360) {
            make.width.equalTo(@320);
        } else {
            make.left.equalTo(@20);
            make.right.equalTo(@20);
        }
        make.height.mas_equalTo(imgView.width).multipliedBy(3 / 4);
    }];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont fontWithName:FontName.PingFangSC.Regular size:14];
    lab.textColor =
    [UIColor Light:UIColorHex(#15315B) Dark:UIColorHex(#F0F0F2)];
    lab.numberOfLines = 0;
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@20);
        make.top.equalTo(imgView.mas_bottom).offset(10);
    }];
    
    return view;
}

@end
