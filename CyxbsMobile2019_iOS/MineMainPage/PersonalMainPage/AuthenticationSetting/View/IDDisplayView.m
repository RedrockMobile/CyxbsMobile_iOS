//
//  IDDisplayView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "IDDisplayView.h"
//开启CCLog
#define CCLogEnable 0

@interface IDDisplayView ()
@property (nonatomic, strong)UIImageView *imgView;
@property (nonatomic, strong)UILabel *label;
@end

@implementation IDDisplayView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addImgView];
        [self addLabel];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0.9146666667*SCREEN_WIDTH);
            make.height.mas_equalTo(0.3333333333*SCREEN_WIDTH);
        }];
    }
    return self;
}

- (void)addImgView {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dottedLineFrame"]];
    self.imgView = imgView;
    [self addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)addLabel {
    UILabel *label = [[UILabel alloc] init];
    self.label = label;
    [self addSubview:label];
    
    label.font = [UIFont fontWithName:PingFangSCRegular size:16];
    label.textColor = [UIColor dm_colorWithLightColor:RGBColor(21, 49, 91, 1) darkColor:RGBColor(240, 240, 242, 1)];
    label.text = @"长按下方身份牌并拖动到此处，即可在昵称后面展示你的专属身份!";
    label.numberOfLines = 3;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.04533333333*SCREEN_WIDTH);
        make.top.equalTo(self).offset(0.07733333333*SCREEN_WIDTH);
        make.width.mas_equalTo(0.832*SCREEN_WIDTH);
    }];
}


@end
