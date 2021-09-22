//
//  NewQAHeadrView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/9/12.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NewQAHeadrView.h"

@interface NewQAHeadrView()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *leftCircleView;
@property (nonatomic, strong) UIImageView *rightCircleView;

@end

@implementation NewQAHeadrView

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView* view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UIButton class]]) {
        return view;
    }
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backImageView.layer.masksToBounds = YES;
        _backImageView.image = [UIImage imageNamed:@"NewQATopImage"];
        [self addSubview:_backImageView];
    
        _leftCircleView = [[UIImageView alloc] init];
        _leftCircleView.layer.masksToBounds = YES;
        _leftCircleView.backgroundColor = [UIColor clearColor];
        _leftCircleView.image = [UIImage imageNamed:@"NewQATopLeftCircleImage"];
        [_backImageView addSubview:_leftCircleView];
        _rightCircleView = [[UIImageView alloc] init];
        _rightCircleView.layer.masksToBounds = YES;
        _rightCircleView.backgroundColor = [UIColor clearColor];
        _rightCircleView.image = [UIImage imageNamed:@"NewQATopRightCircleImage"];
        [_backImageView addSubview:_rightCircleView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_leftCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backImageView.mas_top).mas_offset(12);
        make.left.mas_equalTo(self.backImageView.mas_left);
        make.width.mas_equalTo([UIImage imageNamed:@"NewQATopLeftCircleImage"].size.width);
        make.height.mas_equalTo([UIImage imageNamed:@"NewQATopLeftCircleImage"].size.height);
    }];

    [_rightCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backImageView.mas_top).mas_offset(30);
        make.right.mas_equalTo(self.backImageView.mas_right);
        make.width.mas_equalTo([UIImage imageNamed:@"NewQATopRightCircleImage"].size.width);
        make.height.mas_equalTo([UIImage imageNamed:@"NewQATopRightCircleImage"].size.height);
    }];
}

@end
