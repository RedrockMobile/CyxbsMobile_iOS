//
//  DiscoverTodoSheetView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/6.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DiscoverTodoSheetView.h"
#import "TodoTitleInputTextField.h"
#import "DiscoverTodoSelectTimeView.h"
#import "DiscoverTodoSelectRepeatView.h"
@interface DiscoverTodoSheetView ()

/// 白色背景板
@property (nonatomic, strong)UIView* backView;

/// 取消按钮
@property (nonatomic, strong)UIButton* cancelBtn;

/// 保存按钮
@property (nonatomic, strong)UIButton* saveBtn;

/// 选择提醒时间的按钮
@property (nonatomic, strong)UIButton* remindTimeBtn;

/// 选择提醒模式的按钮
@property (nonatomic, strong)UIButton* repeatModelBtn;

/// 输入标题的按钮
@property (nonatomic, strong)UITextField* titleInputTextfield;
@end

@implementation DiscoverTodoSheetView

- (instancetype)init {
    self = [super init];
    if (self) {
        UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
        [self addGestureRecognizer:tgr];
        self.backgroundColor = [UIColor clearColor];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1.7389162562*SCREEN_HEIGHT));
        }];
        
        
        [self addBackView];
        [self addSaveBtn];
        [self addCancelBtn];
        [self addTitleInputTextfield];
        [self addRemindTimeBtn];
        [self addRepeatModelBtn];
    }
    return self;
}

- (void)addBackView {
    UIView* view = [[UIView alloc] init];
    self.backView = view;
    [self addSubview:view];
    
    UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc] init];
    [view addGestureRecognizer:tgr];
    
    view.backgroundColor = [UIColor whiteColor];
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 0.7389162562*SCREEN_HEIGHT);
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(16, 16)];
    CAShapeLayer* layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.frame = rect;
    view.layer.mask = layer;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.7389162562*SCREEN_HEIGHT);
    }];
}

- (void)addCancelBtn {
    UIButton *btn = [[UIButton alloc] init];
    self.cancelBtn = btn;
    [self.backView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(0.04*SCREEN_WIDTH);
        make.top.equalTo(self.backView).offset(0.02586206897*SCREEN_WIDTH);
    }];
    
    btn.titleLabel.font = [UIFont fontWithName:PingFangSCSemibold size:15];
    [btn setTitleColor:[UIColor colorNamed:@"color21_49_91&#F0F0F2"] forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)addSaveBtn {
    UIButton *btn = [[UIButton alloc] init];
    self.saveBtn = btn;
    [self.backView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView).offset(-0.04*SCREEN_WIDTH);
        make.top.equalTo(self.backView).offset(0.02586206897*SCREEN_WIDTH);
    }];
    
    btn.titleLabel.font = [UIFont fontWithName:PingFangSCSemibold size:15];
    [btn setTitleColor:[UIColor colorNamed:@"color21_49_91&#F0F0F2"] forState:UIControlStateNormal];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}
- (UIButton*)getStdBtn {
    UIButton* btn = [[UIButton alloc] init];
    [btn setTitleColor:[UIColor colorNamed:@"21_49_91_40&#F0F0F2_40"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorNamed:@"21_49_91_80&#F0F0F2_80"] forState:UIControlStateHighlighted];
    [btn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:15]];
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0.02666666667*SCREEN_WIDTH)];
    
    return btn;
}
- (void)addTitleInputTextfield {
    TodoTitleInputTextField* textField = [[TodoTitleInputTextField alloc] init];
    [self.backView addSubview:textField];
    self.titleInputTextfield = textField;
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(0.048*SCREEN_WIDTH);
        make.top.equalTo(self.backView).offset(0.09236453202*SCREEN_HEIGHT);
        make.width.mas_equalTo(0.904*SCREEN_WIDTH);
        make.height.mas_equalTo(0.1173333333*SCREEN_WIDTH);
    }];
}
//这边约束好像有warming
- (void)addRemindTimeBtn {
    UIButton* btn = [self getStdBtn];
    [self.backView addSubview:btn];
    self.remindTimeBtn = btn;
    
    [btn setTitle:@"设置提醒时间" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"todo提醒的小铃铛"] forState:UIControlStateNormal];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(0.048*SCREEN_WIDTH);
        make.top.equalTo(self.backView).offset(0.1761083744*SCREEN_HEIGHT);
    }];
    
    [btn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn);
        make.centerY.equalTo(btn.titleLabel);
        make.right.equalTo(btn.titleLabel.mas_left).offset(-0.032*SCREEN_WIDTH);
        make.width.mas_equalTo(0.05333333333*SCREEN_WIDTH);//20
        make.height.mas_equalTo(0.056*SCREEN_WIDTH);//21
    }];
    
    
    [btn addTarget:self action:@selector(remindTimeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}
//这边约束好像有warming
- (void)addRepeatModelBtn {
    UIButton* btn = [self getStdBtn];
    [self.backView addSubview:btn];
    self.remindTimeBtn = btn;
    
    [btn setTitle:@"设置重复提醒" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"todo的小闹钟"] forState:UIControlStateNormal];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(0.048*SCREEN_WIDTH);
        make.top.equalTo(self.backView).offset(0.2216748768*SCREEN_HEIGHT);
    }];
    
    [btn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn);
        make.centerY.equalTo(btn.titleLabel);
        make.right.equalTo(btn.titleLabel.mas_left).offset(-0.032*SCREEN_WIDTH);
        make.width.mas_equalTo(0.05333333333*SCREEN_WIDTH);
        make.height.mas_equalTo(0.05777777777*SCREEN_WIDTH);
    }];
    
    [btn addTarget:self action:@selector(repeatModelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)cancel {
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.backgroundColor = [UIColor clearColor];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [self.delegate sheetViewCancelBtnClicked];
}

- (void)saveBtnClicked {
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.backgroundColor = [UIColor clearColor];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [self.delegate sheetViewSaveBtnClicked];
}

- (void)show {
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformTranslate(self.transform, 0, -0.7389162562*SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    }];
}

- (void)remindTimeBtnClicked {
    DiscoverTodoSelectTimeView* view = [[DiscoverTodoSelectTimeView alloc] init];
    [self.backView addSubview:view];
    
    view.alpha = 0;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(0.4729064039*SCREEN_HEIGHT));
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 1;
    }];
}

- (void)repeatModelBtnClicked {
    DiscoverTodoSelectRepeatView* view = [[DiscoverTodoSelectRepeatView alloc] init];
    [self.backView addSubview:view];
    
    view.alpha = 0;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(0.4729064039*SCREEN_HEIGHT));
    }];
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 1;
    }];
}


@end

