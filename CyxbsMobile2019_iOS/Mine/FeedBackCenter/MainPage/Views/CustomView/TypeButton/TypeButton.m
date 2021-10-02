//
//  TypeButton.m
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/24.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "TypeButton.h"

@implementation TypeButton

- (instancetype)initWithFrame:(CGRect)frame AndTitle:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:14];
        [self setTitleColor:[UIColor colorNamed:@"TypeBtn"] forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
        
        //边框
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 15;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorNamed:@"TypeBtn"].CGColor;
        
        //点击事件
        [self addTarget:self.delegate action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


@end
