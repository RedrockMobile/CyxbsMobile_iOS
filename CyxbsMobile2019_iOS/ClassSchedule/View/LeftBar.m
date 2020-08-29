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

/// 获取左侧课条内部的小课块
/// @param text 实际上是一个数字，范围：[1,12]
- (UILabel*)getLabelWithString:(NSString*)text{
    UILabel *label = [[UILabel alloc] init];
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    label.font = [UIFont fontWithName:PingFangSCMedium size: 12];
    [label setTextAlignment:(NSTextAlignmentCenter)];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    return label;
}
/**
    返回的字典的结构：@{
    @"y":年,
    @"M":月,
    @"d":日,
    @"k":小时（24小时制）,[1, 24]
    @"m:分"
    @"e":周几，2～周一，1~周日，4～周3
    @"c":周几，2～周一，1~周日，4～周3
    };
*/
//获取当前时间信息的方法
- (NSDictionary *)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSArray *array = @[@"y",@"M",@"d",@"k",@"m",@"e",@"c"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *str in array) {
        [formatter setDateFormat:str];
        [dict setValue:[formatter stringFromDate:[NSDate date]]forKey:str];
    }
    return dict;
}
- (void)getHash_lesson{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"k"];
    
}
@end
