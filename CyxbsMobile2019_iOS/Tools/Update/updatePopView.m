//
//  updatePopView.m
//  CyxbsMobile2019_iOS
//
//  Created by Clutch Powers on 2022/3/22.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "updatePopView.h"
#import <Masonry.h>

@interface updatePopView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *placeholderLab1;
//@property (nonatomic, strong) UILabel *placeholderLab2;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *questionBtn;
@property (nonatomic, strong) UIButton *emailBtn;

@end

@implementation updatePopView

- (instancetype) initWithFrame:(CGRect)frame WithUpdateInfo:(NSDictionary *)info{
    if ([super initWithFrame:frame]) {
        
        UIView *backView = [[UIView alloc] init];
        backView.userInteractionEnabled = YES;
        backView.backgroundColor = [UIColor colorWithRed:0/255.0 green:15/255.0 blue:37/255.0 alpha:1.0];
        backView.alpha = 0.3;
        backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self addSubview:backView];
        _backView = backView;
        
        UIView *AlertView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            AlertView.backgroundColor = [UIColor colorNamed:@"MGDSafePopBackColor"];
        } else {
            // Fallback on earlier versions
        }
        AlertView.layer.cornerRadius = 16;
        [self addSubview:AlertView];
        _AlertView = AlertView;
        
        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.size = CGSizeMake(35,35);
        imageView.image = [UIImage imageNamed:@"Cyxbs"];
        [_AlertView addSubview:imageView];
        _imageView = imageView;
        
        UILabel *placeholderLab1 = [[UILabel alloc] init];
        placeholderLab1.text = [NSString stringWithFormat:@"%@ 新版本已上线 ",info[@"version"]];
        placeholderLab1.textAlignment = NSTextAlignmentCenter;
        placeholderLab1.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 17];
        if (@available(iOS 11.0, *)) {
            placeholderLab1.textColor = [UIColor colorNamed:@"MGDSafeTextColor"];
        } else {
            // Fallback on earlier versions
        }
        [_AlertView addSubview:placeholderLab1];
        _placeholderLab1 = placeholderLab1;
        
//        UILabel *placeholderLab2 = [[UILabel alloc] init];
////        placeholderLab2.text = [NSString stringWithFormat:@"%@ ",info[@"releaseNotes"]];
//        placeholderLab2.text = @"1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
//        placeholderLab2.textAlignment = NSTextAlignmentCenter;
//        placeholderLab2.numberOfLines = 8;
//        placeholderLab2.lineBreakMode = NSLineBreakByWordWrapping;
//        placeholderLab2.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
//        if (@available(iOS 11.0, *)) {
//            placeholderLab2.textColor = [UIColor colorNamed:@"MGDSafeTextColor"];
//        } else {
//            // Fallback on earlier versions
//        }
//        [_AlertView addSubview:placeholderLab2];
//        _placeholderLab2 = placeholderLab2;
        
        self.textView = [[UITextView alloc]init];
//        self.textView.userInteractionEnabled = NO;
        self.textView.editable = NO;
        self.textView.text =  [NSString stringWithFormat:@"%@ ",info[@"releaseNotes"]];
        [_AlertView addSubview:self.textView];
        
        
        UIButton *questionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [questionBtn setTitle:@"暂时不用" forState:UIControlStateNormal];
        [questionBtn setBackgroundColor:[UIColor colorWithRed:195/255.0 green:212/255.0 blue:238/255.0 alpha:1.0]];
        [questionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        questionBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
        [questionBtn addTarget:self action:@selector(Cancel) forControlEvents:UIControlEventTouchUpInside];
        [_AlertView addSubview:questionBtn];
        _questionBtn = questionBtn;
        
        
        UIButton *emailBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [emailBtn setTitle:@"立即更新" forState:UIControlStateNormal];
        [emailBtn setBackgroundColor:[UIColor colorWithRed:72/255.0 green:65/255.0 blue:226/255.0 alpha:1.0]];
        [emailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        emailBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
        [emailBtn addTarget:self action:@selector(Update) forControlEvents:UIControlEventTouchUpInside];
        [_AlertView addSubview:emailBtn];
        _emailBtn = emailBtn;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_AlertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_HEIGHT * 0.3157);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.16);
        make.right.mas_equalTo(self.mas_right).mas_offset(-SCREEN_WIDTH * 0.16);
        make.height.mas_equalTo(300);
    }];
     
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_AlertView.mas_top);
        make.centerX.equalTo(self.mas_centerX);
        make.size.equalTo(@100);
    }];
    
    [_placeholderLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageView.mas_bottom);
        make.left.mas_equalTo(_AlertView.mas_left);
        make.right.mas_equalTo(_AlertView.mas_right);
        make.height.mas_equalTo(30);
    }];
    
//    [_placeholderLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_placeholderLab1.mas_bottom).mas_offset(10);
//        make.left.mas_equalTo(_AlertView.mas_left).mas_offset(5);
//        make.right.mas_equalTo(_AlertView.mas_right).mas_offset(-5);
//        make.bottom.mas_equalTo(_AlertView.mas_bottom).mas_offset(-50);
//    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_placeholderLab1.mas_bottom).mas_offset(10);
            make.left.mas_equalTo(_AlertView.mas_left).mas_offset(5);
            make.right.mas_equalTo(_AlertView.mas_right).mas_offset(-3);
            make.bottom.mas_equalTo(_AlertView.mas_bottom).mas_offset(-50);
    }];
    
    [_questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.AlertView.mas_bottom).offset(-17);
        make.left.mas_equalTo(_AlertView.mas_left).mas_offset(SCREEN_WIDTH * 0.0613);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.256);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.256 * 34/96);
    }];
    _questionBtn.layer.cornerRadius = SCREEN_WIDTH * 0.256 * 34/96 * 1/2;
    
    [_emailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_AlertView.mas_left).mas_offset(SCREEN_WIDTH * 0.3627);
        make.top.width.height.mas_equalTo(_questionBtn);
    }];
    _emailBtn.layer.cornerRadius = _questionBtn.layer.cornerRadius;
    
}

- (void) Cancel {
    if ([self.delegate respondsToSelector:@selector(Cancel)]) {
        [self.delegate Cancel];
    }
}
- (void) Update {
    if ([self.delegate respondsToSelector:@selector(Update)]) {
        [self.delegate Update];
    }
}

@end
