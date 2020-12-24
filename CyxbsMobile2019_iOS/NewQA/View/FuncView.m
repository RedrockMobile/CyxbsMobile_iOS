//
//  FuncView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "FuncView.h"

@implementation FuncView

- (instancetype)init{
    if ([super init]) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"ReportBackColor"];
        } else {
            // Fallback on earlier versions
        }
//        UIButton *starGroupBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        starGroupBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 14];
//        if (@available(iOS 11.0, *)) {
//            [starGroupBtn setTitleColor:[UIColor colorNamed:@"ReportTextColor"] forState:UIControlStateNormal];
//        } else {
//            // Fallback on earlier versions
//        }
//        [starGroupBtn addTarget:self action:@selector(ClickedStarGroupBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:starGroupBtn];
//        _starGroupBtn = starGroupBtn;
        
        UIButton *shieldBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [shieldBtn setTitle:@"屏蔽此人" forState:UIControlStateNormal];
        shieldBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
        if (@available(iOS 11.0, *)) {
            [shieldBtn setTitleColor:[UIColor colorNamed:@"ReportTextColor"] forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
        }
        [shieldBtn addTarget:self action:@selector(ClickedShieldBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shieldBtn];
        _shieldBtn = shieldBtn;
        
        UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [reportBtn setTitle:@"举报" forState:UIControlStateNormal];
        reportBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
        if (@available(iOS 11.0, *)) {
            [reportBtn setTitleColor:[UIColor colorNamed:@"ReportTextColor"] forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
        }
        [reportBtn addTarget:self action:@selector(ClickedReportBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:reportBtn];
        _reportBtn = reportBtn;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    [_starGroupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mas_top);
//        make.left.mas_equalTo(self.mas_left);
//        make.right.mas_equalTo(self.mas_right);
//        make.height.mas_equalTo(self.frame.size.height * 1/3);
//    }];
    
    [_shieldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.height.mas_equalTo(_starGroupBtn);
//        make.top.mas_equalTo(_starGroupBtn.mas_bottom);
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(self.frame.size.height * 1/2);
    }];
    
    [_reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.height.mas_equalTo(_starGroupBtn);
//        make.top.mas_equalTo(_shieldBtn.mas_bottom);
        make.left.right.bottom.mas_equalTo(self);
        make.top.mas_equalTo(_shieldBtn.mas_bottom);
    }];
}

//- (void)ClickedStarGroupBtn:(UIButton *)sender {
//    if ([self.delegate respondsToSelector:@selector(ClickedStarGroupBtn:)]) {
//        [self.delegate ClickedStarGroupBtn:sender];
//    }
//}

- (void)ClickedShieldBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(ClickedShieldBtn:)]) {
        [self.delegate ClickedShieldBtn:sender];
    }
}

- (void)ClickedReportBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(ClickedReportBtn:)]) {
        [self.delegate ClickedReportBtn:sender];
    }
}
@end
