//
//  ScoreTwoTitleView.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/13.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ScoreTwoTitleView.h"

#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorWhite  [UIColor colorNamed:@"colorWhite&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

@interface ScoreTwoTitleView()
@property (nonatomic, weak)UILabel *scoreLabel;
@property (nonatomic, weak)UILabel *averangeLabel;
@property (nonatomic, weak)UIButton *triangleButton;
@end
@implementation ScoreTwoTitleView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = ColorWhite;
        } else {
            // Fallback on earlier versions
        }
        [self addScoreLabel];//学分成绩
        [self addAverangeLabel];//平均绩点
        [self addTriangle];//三角
    }
    return self;
}
- (void)addScoreLabel {
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont fontWithName:PingFangSCBold size:22];
    if (@available(iOS 11.0, *)) {
        label.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    label.text = @"学分成绩";
    self.scoreLabel = label;
    [self addSubview:label];
}
- (void)addAverangeLabel {
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont fontWithName:PingFangSCBold size:18];
    if (@available(iOS 11.0, *)) {
        label.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    label.text = @"平均绩点";
    self.averangeLabel = label;
    [self addSubview:label];
}
- (void)addTriangle {
    UIButton *button = [[UIButton alloc]init];
    self.triangleButton = button;
//    button.backgroundColor = UIColor.blueColor;
}
- (void)layoutSubviews {
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self).offset(9.5);
    }];
    [self.averangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreLabel);
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(22);
    }];
    [self.triangleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.averangeLabel);
        make.width.equalTo(@8);
        make.height.equalTo(@4);
    }];
}
@end
