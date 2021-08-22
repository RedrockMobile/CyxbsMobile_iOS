//
//  ToDoMainBarView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/8/21.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "ToDoMainBarView.h"
@interface ToDoMainBarView()
/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;
/// “邮子清单”的文本标题
@property (nonatomic, strong) UILabel *titleLbl;
/// 添加事务的button
@property (nonatomic, strong) UIButton *addMatterBtn;

/// 底部分割线
@property (nonatomic, strong) UIView *spliteLine;
@end

@implementation ToDoMainBarView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame];
    }
    return self;
}

#pragma mark- private methonds
- (void)setFrame{
    //返回按钮
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.top.equalTo(self).offset(SCREEN_HEIGHT * 0.0142);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.0986, SCREEN_HEIGHT * 0.0434));
        make.width.mas_equalTo(SCREEN_WIDTH * 0.0986);
    }];
    
    //标题
    [self addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backBtn.mas_right);
            make.top.height.equalTo(self.backBtn);
            make.width.mas_equalTo(SCREEN_WIDTH * 0.2346);
    }];
    
    //右边的添加按钮
    [self addSubview:self.addMatterBtn];
    [self.addMatterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).offset(-15);
        make.right.equalTo(self);
        make.top.equalTo(self.backBtn);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.048, SCREEN_WIDTH * 0.048));
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.088, SCREEN_WIDTH * 0.088));
    }];
    
    //分割线
    [self addSubview:self.spliteLine];
    [self.spliteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
}

#pragma mark- event response
/// 捕获事件让代理去执行返回上一个vc的逻辑操作
- (void)back{
    if ([self.delegate respondsToSelector:@selector(popVC)] && self.delegate != nil) {
        [self.delegate popVC];
    }
}

/// 捕获事件让代理去执行反
- (void)addThing{
    if ([self.delegate respondsToSelector:@selector(addMatter)] && self.delegate != nil) {
        [self.delegate addMatter];
    }
}
#pragma mark- getter
///返回按钮
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _backBtn.backgroundColor = [UIColor redColor];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.text = @"邮子清单";
        _titleLbl.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        _titleLbl.font = [UIFont fontWithName:PingFangSCBold  size:21];
    }
    return _titleLbl;
}

- (UIButton *)addMatterBtn{
    if (!_addMatterBtn) {
        _addMatterBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _addMatterBtn.backgroundColor = [UIColor redColor];
        [_addMatterBtn addTarget:self action:@selector(addThing) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addMatterBtn;
}

- (UIView *)spliteLine{
    if (!_spliteLine) {
        _spliteLine = [[UIView alloc] initWithFrame:CGRectZero];
        _spliteLine.backgroundColor = [UIColor colorNamed:@"42_78_132&223_223_227"];
    }
    return _spliteLine;
}
@end
