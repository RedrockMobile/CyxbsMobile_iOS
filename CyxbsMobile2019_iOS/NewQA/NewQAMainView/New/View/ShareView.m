//
//  ShareView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ShareBtn.h"
#import "ShareView.h"
#define LeftAndRightGap SCREEN_WIDTH * 0.0427
#define ButtonWidth SCREEN_WIDTH * 0.125
#define ButtonHeigth SCREEN_WIDTH * 0.125 * 64/44

@interface ShareView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *cancelLineView;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) ShareBtn *shareBtn;
@property (nonatomic, strong) NSMutableArray<ShareBtn *>* btnArray;

@end

@implementation ShareView

- (instancetype)init {
    if ([super init]) {
        self.layer.cornerRadius = 8;
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#2D2D2D" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.text = @"分享";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
        if (@available(iOS 11.0, *)) {
            _titleLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:_titleLabel];
        
        _lineView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _lineView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E2E8EE" alpha:1] darkColor:[UIColor colorWithHexString:@"#343434" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:_lineView];
        
        NSArray *array = @[@"QQ空间",@"朋友圈",@"QQ",@"微信好友",@"复制链接"];
        NSMutableArray *btnArray = [NSMutableArray array];
        for (NSString *name in array) {
            _shareBtn = [[ShareBtn alloc] initWithImage:[UIImage imageNamed:name] AndName:name];
            [btnArray addObject:_shareBtn];
        }
        self.btnArray = btnArray;
        for (ShareBtn *btn in self.btnArray) {
            if ([btn.title.text isEqual: @"QQ空间"]) {
                [btn addTarget:self action:@selector(ClickedQQZone) forControlEvents:UIControlEventTouchUpInside];
            }else if([btn.title.text isEqual: @"朋友圈"]) {
                [btn addTarget:self action:@selector(ClickedVXGroup) forControlEvents:UIControlEventTouchUpInside];
            }else if([btn.title.text isEqual: @"QQ"]) {
                [btn addTarget:self action:@selector(ClickedQQ) forControlEvents:UIControlEventTouchUpInside];
            }else if([btn.title.text isEqual: @"微信好友"]) {
                [btn addTarget:self action:@selector(ClickedVXFriend) forControlEvents:UIControlEventTouchUpInside];
            }else if ([btn.title.text isEqual: @"复制链接"]) {
                [btn addTarget:self action:@selector(ClickedUrl) forControlEvents:UIControlEventTouchUpInside];
            }
            [self addSubview:btn];
        }
        
        _cancelLineView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _cancelLineView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E2E8EE" alpha:1] darkColor:[UIColor colorWithHexString:@"#343434" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:_cancelLineView];
        
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_cancelBtn addTarget:self action:@selector(ClickedCancel) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Heavy" size: 15];
        if (@available(iOS 11.0, *)) {
            [_cancelBtn setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#94A6C4" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]] forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:_cancelBtn];
        
    }
    return self;
}

- (void)layoutSubviews {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(SCREEN_WIDTH * 50/375);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    int i = 0;
    for (ShareBtn *button in self.btnArray) {
        if (button == self.btnArray[0]) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(LeftAndRightGap);
                make.top.equalTo(self.lineView.mas_bottom).mas_offset(SCREEN_WIDTH * 24.5/375);
                make.height.mas_equalTo(ButtonHeigth);
                make.width.mas_equalTo(ButtonWidth);
            }];
        } else if (button == self.btnArray[self.btnArray.count - 1]) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).mas_offset(-LeftAndRightGap);
                make.top.equalTo(self.btnArray[0].iconImage.mas_top);
                make.height.mas_equalTo(ButtonHeigth);
                make.width.mas_equalTo(ButtonWidth);
            }];
        } else {
            //x表示第一个button的右边和最后一个button的左边中间的距离
            float x = self.frame.size.width - 2 * LeftAndRightGap - 2 * ButtonWidth;
            //y表示x减去控件长度之后剩下的长度
            float y = x - (self.btnArray.count - 2) * ButtonWidth;
            //z代表每个控件左边距离self的距离
            float z = LeftAndRightGap + ButtonWidth + i * y / (self.btnArray.count - 1) + (i - 1) * ButtonWidth;
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.btnArray[0].iconImage.mas_top);
                make.height.mas_equalTo(ButtonHeigth);
                make.width.mas_equalTo(ButtonWidth);
                make.left.equalTo(@(z));
            }];
        }
        i++;
    }
    
    [_cancelLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btnArray[0].mas_bottom).mas_offset(SCREEN_HEIGHT * 0.027);
        make.left.right.height.mas_equalTo(self.lineView);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cancelLineView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self);
    }];
}

- (void)ClickedQQZone {
    if ([self.delegate respondsToSelector:@selector(ClickedQQZone)]){
        [self.delegate ClickedQQZone];
    }
}

- (void)ClickedVXGroup {
    if ([self.delegate respondsToSelector:@selector(ClickedVXGroup)]){
        [self.delegate ClickedVXGroup];
    }
}

- (void)ClickedQQ {
    if ([self.delegate respondsToSelector:@selector(ClickedQQ)]){
        [self.delegate ClickedQQ];
    }
}

- (void)ClickedVXFriend {
    if ([self.delegate respondsToSelector:@selector(ClickedVXFriend)]){
        [self.delegate ClickedVXFriend];
    }
}

- (void)ClickedUrl {
    if ([self.delegate respondsToSelector:@selector(ClickedUrl)]){
        [self.delegate ClickedUrl];
    }
}

- (void)ClickedCancel {
    if ([self.delegate respondsToSelector:@selector(ClickedCancel)]) {
        [self.delegate ClickedCancel];
    }
}

@end
