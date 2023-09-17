//
//  CenterView.m
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2023/3/15.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "CenterView.h"

@interface CenterView ()

@property (nonatomic, strong) CAGradientLayer *grandLayer;

@end

@implementation CenterView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.grandLayer];
        [self addSubview:self.centerPromptBoxView];
        
        //设置圆角
        self.centerPromptBoxView.layer.cornerRadius = 13;
        self.centerPromptBoxView.layer.masksToBounds = YES;
        
        //设置阴影
        self.centerPromptBoxView.layer.shadowRadius = 8;
        self.centerPromptBoxView.layer.shadowColor = UIColor.lightGrayColor.CGColor;
        self.centerPromptBoxView.layer.shadowOpacity = 0.3;
        
        [self addSubview:self.foodImg];
        [self addSubview:self.biaoTaiImg];
        [self addSubview:self.activityNotifyImg];
        [self addSubview:self.foodBtn];
        [self addSubview:self.biaoTaiBtn];
        [self addSubview:self.activityNotifyBtn];
        [self setPosition];
    }
    return self;
}

#pragma mark - Method

- (void)setPosition {
    // centerPromptBoxView
    [self.centerPromptBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(STATUSBARHEIGHT + 28);
        make.left.equalTo(self).offset(26);
        make.right.equalTo(self).offset(-26);
        make.height.mas_equalTo(77);
    }];
    
//    [self.centerPromptBoxView.backgroundImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.height.width.mas_equalTo(self.centerPromptBoxView);
//    }];
    // foodImg
    [self.foodImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(17);
        make.top.equalTo(self).offset(121.84 + STATUSBARHEIGHT);
        make.size.mas_equalTo(CGSizeMake(168, 209.54));
    }];
    // foodBtn
    [self.foodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(21);
        make.top.equalTo(self).offset(296 + STATUSBARHEIGHT);
        make.size.mas_equalTo(CGSizeMake(132, 50));
    }];
    
    // biaoTaiImg
    [self.biaoTaiImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-24.4);
        make.top.equalTo(self).offset(176.51 + STATUSBARHEIGHT);
        make.size.mas_equalTo(CGSizeMake(153.6, 289.26));
    }];
    
    // biaoTaiBtn
    [self.biaoTaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-41);
        make.top.equalTo(self).offset(410 + STATUSBARHEIGHT);
        make.size.mas_equalTo(CGSizeMake(115, 42));
    }];
    
    // activityNotifyImg
    [self.activityNotifyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(37);
        if (IS_IPHONEX) {
            make.top.equalTo(self).offset(448 + STATUSBARHEIGHT);
        } else {
            make.bottom.equalTo(self).offset(-91.62);
        }
        make.size.mas_equalTo(CGSizeMake(172, 171.38));
    }];
    
    // activityNotifyBtn
    [self.activityNotifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(45);
        if (IS_IPHONEX) {
            make.top.equalTo(self).offset(592 + STATUSBARHEIGHT);
        } else {
            make.bottom.equalTo(self).offset(-76);
        }
        make.size.mas_equalTo(CGSizeMake(132, 50));
    }];
}


#pragma mark - Getter

- (CenterPromptBoxView *)centerPromptBoxView {
    if (_centerPromptBoxView == nil) {
        _centerPromptBoxView = [[CenterPromptBoxView alloc] init];
    }
    return _centerPromptBoxView;
}

- (UIImageView *)foodImg {
    if (_foodImg == nil) {
        _foodImg = [[UIImageView alloc] init];
        _foodImg.image = [UIImage imageNamed:@"foodIcon"];
    }
    return _foodImg;
}

- (UIButton *)foodBtn {
    if (_foodBtn == nil) {
        _foodBtn = [[UIButton alloc] init];
        [_foodBtn setBackgroundImage:[UIImage imageNamed:@"center_btn_backImg"] forState:UIControlStateNormal];
        [_foodBtn setTitle:@"美食咨询处" forState:UIControlStateNormal];
        _foodBtn.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:16];
        _foodBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_foodBtn setTitleColor:[UIColor colorWithHexString:@"#4A44E4" alpha:1.0] forState:UIControlStateNormal];
        [_foodBtn setAdjustsImageWhenHighlighted:NO];
    }
    return _foodBtn;
}

- (UIImageView *)biaoTaiImg {
    if (_biaoTaiImg == nil) {
        _biaoTaiImg = [[UIImageView alloc] init];
        _biaoTaiImg.image = [UIImage imageNamed:@"biaoTaiIcon"];
    }
    return _biaoTaiImg;
}

- (UIButton *)biaoTaiBtn {
    if (_biaoTaiBtn == nil) {
        _biaoTaiBtn = [[UIButton alloc] init];
        [_biaoTaiBtn setBackgroundImage:[UIImage imageNamed:@"center_btn_backImg"] forState:UIControlStateNormal];
        [_biaoTaiBtn setTitle:@"表态广场" forState:UIControlStateNormal];
        _biaoTaiBtn.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:16];
        _biaoTaiBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_biaoTaiBtn setTitleColor:[UIColor colorWithHexString:@"#4A44E4" alpha:1.0] forState:UIControlStateNormal];
        [_biaoTaiBtn setAdjustsImageWhenHighlighted:NO];
    }
    return _biaoTaiBtn;
}

- (UIImageView *)activityNotifyImg {
    if (_activityNotifyImg == nil) {
        _activityNotifyImg = [[UIImageView alloc] init];
        _activityNotifyImg.image = [UIImage imageNamed:@"activityNotify"];
    }
    return _activityNotifyImg;
}

- (UIButton *)activityNotifyBtn {
    if (_activityNotifyBtn == nil) {
        _activityNotifyBtn = [[UIButton alloc] init];
        [_activityNotifyBtn setBackgroundImage:[UIImage imageNamed:@"center_btn_backImg"] forState:UIControlStateNormal];
        [_activityNotifyBtn setTitle:@"活动布告栏" forState:UIControlStateNormal];
        _activityNotifyBtn.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:16];
        _activityNotifyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_activityNotifyBtn setTitleColor:[UIColor colorWithHexString:@"#4A44E4" alpha:1.0] forState:UIControlStateNormal];
        [_activityNotifyBtn setAdjustsImageWhenHighlighted:NO];
    }
    return _activityNotifyBtn;
}

- (CAGradientLayer *)grandLayer {
    if (_grandLayer == nil) {
        _grandLayer = [CAGradientLayer layer];
        _grandLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _grandLayer.startPoint = CGPointMake(0, 0);
        _grandLayer.endPoint = CGPointMake(0, 0.2);
        _grandLayer.colors = @[
            (__bridge id)[UIColor colorWithHexString:@"#CDE1FF" alpha:0.5].CGColor,
            (__bridge id)[UIColor colorWithHexString:@"#FCFCFF" alpha:1.0].CGColor,
            (__bridge id)[UIColor colorWithHexString:@"#FBFCFF" alpha:1.0].CGColor
        ];
        _grandLayer.locations = @[@(0), @(1.0f)];

    }
    return _grandLayer;
}

@end
