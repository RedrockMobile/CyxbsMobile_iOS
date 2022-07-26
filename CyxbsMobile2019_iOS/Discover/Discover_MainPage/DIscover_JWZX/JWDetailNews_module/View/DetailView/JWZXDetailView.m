//
//  JWZXDetailView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/7.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "JWZXDetailView.h"

@interface JWZXDetailView ()

/// 显示日期Lab
@property (nonatomic, strong) UILabel *dateLab;

/// 显示标题Lab
@property (nonatomic, strong) UILabel *titleLab;

/// 显示细节UITextView
@property (nonatomic, strong) UITextView *detailView;

@end

@implementation JWZXDetailView

#pragma mark - Init

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, STATUSBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBARHEIGHT)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F2F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
        [self addSubview:self.dateLab];
        [self addSubview:self.titleLab];
        [self addSubview:self.detailView];
    }
    return self;
}

#pragma mark - Method

- (void)loadViewWithDate:(NSString *)date
                   title:(NSString *)title
                  detail:(NSString *)detail {
    self.dateLab.text = date;
    self.titleLab.text = title;
    self.detailView.text = detail;
}

#pragma mark - Getter

- (UILabel *)dateLab {
    if (_dateLab == nil) {
        _dateLab = [[UILabel alloc] initWithFrame:CGRectMake(2, 22, 100, 22)];
        _dateLab.font = [UIFont fontWithName:PingFangSCRegular size:13];
        _dateLab.textColor =
        [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#294169" alpha:0.7]
                              darkColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]];
    }
    return _dateLab;
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.dateLab.left, self.dateLab.bottom + 8, self.width - 2 * self.dateLab.left, 80)];
        _titleLab.numberOfLines = 0;
        _titleLab.font = [UIFont fontWithName:PingFangSCBold size:18];
        
        _titleLab.textColor =
        [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1]
                              darkColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]];
    }
    return _titleLab;
}

- (UITextView *)detailView {
    if (_detailView == nil) {
        _detailView = [[UITextView alloc] initWithFrame:CGRectMake(self.titleLab.left, self.titleLab.bottom + 14, self.width - 2 * self.dateLab.left, self.height - self.titleLab.bottom)];
        _detailView.editable = NO;
        _detailView.font = [UIFont fontWithName:PingFangSCRegular size:15];
        
        _detailView.textColor =
        [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1]
                              darkColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]];
        
        _detailView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F2F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
    }
    return _detailView;
}

@end
