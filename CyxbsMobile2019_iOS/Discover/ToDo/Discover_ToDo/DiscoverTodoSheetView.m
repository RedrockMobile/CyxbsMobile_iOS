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


@interface DiscoverTodoSheetView ()<
    DiscoverTodoSelectTimeViewDelegate,
    DiscoverTodoSelectRepeatViewDelegate,
    UITextFieldDelegate
>

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
@property (nonatomic, strong)TodoTitleInputTextField* titleInputTextfield;

@property (nonatomic, strong)DiscoverTodoSelectTimeView* selectTimeView;

@property (nonatomic, strong)DiscoverTodoSelectRepeatView* selectRepeatView;

@property (nonatomic, strong)UIButton* deleteBtn;

@property (nonatomic, strong)TodoDataModel* dataModel;

@end

@implementation DiscoverTodoSheetView

- (instancetype)init {
    self = [super init];
    if (self) {
        UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
        [self addGestureRecognizer:tgr];
        //最开始一定要设置一个clearColor的背景颜色，
        //否则外界调用show方法弹出self时，背景的颜色渐变动画就没了。
        self.backgroundColor = [UIColor clearColor];
        
        self.dataModel = [[TodoDataModel alloc] init];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1.7389162562*SCREEN_HEIGHT));
        }];
        
        
        [self addBackView];
        [self addSaveBtn];
        [self addCancelBtn];
        [self addTitleInputTextfield];
        [self addRemindTimeBtn];
        [self addDeleteBtn];
        [self addRepeatModelBtn];
    }
    return self;
}

//MARK: - 初始化UI的方法：
/// 承载大部分view的白色背景
- (void)addBackView {
    UIView* view = [[UIView alloc] init];
    self.backView = view;
    [self addSubview:view];
    
    UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc] init];
    [view addGestureRecognizer:tgr];
    
    view.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#2C2C2C" alpha:1]];
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
/// 添加取消按钮
- (void)addCancelBtn {
    UIButton *btn = [[UIButton alloc] init];
    self.cancelBtn = btn;
    [self.backView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(0.04*SCREEN_WIDTH);
        make.top.equalTo(self.backView).offset(0.02586206897*SCREEN_WIDTH);
    }];
    
    
    btn.titleLabel.font = [UIFont fontWithName:PingFangSCSemibold size:15];
    [btn setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]] forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
}
/// 添加保存按钮
- (void)addSaveBtn {
    UIButton *btn = [[UIButton alloc] init];
    self.saveBtn = btn;
    [self.backView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView).offset(-0.04*SCREEN_WIDTH);
        make.top.equalTo(self.backView).offset(0.02586206897*SCREEN_WIDTH);
    }];
    
    btn.titleLabel.font = [UIFont fontWithName:PingFangSCSemibold size:15];
    [btn setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]] forState:UIControlStateNormal];
    [btn setAlpha:0.4];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}
/// 这里面会完成选择提醒时间、重复时间的按钮的一些相同的设置
- (UIButton*)getStdBtn {
    UIButton* btn = [[UIButton alloc] init];
    [btn setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:0.4] darkColor:[UIColor colorWithHexString:@"#EFEFF1" alpha:0.4]] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:1] darkColor:[UIColor colorWithHexString:@"#EFEFF1" alpha:1]] forState:UIControlStateHighlighted];
    
    [btn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:15]];
    return btn;
}
- (void)addTitleInputTextfield {
    TodoTitleInputTextField* textField = [[TodoTitleInputTextField alloc] init];
    [self.backView addSubview:textField];
    self.titleInputTextfield = textField;
    
    textField.delegate = self;
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(0.048*SCREEN_WIDTH);
        make.top.equalTo(self.backView).offset(0.09236453202*SCREEN_HEIGHT);
        make.width.mas_equalTo(0.904*SCREEN_WIDTH);
        make.height.mas_equalTo(0.1173333333*SCREEN_WIDTH);
    }];
}
- (void)addDeleteBtn {
    UIButton* btn = [[UIButton alloc] init];
    [self addSubview:btn];
    self.deleteBtn = btn;
    
    [btn setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#7BA2E9" alpha:1] darkColor:[UIColor colorWithHexString:@"#838385" alpha:1]] forState:UIControlStateNormal];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:15]];
    btn.alpha = 0;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.remindTimeBtn);
        make.right.equalTo(self).offset(-0.04*SCREEN_WIDTH);
    }];
    
    [btn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}
- (void)deleteBtnClicked {
    [UIView animateWithDuration:0.5 animations:^{
        self.deleteBtn.alpha = 0;
    }];
    [self.remindTimeBtn setTitle:@"设置提醒时间" forState:UIControlStateNormal];
    self.dataModel.timeStr = @"";
}
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (textField.text!=nil&&![textField.text isEqualToString:@""]) {
        self.saveBtn.alpha = 1;
        [self.saveBtn setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2923D2" alpha:1] darkColor:[UIColor colorWithHexString:@"#2CDEFF" alpha:1]] forState:UIControlStateNormal];
    }else {
        self.saveBtn.alpha = 0.4;
        [self.saveBtn setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]] forState:UIControlStateNormal];
    }
}
//这边约束好像有warming
- (void)addRemindTimeBtn {
    UIButton* btn = [self getStdBtn];
    [self.backView addSubview:btn];
    self.remindTimeBtn = btn;
    
    [btn setTitle:@"设置提醒时间" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2A4E84" alpha:1] darkColor:[UIColor colorWithHexString:@"#DFDFE3" alpha:1]] forState:UIControlStateNormal];
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
    self.repeatModelBtn = btn;
    
    [btn setTitle:@"设置重复提醒" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2A4E84" alpha:1] darkColor:[UIColor colorWithHexString:@"#DFDFE3" alpha:1]] forState:UIControlStateNormal];
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

//MARK: - 点击按钮后调用的方法：
/// 取消按钮点击后调用
- (void)cancel {
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.backgroundColor = [UIColor clearColor];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];

    }];
   
    [self.delegate sheetViewCancelBtnClicked];
}

/// 保存按钮点击后调用
- (void)saveBtnClicked {
    if (self.titleInputTextfield.text==nil||[self.titleInputTextfield.text isEqualToString:@""]) {
        [NewQAHud showHudAtWindowWithStr:@" 还没有设置标题～ " enableInteract:YES];
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.backgroundColor = [UIColor clearColor];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    TodoDataModel* model = self.dataModel;
    model.todoIDStr = [NSString stringWithFormat:@"%ld", (long)[NSDate date].timeIntervalSince1970];
    model.titleStr = self.titleInputTextfield.text;
    [model resetOverdueTime];
    model.lastModifyTime = (long)[NSDate date].timeIntervalSince1970;
    [self.delegate sheetViewSaveBtnClicked:model];
}

/// 选择提醒时间的按钮点击后调用
- (void)remindTimeBtnClicked {
    [self endEditing:YES];
    [self.selectRepeatView hideView];
    [self.selectTimeView showView];
    [self.backView insertSubview:self.selectTimeView aboveSubview:self.selectRepeatView];
}

/// 选择重复提醒的按钮点击后调用
- (void)repeatModelBtnClicked {
    [self endEditing:YES];
    [self.selectTimeView hideView];
    [self.selectRepeatView showView];
    [self.backView insertSubview:self.selectRepeatView aboveSubview:self.selectTimeView];
}

- (DiscoverTodoSelectRepeatView *)selectRepeatView {
    if (_selectRepeatView==nil) {
        DiscoverTodoSelectRepeatView* view = [[DiscoverTodoSelectRepeatView alloc] init];
        [self.backView addSubview:view];
        _selectRepeatView = view;
        
        view.delegate = self;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@(0.4729064039*SCREEN_HEIGHT));
        }];
    }
    return _selectRepeatView;
}
- (DiscoverTodoSelectTimeView *)selectTimeView {
    if (_selectTimeView==nil) {
        _selectTimeView = [[DiscoverTodoSelectTimeView alloc] init];
        [self.backView addSubview:_selectTimeView];
        _selectTimeView.delegate = self;
        
        [_selectTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@(0.4729064039*SCREEN_HEIGHT));
        }];
    }
    return _selectTimeView;
}
- (void)selectTimeViewSureBtnClicked:(NSDateComponents *)components {
    [self.remindTimeBtn setTitle:[NSString stringWithFormat:@"%ld月%ld日%02ld:%02ld", components.month, components.day, components.hour, components.minute] forState:UIControlStateNormal];
    self.dataModel.timeStr = [NSString stringWithFormat:@"%ld年%ld月%ld日%02ld:%02ld",components.year, components.month, components.day, components.hour, components.minute];
    [UIView animateWithDuration:0.5 animations:^{
        self.deleteBtn.alpha = 1;
    }];
}
- (void)selectTimeViewCancelBtnClicked {

}

- (void)selectRepeatViewSureBtnClicked:(DiscoverTodoSelectRepeatView*)view {
    self.dataModel.repeatMode = view.repeatMode;
    switch (view.repeatMode) {
        case TodoDataModelRepeatModeWeek:
            self.dataModel.weekArr = view.dateArr;
            break;
        case TodoDataModelRepeatModeMonth:
            self.dataModel.dayArr = view.dateArr;
            break;
        case TodoDataModelRepeatModeYear:
            self.dataModel.dateArr = view.dateArr;
            break;
        default:
            break;
    }
}

- (void)selectRepeatViewCancelBtnClicked {
    
}



//MARK: - 其他
/// 外界调用，点击后以动画的形式弹出
- (void)show {
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformTranslate(self.transform, 0, -0.7389162562*SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    }];
}
@end

