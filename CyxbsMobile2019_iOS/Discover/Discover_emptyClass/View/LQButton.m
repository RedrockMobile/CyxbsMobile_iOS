//
//  LQButton.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/14.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "LQButton.h"
#define HIGHLIGHTCOLOR     [UIColor colorWithRed:221/255.0 green:227/255.0 blue:248/255.0 alpha:1]

@implementation LQButton
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isLight = NO;
    }
    return self;
}
- (void)choose {
    if(self.isLight == NO) {
        self.isLight = YES;
        [self setBackgroundColor:HIGHLIGHTCOLOR];
        self.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:15];
    }else {
        self.isLight = NO;
        [self setBackgroundColor:[UIColor whiteColor]];
        self.titleLabel.font = [UIFont fontWithName:PingFangSCRegular size:15];

    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
