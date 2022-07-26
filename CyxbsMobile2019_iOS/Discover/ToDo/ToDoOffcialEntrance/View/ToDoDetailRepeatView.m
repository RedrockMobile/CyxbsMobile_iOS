//
//  ToDoDetailRepeatView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/9/18.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "ToDoDetailRepeatView.h"

@implementation ToDoDetailRepeatView
@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLbl.text = @"重复";
    }
    return self;
}

- (void)remindLblClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseRepeatStytle)]) {
        [self.delegate chooseRepeatStytle];
    }
}

#pragma mark- private methonds
- (void)setUI{
    [super setUI];
    
    [self addSubview:self.repeatLbl];
    [self.repeatLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(SCREEN_HEIGHT * 0.0123);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8266, SCREEN_HEIGHT * 0.0258));
    }];
    
    [self addSubview:self.repeatContentScrollView];
    [self.repeatContentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(SCREEN_HEIGHT * 0.0123);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8266, SCREEN_WIDTH * 0.056));
    }];
    
}

///对scrollView上面的东西进行排列
- (void)relayoutLblsByArray:(NSArray *)arrary{
    if (arrary.count == 0) {
        self.repeatLbl.alpha = 0.4;
        self.repeatContentScrollView.alpha = 0;
        return;
    }
    self.repeatLbl.alpha = 0;
    self.repeatContentScrollView.alpha = 1;
    
    MASViewAttribute* last = self.repeatContentScrollView.mas_left;
    for (int i = 0; i < arrary.count; i++) {
        UILabel *lbl = arrary[i];
        [self.repeatContentScrollView addSubview:lbl];
        [lbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(SCREEN_WIDTH * 0.056);
            make.top.equalTo(self.repeatContentScrollView);
            make.left.equalTo(last).offset(i == 0 ? 0 : 0.03733333333*SCREEN_WIDTH);
        }];
        last = lbl.mas_right;
    }
    
    [[arrary lastObject] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.repeatContentScrollView).offset(-0.03733333333*SCREEN_WIDTH);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat x = self.repeatContentScrollView.contentSize.width-SCREEN_WIDTH;
        if (x>60) {
            [UIView animateWithDuration:0.25 animations:^{
                self.repeatContentScrollView.contentOffset = CGPointMake(x+4, 0);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.repeatContentScrollView.contentOffset = CGPointMake(x, 0);
                }];
            }];
        }
    });
    
    
}

#pragma mark- getter
- (UILabel *)repeatLbl{
    if (!_repeatLbl) {
        _repeatLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _repeatLbl.text = @"设置重复提醒";
        _repeatLbl.font = [UIFont fontWithName:PingFangSCMedium size:15];
        _repeatLbl.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        _repeatLbl.alpha = 0.4;
        _repeatLbl.userInteractionEnabled = YES;
        
        //添加点击手势
        [_repeatLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remindLblClicked)]];
    }
    return _repeatLbl;
}

- (UIScrollView *)repeatContentScrollView{
    if (!_repeatContentScrollView) {
        _repeatContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        //不展示垂直、水平滑动条
        _repeatContentScrollView.showsVerticalScrollIndicator = NO;
        _repeatContentScrollView.showsHorizontalScrollIndicator = NO;
        _repeatContentScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_repeatContentScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remindLblClicked)]];
    }
    return _repeatContentScrollView;
}

@end
