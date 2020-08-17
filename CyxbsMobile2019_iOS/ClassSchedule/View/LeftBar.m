//
//  LeftBar.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/17.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "LeftBar.h"
//一小节课item的高度
#define H_H (MAIN_SCREEN_W*0.1426)
#define dis (MAIN_SCREEN_W*0.00795)
@interface LeftBar()
/// 标记当前是第几节课
@property(nonatomic,strong)UIView *markView;
@end

@implementation LeftBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, MONTH_ITEM_W, 12*H_H+11*dis);
        for (int i=0; i<12; i++) {
            UILabel *label = [self getLabelWithString:[NSString stringWithFormat:@"%d",i+1]];
            [self addSubview:label];
            [label setFrame:CGRectMake(0, i*(H_H+dis), MONTH_ITEM_W, H_H)];
        }
    }
    return self;
}
- (UILabel*)getLabelWithString:(NSString*)text{
    UILabel *label = [[UILabel alloc] init];
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 12];
    [label setTextAlignment:(NSTextAlignmentCenter)];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    return label;
}
@end
