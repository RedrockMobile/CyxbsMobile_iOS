//
//  TodoConflictStateView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/10/20.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "TodoConflictStateView.h"

//@interface TodoConflictStateView ()
//
//@end

@implementation TodoConflictStateView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addTipMsgLabel];
        [self addLocalBtn];
        [self addCloudBtn];
        self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F8F9FC" alpha:1] darkColor:[UIColor colorWithHexString:@"#1D1D1D" alpha:1]];
    }
    return self;
}

- (void)addTipMsgLabel {
    UILabel *label = [[UILabel alloc] init];
    self.tipMsgLabel = label;
    [self addSubview:label];
    
    label.font = [UIFont fontWithName:PingFangSCRegular size:15];
    label.numberOfLines = 0;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.04*SCREEN_WIDTH);
        make.right.equalTo(self).offset(-0.04*SCREEN_WIDTH);
        make.top.equalTo(self).offset(0.052*SCREEN_WIDTH);
    }];
}

- (void)addLocalBtn {
    UIButton *btn = [self getConflictChooseBtn];
    self.localBtn = btn;
    [self addSubview:btn];
    
    [btn setTitle:@"本地存档" forState:UIControlStateNormal];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0.2893333333*SCREEN_WIDTH);
        make.left.equalTo(self).offset(0.128*SCREEN_WIDTH);
    }];

}

- (void)addCloudBtn {
    UIButton *btn = [self getConflictChooseBtn];
    self.cloudBtn = btn;
    [self addSubview:btn];
    
    [btn setTitle:@"云存档" forState:UIControlStateNormal];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0.2893333333*SCREEN_WIDTH);
        make.right.equalTo(self).offset(-0.128*SCREEN_WIDTH);
    }];
}


- (UIButton*)getConflictChooseBtn {
    UIButton *btn = [[UIButton alloc] init];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"Todo紫色边框按钮"] forState:UIControlStateNormal];
    
    btn.layer.cornerRadius = 0.04533333333*SCREEN_WIDTH;
    [btn setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2923D2" alpha:1] darkColor:[UIColor colorWithHexString:@"#2CDEFF" alpha:1]] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:PingFangSCRegular size:16];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.32*SCREEN_WIDTH);
        make.height.mas_equalTo(0.09066666667*SCREEN_WIDTH);
    }];
    return btn;
}
@end
