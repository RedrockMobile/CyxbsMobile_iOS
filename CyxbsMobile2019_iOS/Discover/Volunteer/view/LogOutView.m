//
//  LogOutView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/13.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "LogOutView.h"

@interface LogOutView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *logOutLabel;
@property (nonatomic, strong) UILabel *queryyLogOutLabel;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation LogOutView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        backView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        backView.alpha = 0.14;
        [self addSubview:backView];
        _backView = backView;
        
        UIView *popView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            popView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
        popView.layer.cornerRadius = 8;
        [self addSubview:popView];
        _popView = popView;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"退出图片"];
        [_popView addSubview:imageView];
        _imageView = imageView;
        
        UILabel *logOutLabel = [[UILabel alloc] init];
        logOutLabel.text = @"取消绑定";
        if (@available(iOS 11.0, *)) {
            logOutLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F0" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
        logOutLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
        logOutLabel.textAlignment = NSTextAlignmentCenter;
        [_popView addSubview:logOutLabel];
        _logOutLabel = logOutLabel;
        
        UILabel *queryLogOutLabel = [[UILabel alloc] init];
        queryLogOutLabel.text = @"是否取消志愿者账号绑定？";
        queryLogOutLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 11];
        if (@available(iOS 11.0, *)) {
            queryLogOutLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F0" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
        queryLogOutLabel.textAlignment = NSTextAlignmentCenter;
        [_popView addSubview:queryLogOutLabel];
        _queryyLogOutLabel = queryLogOutLabel;
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
        sureBtn.tintColor = [UIColor whiteColor];
        [sureBtn setBackgroundColor:[UIColor colorWithRed:72/255.0 green:65/255.0 blue:226/255.0 alpha:1.0]];
        [sureBtn addTarget:self action:@selector(ClickedSure) forControlEvents:UIControlEventTouchUpInside];
        [_popView addSubview:sureBtn];
        _sureBtn = sureBtn;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
        cancelBtn.tintColor = [UIColor whiteColor];
        [cancelBtn setBackgroundColor:[UIColor colorWithRed:195/255.0 green:212/255.0 blue:238/255.0 alpha:1.0]];
        [cancelBtn addTarget:self action:@selector(ClickedCancel) forControlEvents:UIControlEventTouchUpInside];
        [_popView addSubview:cancelBtn];
        _cancelBtn = cancelBtn;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_top).mas_offset(SCREEN_HEIGHT * 0.3153);
        make.left.mas_equalTo(self.backView.mas_left).mas_offset(SCREEN_WIDTH * 0.16);
        make.right.mas_equalTo(self.backView.mas_right).mas_offset(-SCREEN_WIDTH * 0.16);
        make.bottom.mas_equalTo(self.backView.mas_bottom).mas_offset(-SCREEN_HEIGHT * 0.2796);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.popView.mas_top).mas_offset(SCREEN_HEIGHT * 0.0493);
        make.left.mas_equalTo(self.popView.mas_left).mas_offset(SCREEN_WIDTH * 0.168);
        make.right.mas_equalTo(self.popView.mas_right).mas_offset(-SCREEN_WIDTH * 0.112);
        make.bottom.mas_equalTo(self.popView.mas_bottom).mas_offset(-SCREEN_HEIGHT * 0.2229);
    }];
    
    [_logOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.popView.mas_top).mas_offset(SCREEN_HEIGHT * 0.2094);
        make.left.right.mas_equalTo(self.popView);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0308);
    }];
    
    [_queryyLogOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.popView.mas_top).mas_offset(SCREEN_HEIGHT * 0.2525);
        make.left.right.mas_equalTo(self.popView);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0197);
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.popView.mas_top).mas_offset(SCREEN_HEIGHT * 0.3276);
        make.left.mas_equalTo(self.popView.mas_left).mas_offset(SCREEN_WIDTH * 0.368);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.2454);
        make.bottom.mas_equalTo(self.popView.mas_bottom).mas_offset(-SCREEN_HEIGHT * 0.0357);
    }];
    _sureBtn.layer.cornerRadius = SCREEN_HEIGHT * 0.0419 / 2;
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.bottom.mas_equalTo(self.sureBtn);
        make.left.mas_equalTo(self.popView.mas_left).mas_offset(SCREEN_WIDTH * 0.0693);
    }];
    _cancelBtn.layer.cornerRadius = _sureBtn.layer.cornerRadius;
}

- (void)ClickedSure {
    if ([self.delegate respondsToSelector:@selector(ClickedSureBtn)]) {
        [self.delegate ClickedSureBtn];
    }
}

- (void)ClickedCancel {
    if ([self.delegate respondsToSelector:@selector(ClickedCancelBtn)]) {
        [self.delegate ClickedCancelBtn];
    }
}



@end
