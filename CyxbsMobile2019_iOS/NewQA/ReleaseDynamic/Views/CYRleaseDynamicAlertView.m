//
//  CYRleaseDynamicAlertView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/3/25.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "CYRleaseDynamicAlertView.h"
#import "CYRleaseSaveDraftAlertBtn.h"
@interface CYRleaseDynamicAlertView()
/// 显示标题的label
@property (nonatomic, strong) UILabel *titleLbl;

/// 保存按钮
@property (nonatomic, strong) CYRleaseSaveDraftAlertBtn *savebtn;

/// 不保存按钮
@property (nonatomic, strong) CYRleaseSaveDraftAlertBtn *noteSaveBtn;

/// 取消按钮
@property (nonatomic, strong) CYRleaseSaveDraftAlertBtn *cancelBtn;

/// 第一条分割线
@property (nonatomic, strong) UIView *firstSegementationView;

/// 第二条分割线
@property (nonatomic, strong) UIView *secondSegementationView;

/// 取消和不保存之间间隔的view
@property (nonatomic, strong) UIView *intervalView;

@end
@implementation CYRleaseDynamicAlertView

#pragma mark- lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F1F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#2D2D2D" alpha:1]];
        self.layer.cornerRadius = 15;    //设置圆角
        [self addViews];
        [self addViewsConstraint];
    }
    return self;
}

#pragma mark- private methonds
/// 添加这些视图
- (void)addViews{
    
    [self addSubview:self.titleLbl];    //标题
    
    [self addSubview:self.savebtn];     //保存按钮
    
    [self addSubview:self.noteSaveBtn]; //不保存
    
    [self addSubview:self.cancelBtn];   //取消
    
    [self addSubview:self.firstSegementationView];  //第一条分割线
    
    [self addSubview:self.secondSegementationView]; //第二条分割线
    
    [self addSubview:self.intervalView];
}

/// 给控件们添加约束
- (void)addViewsConstraint{
    //标题
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.equalTo(self);
        make.height.mas_equalTo(MAIN_SCREEN_H * 0.0749);
    }];
    
    //第一条分割线
    [self.firstSegementationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleLbl.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    //保存按钮
    [self.savebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.titleLbl.centerX);
        make.top.equalTo(self.firstSegementationView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(2 * MAIN_SCREEN_W * 0.1333, MAIN_SCREEN_H * 0.0749));
    }];
    
    //第二条分割线
    [self.secondSegementationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.savebtn.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    //不保存按钮
    [self.noteSaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.titleLbl.centerX);
        make.top.equalTo(self.secondSegementationView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(2 * MAIN_SCREEN_W * 0.1333, MAIN_SCREEN_H * 0.0749));
    }];
    
    //取消按钮
    if (MAIN_SCREEN_H > 667) {
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.centerX.mas_equalTo(self.titleLbl.centerX);
            make.size.mas_equalTo(CGSizeMake(2 * MAIN_SCREEN_W * 0.1333, MAIN_SCREEN_H * 0.0749));
        }];
    }else{
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.centerX.mas_equalTo(self.titleLbl.centerX);
            make.size.mas_equalTo(CGSizeMake(2 * MAIN_SCREEN_W * 0.1333, MAIN_SCREEN_H * 0.07));
        }];
    }
    
    
    //取消和不保存之间的视图
    [self.intervalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.noteSaveBtn.mas_bottom);
        make.bottom.equalTo(self.cancelBtn.mas_top);
    }];
    
}

#pragma mark- getter
- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.text = @"是否保存草稿";
        _titleLbl.font = [UIFont fontWithName:PingFangSCMedium size:13];
        _titleLbl.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        
    }
    return _titleLbl;
}

- (UIButton *)savebtn{
    if (!_savebtn) {
        _savebtn = [[CYRleaseSaveDraftAlertBtn alloc] initWithFrame:CGRectZero];
        _savebtn.textLbl.text = @"保存";
        _savebtn.textLbl.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#153573" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        [_savebtn addTarget:self.delegate action:@selector(saveDrafts) forControlEvents:UIControlEventTouchUpInside];
    }
    return _savebtn;
}

- (UIButton *)noteSaveBtn{
    if (!_noteSaveBtn) {
        _noteSaveBtn = [[CYRleaseSaveDraftAlertBtn alloc] initWithFrame:CGRectZero];
        _noteSaveBtn.textLbl.text = @"不保存";
        _noteSaveBtn.textLbl.textColor = [UIColor colorWithRed:204/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        [_noteSaveBtn addTarget:self.delegate action:@selector(notSaveDrafts) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noteSaveBtn;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[CYRleaseSaveDraftAlertBtn alloc] initWithFrame:CGRectZero];
        _cancelBtn.textLbl.text = @"取消";
        _cancelBtn.textLbl.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#94A6C4" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]];
        [_cancelBtn addTarget:self.delegate action:@selector(dismisAlertViews) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIView *)firstSegementationView{
    if (!_firstSegementationView) {
        _firstSegementationView = [[UIView alloc] initWithFrame:CGRectZero];
        _firstSegementationView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E2E8EE" alpha:1] darkColor:[UIColor colorWithHexString:@"#343434" alpha:1]];
    }
    return _firstSegementationView;
}

- (UIView *)secondSegementationView{
    if (!_secondSegementationView) {
        _secondSegementationView = [[UIView alloc] initWithFrame:CGRectZero];
        _secondSegementationView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E2E8EE" alpha:1] darkColor:[UIColor colorWithHexString:@"#343434" alpha:1]];
    }
    return _secondSegementationView;
}

- (UIView *)intervalView{
    if (!_intervalView) {
        _intervalView = [[UIView alloc] initWithFrame:CGRectZero];
        _intervalView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E3E8ED" alpha:1] darkColor:[UIColor colorWithHexString:@"#343434" alpha:1]];
    }
    return _intervalView;
}
@end
