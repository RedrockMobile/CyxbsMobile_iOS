//
//  JWZXDetailNewsTopView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/7.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "JWZXDetailNewsTopView.h"

#pragma mark - JWZXDetailNewsTopView ()

@interface JWZXDetailNewsTopView ()

/// 下载附件按钮
@property (nonatomic, strong) UIButton *downloadBtn;

@end

#pragma mark - JWZXDetailNewsTopView

@implementation JWZXDetailNewsTopView

#pragma mark - Init

- (instancetype)initWithSafeViewHeight:(CGFloat)height {
    self = [super initWithSafeViewHeight:height];
    if (self) {
        self.hadLine = YES;
        self.backgroundColor = [UIColor colorNamed:@"ColorBackground"];
        [self
         addTitle:@"教务新闻"
         withTitleLay:SSRTopBarBaseViewTitleLabLayLeft
         withStyle:nil];
    }
    return self;
}

#pragma mark - Method

- (void)addDonwloadButtonTarget:(id)target action:(SEL)action {
    [self.downloadBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Getter

- (UIButton *)downloadBtn {
    if (_downloadBtn == nil) {
        _downloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 87, 29)];
        [_downloadBtn setTitle:@"下载附件" forState:UIControlStateNormal];
        [_downloadBtn setTitleColor:[UIColor colorNamed:@"color21_49_91&#F0F0F2"] forState:UIControlStateNormal];
        [_downloadBtn setTitleColor:[UIColor colorNamed:@"color21_49_91&#F0F0F2_alpha0.59"] forState:UIControlStateHighlighted];
        _downloadBtn.titleLabel.font = [UIFont fontWithName:PingFangSCRegular size:15];
    }
    return _downloadBtn;
}

#pragma mark - Setter

- (void)setHaveFiled:(BOOL)haveFiled {
    if (_haveFiled == haveFiled) {
        return;
    }
    _haveFiled = haveFiled;
    if (_haveFiled) {
        [self.safeView addSubview:self.downloadBtn];
        self.downloadBtn.centerY = self.safeView.SuperCenter.y;
        self.downloadBtn.right = self.safeView.right - 15;
    } else {
        [self.downloadBtn removeFromSuperview];
    }
}

@end
