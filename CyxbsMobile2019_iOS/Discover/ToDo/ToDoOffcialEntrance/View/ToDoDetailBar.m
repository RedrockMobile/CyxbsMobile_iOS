//
//  ToDoDetailBar.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/8/24.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "ToDoDetailBar.h"
@interface ToDoDetailBar()
/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;

/// 底部分割线
@property (nonatomic, strong) UIView *spliteLine;
@end
@implementation ToDoDetailBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorNamed:@"255_255_255&0_0_0"];
        [self buildFrame];
    }
    return self;
}

- (void)buildFrame{
    //返回按钮
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.top.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.0986);
    }];
    
    //右边的保存按钮
    [self addSubview:self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self.backBtn);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.1, SCREEN_WIDTH * 0.1));
    }];
    
    //分割线
    [self addSubview:self.spliteLine];
    [self.spliteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    //添加两个图标
        //返回按钮的图标
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    backImageView.image = [UIImage imageNamed:@"todo返回按钮"];
    [self addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(SCREEN_WIDTH * 0.0409);
        make.centerY.equalTo(self.backBtn);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.0256, SCREEN_WIDTH * 0.0512));
    }];
        //添加改变按钮上的文字
    [self addSubview:self.saveLbl];
    [self.saveLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-SCREEN_WIDTH * 0.04);
        make.centerY.equalTo(backImageView);
    }];
 
    
}

#pragma mark- event responese
- (void)back{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(popVC)]) {
        [self.delegate popVC];
    }
}

- (void)saveThing{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(saveChanges)]) {
        [self.delegate saveChanges];
    }
}

#pragma mark- getter
///返回按钮
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _backBtn.backgroundColor = [UIColor clearColor];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _saveBtn.backgroundColor = [UIColor clearColor];
        _saveBtn.userInteractionEnabled = NO;
        [_saveBtn addTarget:self action:@selector(saveThing) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

- (UILabel *)saveLbl{
    if (!_saveLbl) {
        _saveLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _saveLbl.text = @"保存";
        _saveLbl.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        _saveLbl.font = [UIFont fontWithName:PingFangSCBold size:20];
        _saveLbl.alpha = 0.6;
    }
    return _saveLbl;
}

- (UIView *)spliteLine{
    if (!_spliteLine) {
        _spliteLine = [[UIView alloc] initWithFrame:CGRectZero];
        _spliteLine.backgroundColor = [UIColor colorNamed:@"42_78_132&223_223_227"];
        _spliteLine.alpha = 0.1;
    }
    return _spliteLine;
}
@end
