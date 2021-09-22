//
//  ToDoDetaileViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/8/24.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "ToDoDetaileViewController.h"
#import "ToDoDetailBar.h"
#import "RemindTimeView.h"
#import "DiscoverTodoSelectRepeatView.h"
#import "TodoSyncTool.h"
#import "ToDoDetailTitleView.h"
#import "ToDoDetailReminderTimeView.h"
#import "ToDoDetailRepeatView.h"
#import "ToDoDetailRemarkView.h"
@interface ToDoDetaileViewController ()
<
    ToDoDetailBarDelegate,
//    UITextViewDelegate,
    RemindTimeViewDelegate,
    DiscoverTodoSelectRepeatViewDelegate,
    ToDoDetailTitleViewDelegate,
    ToDoDetailReminderTimeViewDelegate,
    ToDoDetailRepeatViewDelegate
                            >
/// 最底层的scrolView
@property (nonatomic, strong) UIScrollView *scrollView;

/// 最顶部的一个bar
@property (nonatomic, strong) ToDoDetailBar *topBar;

/// 放置todo标题的和状态按钮的view
@property (nonatomic, strong) ToDoDetailTitleView *titleView;

/// 提醒时间的View
@property (nonatomic, strong) ToDoDetailReminderTimeView *reminderTimeView;

@property (nonatomic, strong) ToDoDetailRepeatView *repeatView;

@property (nonatomic, strong) ToDoDetailRemarkView *remarkView;

/// 弹出弹窗之后的一层黑色的遮罩层
@property (nonatomic, strong) UIView *maskView;

/// 弹出设置提醒时间的View
@property (nonatomic, strong) RemindTimeView *selectReminedTimeView;

/// 点击重复的label之后弹出的选择重复的View
@property (nonatomic, strong) DiscoverTodoSelectRepeatView *selectRepeatView;

/// 临时存储的重复的View
@property (nonatomic, strong) DiscoverTodoSelectRepeatView *tempoarySelectRepeatView;

/// 删除按钮
@property (nonatomic, strong) UIButton *deleteBtn;

/// 保存用户选择的重复的天数的数组
@property (nonatomic, strong) NSMutableArray *repeatLblsAry;

/// 用于存储这个界面改变的model
@property (nonatomic, strong) TodoDataModel *temporaryModel;

/// 事项完成或未完成的初始状态
@property (nonatomic, assign) BOOL instialState;

/// 是否更改了提醒时间和重复时间、title、备注文本
@property (nonatomic, assign) BOOL isChange;

/// 是否更改了状态按钮
@property (nonatomic, assign) BOOL isChangeStatuBtn;

/// 标题是否无文本
@property (nonatomic, assign) BOOL isTitleNil;
@end

@implementation ToDoDetaileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.temporaryModel = [[TodoDataModel alloc] init];
    self.temporaryModel = self.model;
    self.instialState = self.temporaryModel.isDone;
    self.view.backgroundColor = [UIColor colorNamed:@"255_255_255&0_0_0"];
    self.repeatLblsAry = [NSMutableArray array];
    
    self.isChange = NO;
    self.isChangeStatuBtn = NO;
    self.isTitleNil = NO;
    
    [self buildFrame];
}

#pragma mark- event response
- (void)deleteToDO{
    //重新设置过期时间
[self.temporaryModel resetOverdueTime];
    //保存修改的时间
self.temporaryModel.lastModifyTime = [NSDate date].timeIntervalSince1970;

self.model = self.temporaryModel;
    
    //删除model
    [[TodoSyncTool share] deleteTodoWithTodoID:self.model.todoIDStr needRecord:YES];
    self.block();   //刷新上个界面
    [NewQAHud showHudWith:@"已成功删除数据" AddView:self.view];
    //延迟1.5秒后跳回到上个界面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark- provate methonds
/// 设置最开始加入进来的重复提醒
- (void)addRepeatLabel{
    switch (self.temporaryModel.repeatMode) {
        case TodoDataModelRepeatModeNO:
            break;
        case TodoDataModelRepeatModeDay:
        {
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
            lbl.text = @"每天";
            [self.repeatLblsAry addObject:lbl];
        }
            break;
        case TodoDataModelRepeatModeWeek:
            for (NSString *titleStr in self.temporaryModel.weekArr) {
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
                lbl.text = [NSString stringWithFormat:@"每%@",[self intWeekToStrWeek:titleStr.intValue]];
                [self.repeatLblsAry addObject:lbl];
            }
            break;
        case TodoDataModelRepeatModeMonth:
            for (NSString *titleStr in self.temporaryModel.dayArr) {
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
                lbl.text = [NSString stringWithFormat:@"每月%d日",titleStr.intValue];
                [self.repeatLblsAry addObject:lbl];
            }
            break;
        case TodoDataModelRepeatModeYear:
            for (NSDictionary *dic in self.temporaryModel.dateArr) {
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
                lbl.text = [NSString stringWithFormat:@"每年%@月%@日", dic[@"TodoDataModelKeyMonth"],dic[@"TodoDataModelKeyDay"]];
                [self.repeatLblsAry addObject:lbl];
            }
            break;
    }
    
    [self.repeatView relayoutLblsByArray:self.repeatLblsAry];
}
///将每周的数字转化为对应的字符串
- (NSString*)intWeekToStrWeek:(int)intWeek {
    NSArray* arr = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
    return arr[intWeek-1];
}
//比较是否过期
- (BOOL)compareIsOverdue{
    if ([self.model.timeStr isEqualToString:@""]) {
        return NO;
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年M月d日HH:mm"];
    long notifyTimeStamp = [formatter dateFromString:self.temporaryModel.timeStr].timeIntervalSince1970;
    long nowTimeStamp = [NSDate date].timeIntervalSince1970;
    if (nowTimeStamp > notifyTimeStamp) {
        return YES;
    }else{
        return NO;
    }
}
///为各控件添加遮罩
- (void)addMasKBtn{
    //如果是完成状态，则添加遮罩的btn
    if (self.model.isDone) {
        [self.reminderTimeView addSubview:self.reminderTimeView.maskBtn];
        [self.reminderTimeView.maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.reminderTimeView);
        }];
        
        [self.repeatView addSubview:self.repeatView.maskBtn];
        [self.repeatView.maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.repeatView);
        }];
        
        [self.remarkView addSubview:self.remarkView.maskBtn];
        [self.repeatView.maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.remarkView);
        }];
    }
}
///重新设置动态改变titleView和remarkView的高度
- (void)resetHeight{
    __weak typeof(self.titleView) weakTitleView = self.titleView;
    __weak typeof(self) weakSelf = self;
    self.titleView.changeTitleViewHeightBlock = ^(CGFloat height) {
        //更改保存按钮状态
        weakSelf.isChange = YES;
        if ([weakSelf.titleView.textView.text isEqualToString:@""]) {
            weakSelf.isTitleNil = YES;
        }else{
            weakSelf.isTitleNil = NO;
        }
        [weakSelf isUseSaveBtn];
        
        [UIView animateWithDuration:0.25 animations:^{
            [weakTitleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
            [weakSelf.view layoutIfNeeded];
            weakSelf.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, weakSelf.remarkView.maxY + SCREEN_HEIGHT * 0.2);
        }];
    };
    
    self.remarkView.changeTitleViewHeightBlock = ^(CGFloat height) {
        //更改保存按钮状态
        weakSelf.isChange = YES;
        [weakSelf isUseSaveBtn];
        
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.remarkView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
            [weakSelf.view layoutIfNeeded];
            weakSelf.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, weakSelf.remarkView.maxY + SCREEN_HEIGHT * 0.2);
        }];
    };
}
/// 设置各个控件的fram
- (void)buildFrame{
    //顶部的bar
    [self.view addSubview:self.topBar];
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_top).offset(NVGBARHEIGHT + STATUSBARHEIGHT);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.0637));
    }];
    
    //底部可滑动的scroll
    [self.view addSubview:self.scrollView];
    
    //标题的View
    [self.scrollView addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.scrollView).offset(SCREEN_HEIGHT * 0.0449);
        make.size.mas_equalTo(self.titleView.titleViewSize);
    }];

    
    //提醒时间的view
    [self.scrollView addSubview:self.reminderTimeView];
    [self.reminderTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(SCREEN_WIDTH * 0.1333);
        make.top.equalTo(self.titleView.mas_bottom).offset(SCREEN_HEIGHT * 0.0539);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8267, SCREEN_HEIGHT * 0.07512));
    }];
    
    //重复的View
    [self.scrollView addSubview:self.repeatView];
    [self.repeatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reminderTimeView);
        make.top.equalTo(self.reminderTimeView.mas_bottom).offset(SCREEN_HEIGHT * 0.0419);
        make.size.mas_equalTo(self.reminderTimeView);
    }];
   

    //写备注的View
    [self.scrollView addSubview:self.remarkView];
    [self.remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.repeatView);
        make.top.equalTo(self.repeatView.mas_bottom).offset(SCREEN_HEIGHT * 0.0369);
        make.size.mas_equalTo(self.remarkView.remarkViewSize);
    }];
   
    [self.view addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(SCREEN_HEIGHT * -0.064); 
    }];
    
    
    //设置scrollView的contentSize
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.remarkView.maxY + SCREEN_HEIGHT * 0.25);
    
    [self addRepeatLabel];
    
    [self addMasKBtn];
    
    [self resetHeight];
    
    
}
///判断是否可用保存按钮
- (void)isUseSaveBtn{
    if ((self.isChangeStatuBtn || self.isChange) && !self.isTitleNil) {
        self.topBar.saveLbl.textColor = [UIColor colorNamed:@"41_35_210&44_222_255"];
        self.topBar.saveLbl.alpha = 1;
        self.topBar.saveBtn.userInteractionEnabled = YES;
    }else{
        self.topBar.saveLbl.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        self.topBar.saveLbl.alpha = 0.6;
        self.topBar.saveBtn.userInteractionEnabled = NO;
    }
}

#pragma mark- delegate
//MARK:ToDoDetailBarDelegate
- (void)popVC{
    [self.model setIsDoneForUserActivity:self.instialState];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveChanges{
    //保存信息
    self.temporaryModel.titleStr = self.titleView.textView.text;
    self.temporaryModel.detailStr = self.remarkView.textView.text;
    if ([self.reminderTimeView.reminderTimeLbl.text isEqualToString:@"设置提醒时间"]) {
        self.temporaryModel.timeStr = @"";
    }else{
        self.temporaryModel.timeStr = self.reminderTimeView.reminderTimeLbl.text;
    }
        //保存重复提醒
    self.temporaryModel.repeatMode = self.tempoarySelectRepeatView.repeatMode;
    switch (self.tempoarySelectRepeatView.repeatMode) {
        case TodoDataModelRepeatModeWeek:
            self.temporaryModel.weekArr = self.tempoarySelectRepeatView.dateArr;
            break;
        case TodoDataModelRepeatModeMonth:
            self.temporaryModel.dayArr = self.tempoarySelectRepeatView.dateArr;
            break;
        case TodoDataModelRepeatModeYear:
            self.temporaryModel.dateArr = self.tempoarySelectRepeatView.dateArr;
            break;
        default:
            break;
    }
        //重新设置过期时间
    [self.temporaryModel resetOverdueTime];
        //保存修改的时间
    self.temporaryModel.lastModifyTime = [NSDate date].timeIntervalSince1970;
    
    self.model = self.temporaryModel;

    //保存数据进数据库
    [[TodoSyncTool share] alterTodoWithModel:self.model needRecord:YES];
    
    //回调，使上个界面刷新
    self.block();

    [NewQAHud showHudWith:@"已成功修改数据" AddView:self.view];
    //延迟1.5秒后跳回到上个界面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

//MARK:ToDoDetailTitleViewDelegate
/// 点击小圆环按钮，切换完成状态
- (void)changeStatu{
    //更改保存按钮状态
    self.isChangeStatuBtn = !self.isChangeStatuBtn;
    [self isUseSaveBtn];
    //改变当前的状态
    [self.temporaryModel setIsDoneForUserActivity:!self.temporaryModel.isDone];
    //根据状态设置UI变化
    if (self.temporaryModel.isDone) {
        //titleView变化
        [self.titleView.cycleBtn setBackgroundImage:[UIImage imageNamed:@"打勾"] forState:UIControlStateNormal];
        self.titleView.textView.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        self.titleView.textView.alpha = 0.46;
        self.titleView.textView.editable = NO;
        self.reminderTimeView.reminderTimeLbl.alpha = 0.46;
        self.remarkView.textView.alpha = 0.46;
        self.remarkView.textView.editable = NO;
        
        //各view添加更改无效的遮罩按钮
            //titleView
        [self.titleView addSubview:self.titleView.clearBtn];
        [self.titleView.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.titleView.textView);
        }];
        
            //reminderView添加遮罩btn
        [self.reminderTimeView addSubview:self.reminderTimeView.maskBtn];
        [self.reminderTimeView.maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.reminderTimeView);
        }];
        
            //RepeatView添加遮罩层
        [self.repeatView addSubview:self.repeatView.maskBtn];
        [self.repeatView.maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.repeatView);
        }];
        
            //
        [self.remarkView addSubview:self.remarkView.maskBtn];
        [self.remarkView.maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.remarkView);
        }];
        
        
    }else{
        self.titleView.textView.alpha = 1;
        self.titleView.textView.editable = YES;
        self.remarkView.textView.editable = YES;
        self.remarkView.textView.alpha = 1;
        self.reminderTimeView.reminderTimeLbl.alpha = 1;
        
        //移除遮罩btn
        [self.titleView.clearBtn removeFromSuperview];
        [self.reminderTimeView.maskBtn  removeFromSuperview];
        [self.repeatView.maskBtn removeFromSuperview];
        [self.remarkView.maskBtn removeFromSuperview];
        
        
        if ([self compareIsOverdue]) {
            
            [self.titleView.cycleBtn setBackgroundImage:[UIImage imageNamed:@"ToDo过期圆圈"] forState:UIControlStateNormal];
            self.titleView.textView.textColor = [UIColor redColor];
            
        }else{
            [self.titleView.cycleBtn setBackgroundImage:[UIImage imageNamed:@"未打勾"] forState:UIControlStateNormal];
            self.titleView.textView.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        }
    }
}
///已完成状态下点击弹出无法更改的提示
- (void)changeInvaliePrompt{
    [NewQAHud showHudWith:@"掌友，无法对已完成事项进行修改哦！\nTip：点击待办勾选框即可改变状态嚎！" AddView:self.scrollView];
}

//MARK:ToDoDetailReminderTimeViewDelegate
/// 点击设置提醒时间
- (void)setReminderTime{
    
    //添加遮罩层
    self.maskView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.selectReminedTimeView.height + 16);
    [self.view addSubview:self.maskView];
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTimeViewCancelBtnClicked)]];
    
    [self.view addSubview:self.selectReminedTimeView];
    [UIView animateWithDuration:0.5 animations:^{
        self.selectReminedTimeView.alpha = 1;
        self.maskView.alpha = 1;
    }];
    
}

//MARK:RemindTimeViewDelegate
- (void)selectTimeViewSureBtnClicked:(NSDateComponents *)components{
    //更改保存按钮状态
    self.isChange = YES;
    [self isUseSaveBtn];
    
    //存储数据进model，注意这里要和model的格式相同
    self.reminderTimeView.reminderTimeLbl.text = [NSString stringWithFormat:@"%ld年%ld月%ld日%02ld:%02ld",components.year, components.month, components.day, components.hour, components.minute];
    
    //设置消失
    [UIView animateWithDuration:0.5 animations:^{
        self.selectReminedTimeView.alpha = 0;
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.selectReminedTimeView removeFromSuperview];
        [self.maskView removeFromSuperview];
        
        //刷新
        self.titleView = nil;
        [self.view removeAllSubviews];
        [self buildFrame];
    }];
}
- (void)selectTimeViewCancelBtnClicked{
    //设置消失
    [UIView animateWithDuration:0.5 animations:^{
        self.selectReminedTimeView.alpha = 0;
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.selectReminedTimeView removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
}

//MARK:ToDoDetailRepeatViewDelegate
///设置重复的模式
- (void)chooseRepeatStytle{
    //添加遮罩层
    self.maskView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.selectRepeatView.height);
    [self.view addSubview:self.maskView];
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectRepeatViewCancelBtnClicked)]];
    
    [self.view addSubview:self.selectRepeatView];
    [self.selectRepeatView showView];
    [UIView animateWithDuration:0.5 animations:^{
        self.maskView.alpha = 1;
        self.selectRepeatView.alpha = 1;
    }];
}

//MARK:DiscoverTodoSelectRepeatViewDelegaet
- (void)selectRepeatViewCancelBtnClicked{
    NSLog(@"取消选择重复");
    [UIView animateWithDuration:0.5 animations:^{
        self.maskView.alpha = 0;
        self.selectRepeatView.alpha = 0;
        }completion:^(BOOL finished) {
            [self.maskView removeFromSuperview];
            [self.selectRepeatView removeFromSuperview];
        }];
    
}
- (void)selectRepeatViewSureBtnClicked:(DiscoverTodoSelectRepeatView *)view{
    //更改保存按钮状态
    self.isChange = YES;
    [self isUseSaveBtn];
    
    self.tempoarySelectRepeatView = view;

    //进行界面显示
        //先清空之前有展示的
    long int cnt = self.repeatLblsAry.count;
    for (long int i = 0; i < cnt ; i++) {
        UILabel *lbl = self.repeatLblsAry[i];
        [lbl removeFromSuperview];
    }
    NSMutableArray *muteArray = [NSMutableArray array];
    for (UIButton *btn in view.btnArr) {
        NSString *titleStr = btn.titleLabel.text;
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        switch (view.repeatMode) {
            case TodoDataModelRepeatModeWeek:
                lbl.text = [NSString stringWithFormat:@"每%@",titleStr];
                break;
            default:
                lbl.text = [NSString stringWithFormat:@"%@",titleStr];
                break;
        }
       
        [muteArray addObject:lbl];
    }
    self.repeatLblsAry = muteArray;
    [self.repeatView relayoutLblsByArray:self.repeatLblsAry];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.selectRepeatView.alpha = 0;
        self.maskView.alpha = 0;
        }completion:^(BOOL finished) {
            [self.maskView removeFromSuperview];
            [self.selectRepeatView removeFromSuperview];
        }];
    
}


#pragma mark- getter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NVGBARHEIGHT+STATUSBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NVGBARHEIGHT+STATUSBARHEIGHT)];
        _scrollView.backgroundColor =  [UIColor colorNamed:@"255_255_255&0_0_0"];
        //设置scroll距离屏幕顶端无间距
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _scrollView.scrollEnabled = YES;
    }
    return _scrollView;
}

- (ToDoDetailBar *)topBar{
    if (!_topBar) {
        _topBar = [[ToDoDetailBar alloc] initWithFrame:CGRectZero];
        _topBar.delegate = self;
    }
    return _topBar;
}

- (ToDoDetailTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[ToDoDetailTitleView alloc] initWithFrame:CGRectZero];
        _titleView.backgroundColor = self.view.backgroundColor;
        _titleView.delegate = self;
        _titleView.model = self.model;
    }
    return _titleView;
}

- (ToDoDetailReminderTimeView *)reminderTimeView{
    if (!_reminderTimeView) {
        _reminderTimeView = [[ToDoDetailReminderTimeView alloc] initWithFrame:CGRectZero];
        _reminderTimeView.delegate = self;
        
        //进行文本设置
        if ([self.model.timeStr isEqualToString:@""]) {
            _reminderTimeView.reminderTimeLbl.text = @"设置提醒时间";
        }else{
            _reminderTimeView.reminderTimeLbl.text = self.model.timeStr;
            _reminderTimeView.reminderTimeLbl.alpha = 1;
        }
        if (self.model.isDone) {
            _reminderTimeView.reminderTimeLbl.alpha = 0.4;
        }else{
            _reminderTimeView.reminderTimeLbl.alpha = 1;
        }
    }
    return _reminderTimeView;
}

- (ToDoDetailRepeatView *)repeatView{
    if (!_repeatView) {
        _repeatView = [[ToDoDetailRepeatView alloc] initWithFrame:CGRectZero];
        _repeatView.delegate = self;
        
    }
    return _repeatView;
}

- (ToDoDetailRemarkView *)remarkView{
    if (!_remarkView) {
        _remarkView = [[ToDoDetailRemarkView alloc] initWithFrame:CGRectZero];
        _remarkView.delegate = self;
        _remarkView.model = self.model;
    }
    return _remarkView;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.frame];
        _maskView.backgroundColor = [UIColor colorNamed:@"0_15_37_0.14&0_0_0_0.7"];
        _maskView.alpha = 0;
    }
    return _maskView;
}

- (RemindTimeView *)selectReminedTimeView{
    if (!_selectReminedTimeView) {
        _selectReminedTimeView = [[RemindTimeView alloc] init];
        _selectReminedTimeView.frame = CGRectMake(0, SCREEN_HEIGHT * 0.4705, SCREEN_WIDTH, SCREEN_HEIGHT * 0.5295);
        _selectReminedTimeView.alpha = 0;
        _selectReminedTimeView.delegate = self;
        
        _selectReminedTimeView.layer.cornerRadius = 16;
    }
    return _selectReminedTimeView;
}

- (DiscoverTodoSelectRepeatView *)selectRepeatView{
    if (!_selectRepeatView) {
        _selectRepeatView = [[DiscoverTodoSelectRepeatView alloc] init];
        _selectRepeatView.frame = CGRectMake(0, SCREEN_HEIGHT * 0.4705, SCREEN_WIDTH, SCREEN_HEIGHT * 0.5295);
        _selectRepeatView.delegate = self;
    }
    return _selectRepeatView;
}

- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"删除按钮背景图片"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteToDO) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
@end
