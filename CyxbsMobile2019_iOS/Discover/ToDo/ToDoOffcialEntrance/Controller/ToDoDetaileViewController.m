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
@interface ToDoDetaileViewController ()
<
    ToDoDetailBarDelegate,
    UITextViewDelegate,
    RemindTimeViewDelegate,
    DiscoverTodoSelectRepeatViewDelegate
                            >
/// 最底层的scrolView
@property (nonatomic, strong) UIScrollView *scrollView;

/// 最顶部的一个bar
@property (nonatomic, strong) ToDoDetailBar *topBar;

/// 最前端的button
@property (nonatomic, strong) UIButton *cycleBtn;

/// 编辑title的TextView，大小随内容自适应增高
@property (nonatomic, strong) UITextView *titleTextView;

/// 提醒时间的label
@property (nonatomic, strong) UILabel *reminedTimeLbl;

/// 添加了点击手势的一个设置提醒时间的label
@property (nonatomic, strong) UILabel *reminedBtnLbl;

/// 显示“重复”的lbl，添加了点击手势，点击后选择重复时间周期
@property (nonatomic, strong) UILabel *repeatTitleLbl;

/// 展示重复内容的一个scrollView
@property (nonatomic, strong) UIScrollView *repeatContentScrollView;

/// 设置重复提醒时间的label
@property (nonatomic, strong) UILabel *reminedRepatTimeTitleLbl;

/// 备注的的label
@property (nonatomic, strong) UILabel *remarksTitleLbl;

/// 编辑备注的textView
@property (nonatomic, strong) UITextView *remarksTextView;

/// 编辑备注的提示文字
@property (nonatomic, strong) UILabel *reminedEditRemarksLbl;

/// 弹出弹窗之后的一层黑色的遮罩层
@property (nonatomic, strong) UIView *maskView;

/// 弹出设置提醒时间的View
@property (nonatomic, strong) RemindTimeView *selectReminedTimeView;

/// 点击重复的label之后弹出的选择重复的View
@property (nonatomic, strong) DiscoverTodoSelectRepeatView *selectRepeatView;

/// 保存用户选择的重复的天数的数组
@property (nonatomic, strong) NSMutableArray *repeatLblsAry;

@end

@implementation ToDoDetaileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorNamed:@"255_255_255&0_0_0"];
    self.repeatLblsAry = [NSMutableArray array];
    //监听model的isDone属性，动态的更改页面的控件的状态
    [self buildFrame];
    [self addRepeatLabel];
    [self reLayoutAllLbl];
}
#pragma mark- provate methonds
/// 设置最开始加入进来的重复提醒
- (void)addRepeatLabel{
    switch (self.model.repeatMode) {
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
            for (NSString *titleStr in self.model.weekArr) {
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
                lbl.text = [NSString stringWithFormat:@"每%@",[self intWeekToStrWeek:titleStr.intValue]];
                [self.repeatLblsAry addObject:lbl];
            }
            break;
        case TodoDataModelRepeatModeMonth:
            for (NSString *titleStr in self.model.dayArr) {
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
                lbl.text = [NSString stringWithFormat:@"每月%d日",titleStr.intValue];
                [self.repeatLblsAry addObject:lbl];
            }
            break;
        case TodoDataModelRepeatModeYear:
            for (NSDictionary *dic in self.model.dateArr) {
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
                lbl.text = [NSString stringWithFormat:@"每年%@月%@日", dic[@"TodoDataModelKeyMonth"],dic[@"TodoDataModelKeyDay"]];
                [self.repeatLblsAry addObject:lbl];
            }
            break;
    }
    
}
- (void)reLayoutAllLbl {
    if (self.repeatLblsAry.count == 0) {
        self.reminedRepatTimeTitleLbl.alpha = 0.4;
        return;
    }
    self.reminedRepatTimeTitleLbl.alpha = 0;
    
    for (UILabel *lbl in self.repeatLblsAry) {
        [self.repeatContentScrollView addSubview:lbl];
    }
    
    MASViewAttribute* last = self.repeatContentScrollView.mas_left;
    for (int i = 0; i < self.repeatLblsAry.count; i++) {
        UILabel *lbl = self.repeatLblsAry[i];
        [lbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.04433497537 * SCREEN_HEIGHT);
            make.top.bottom.equalTo(self.repeatLblsAry);
            make.left.equalTo(last).offset(i == 0 ? 0 : 0.03733333333*SCREEN_WIDTH);
        }];
        last = lbl.mas_right;
    }
    
    [[self.repeatLblsAry lastObject] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.repeatContentScrollView).offset(-0.03733333333*SCREEN_WIDTH);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat x = self.repeatContentScrollView.contentSize.width-SCREEN_WIDTH;
        if (x>60) {
            [UIView animateWithDuration:0.6 animations:^{
                self.repeatContentScrollView.contentOffset = CGPointMake(x+4, 0);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4 animations:^{
                    self.repeatContentScrollView.contentOffset = CGPointMake(x, 0);
                }];
            }];
        }
    });
}
///将每周的数字转化为对应的字符串
- (NSString*)intWeekToStrWeek:(int)intWeek {
    NSArray* arr = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
    return arr[intWeek-1];
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
    
    //圆环button
    [self.scrollView addSubview:self.cycleBtn];
    [self.cycleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(SCREEN_WIDTH * 0.04);;
        make.top.equalTo(self.scrollView).offset(SCREEN_HEIGHT * 0.0449);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.0613, SCREEN_WIDTH * 0.0613));
    }];
    
    //编辑文本
        //得到传入进来的title高度
    CGFloat titleHeight = ceil([self.model.titleStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH * 0.8267, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :[UIFont fontWithName:PingFangSCBold size:22]} context:nil].size.height);
    [self.view layoutIfNeeded]; //得到圆环button的frame
    [self.scrollView addSubview:self.titleTextView];
        //设置frame
    self.titleTextView.frame = CGRectMake(self.cycleBtn.maxX + SCREEN_WIDTH * 0.04, self.cycleBtn.y, SCREEN_WIDTH * 0.8266, titleHeight);
        //调整位置
    self.titleTextView.center = CGPointMake(self.titleTextView.centerX, self.cycleBtn.centerY);
    
    //提醒时间的label
    [self.scrollView addSubview:self.reminedTimeLbl];
    [self.reminedTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleTextView.mas_bottom).offset(SCREEN_HEIGHT * 0.0539);
        make.left.equalTo(self.titleTextView);
    }];
    
    //提醒时间的btn
    [self.scrollView addSubview:self.reminedBtnLbl];
    [self.reminedBtnLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reminedTimeLbl);
        make.top.equalTo(self.reminedTimeLbl.mas_bottom).offset(SCREEN_HEIGHT * 0.0149);
        make.size.mas_equalTo(CGSizeMake(self.titleTextView.width, SCREEN_WIDTH * 0.056));
    }];
    
    //分割线
    UIView *reminedTimeSpliteLineView = [[UIView alloc] initWithFrame:CGRectZero];
    reminedTimeSpliteLineView.backgroundColor = [UIColor colorNamed:@"189_204_229_0.2&248_249_252_0.1"];
    [self.scrollView addSubview:reminedTimeSpliteLineView];
    [reminedTimeSpliteLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reminedBtnLbl);
        make.top.equalTo(self.reminedBtnLbl.mas_bottom).offset(4);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8666, 1));
    }];
    
    //重复的laebl
    [self.scrollView addSubview:self.repeatTitleLbl];
    [self.repeatTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleTextView);
        make.top.equalTo(reminedTimeSpliteLineView.mas_bottom).offset(SCREEN_HEIGHT * 0.0419);
    }];
    
    //展示重复内容label的一个ScrollView
    [self.scrollView addSubview:self.repeatContentScrollView];
    [self.repeatContentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.repeatTitleLbl);
        make.top.equalTo(self.repeatTitleLbl.mas_bottom).offset(SCREEN_HEIGHT * 0.0123);
        make.size.mas_equalTo(CGSizeMake(self.titleTextView.width, 0.04433497537 * SCREEN_HEIGHT));
    }];
    
    //展示设置重复日期的一个标题
    [self.scrollView addSubview:self.reminedRepatTimeTitleLbl];
    [self.reminedRepatTimeTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.repeatContentScrollView);
        make.width.equalTo(self.repeatContentScrollView);
    }];
    if (self.repeatLblsAry.count != 0) {
        self.reminedRepatTimeTitleLbl.alpha = 0;
    }
    
    // 备注的标题label
    [self.scrollView addSubview:self.remarksTitleLbl];
    [self.remarksTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.repeatContentScrollView);
        make.top.equalTo(self.repeatContentScrollView.mas_bottom).offset(SCREEN_HEIGHT * 0.0369);
    }];
    
    //备注的文本编辑view
    [self.view layoutIfNeeded];
    CGFloat remarksTitleHeight = ceil([self.model.detailStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH * 0.8267, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :[UIFont fontWithName:PingFangSCBold size:15]} context:nil].size.height);
    if ([self.model.detailStr isEqualToString:@""]) {
        remarksTitleHeight = SCREEN_HEIGHT * 0.0258;
        self.reminedEditRemarksLbl.alpha = 0.4;
    }
    self.remarksTextView.frame = CGRectMake(self.remarksTitleLbl.x, self.remarksTitleLbl.maxY + SCREEN_HEIGHT * 0.0258, SCREEN_WIDTH * 0.8266, remarksTitleHeight);
    [self.scrollView addSubview:self.remarksTextView];
    
    [self.remarksTextView addSubview:self.reminedEditRemarksLbl];
    [self.reminedEditRemarksLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.remarksTextView);
    }];
    
    //设置scrollView的contentSize
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.remarksTextView.maxY + SCREEN_HEIGHT * 0.25);
}

#pragma mark- event response
/// 点击小圆环按钮，切换完成状态
- (void)changeStatu{
    //改变当前的状态
    self.model.isDone = !self.model.isDone;
    if (self.model.isDone == YES) {
        //btn图片改变
        [self.cycleBtn setBackgroundImage:[UIImage imageNamed:@"打勾"] forState:UIControlStateNormal];
        //textView变化
        self.titleTextView.alpha = 0.46;
        self.titleTextView.userInteractionEnabled = NO;
        self.remarksTextView.userInteractionEnabled = NO;
    }else{
        //btn图片变化
        [self.cycleBtn setBackgroundImage:[UIImage imageNamed:@"未打勾"] forState:UIControlStateNormal];
        //textView变化
        self.titleTextView.alpha = 1;
        self.titleTextView.userInteractionEnabled = NO;
        self.remarksTextView.userInteractionEnabled = YES;
    }
}
/// 点击设置重复提醒时间
- (void)setReminedTime{
    if (self.model.isDone) {
        [NewQAHud showHudWith:@"掌友，无法对已完成事项进行修改哦！\nTip：点击待办勾选框即可改变状态嚎！" AddView:self.scrollView];
    }else{
        NSLog(@"点击设置提醒时间");
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
}
///设置重复的模式
- (void)chooseRepeatStytle{
    if (self.model.isDone) {
        [NewQAHud showHudWith:@"掌友，无法对已完成事项进行修改哦！\nTip：点击待办勾选框即可改变状态嚎！" AddView:self.scrollView];
    }else{
        //添加遮罩层
        self.maskView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.selectRepeatView.height);
        [self.view addSubview:self.maskView];
        [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectRepeatViewCancelBtnClicked)]];
        
        [self.view addSubview:self.selectRepeatView];
        [self.selectRepeatView show];
        [UIView animateWithDuration:0.5 animations:^{
            self.maskView.alpha = 1;
            self.selectRepeatView.alpha = 1;
        }];
    }
}

#pragma mark- delegate
//MARK:KVO回调

//MARK:ToDoDetailBarDelegate
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveChanges{
    self.model.titleStr = self.titleTextView.text;
    self.model.detailStr = self.remarksTextView.text;
    self.model.timeStr = self.reminedBtnLbl.text;
    
    //保存数据，并回调block使上一界面刷新
    [[TodoSyncTool share] alterTodoWithModel:self.model needRecord:YES];
    self.block();
    [NewQAHud showHudWith:@"已成功修改数据" AddView:self.view];
    NSLog(@"已经保存");
}

//MARK:RemindTimeViewDelegate
- (void)selectTimeViewSureBtnClicked:(NSDateComponents *)components{
    self.reminedBtnLbl.text = [NSString stringWithFormat:@"%ld月%ld日%02ld:%02ld", components.month, components.day, components.hour, components.minute];
    self.model.timeStr = self.reminedBtnLbl.text;
    //设置消失
    [UIView animateWithDuration:0.5 animations:^{
        self.selectReminedTimeView.alpha = 0;
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.selectReminedTimeView removeFromSuperview];
        [self.maskView removeFromSuperview];
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
    //将数据存储在model里面
    self.model.repeatMode = view.repeatMode;
    switch (view.repeatMode) {
        case TodoDataModelRepeatModeWeek:
            self.model.weekArr = view.dateArr;
            break;
        case TodoDataModelRepeatModeMonth:
            self.model.dayArr = view.dateArr;
            break;
        case TodoDataModelRepeatModeYear:
            self.model.dateArr = view.dateArr;
            break;
        default:
            break;
    }
    
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
        lbl.text = [NSString stringWithFormat:@"每%@",titleStr];
        [muteArray addObject:lbl];
    }
    self.repeatLblsAry = muteArray;
    [self reLayoutAllLbl];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.selectRepeatView.alpha = 0;
        self.maskView.alpha = 0;
        }completion:^(BOOL finished) {
            [self.maskView removeFromSuperview];
            [self.selectRepeatView removeFromSuperview];
        }];
    
}

//MARK:UITextViewDeleaget
- (void)textViewDidChange:(UITextView *)textView{
    CGRect frame = textView.frame;
    CGSize constrainSize = CGSizeMake(frame.size.width, CGFLOAT_MAX);
    CGSize size = [textView sizeThatFits:constrainSize];
    [UIView animateWithDuration:0.25 animations:^{
        textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    }];
    if (textView.tag == 1) {
        if (textView.text.length > 0) {
            self.reminedEditRemarksLbl.alpha = 0;
        }else{
            self.reminedEditRemarksLbl.alpha = 0.4;
        }
    }
}

#pragma mark- getter
- (ToDoDetailBar *)topBar{
    if (!_topBar) {
        _topBar = [[ToDoDetailBar alloc] initWithFrame:CGRectZero];
        _topBar.delegate = self;
    }
    return _topBar;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NVGBARHEIGHT+STATUSBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NVGBARHEIGHT+STATUSBARHEIGHT)];
        _scrollView.backgroundColor =  [UIColor colorNamed:@"255_255_255&0_0_0"];
        //设置scroll距离屏幕顶端无间距
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT * 1.5);
    }
    return _scrollView;
}

- (UIButton *)cycleBtn{
    if (!_cycleBtn) {
        _cycleBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        if (self.model.isDone) {
            [_cycleBtn setBackgroundImage:[UIImage imageNamed:@"打勾"] forState:UIControlStateNormal];
        }else{
            [_cycleBtn setBackgroundImage:[UIImage imageNamed:@"未打勾"] forState:UIControlStateNormal];
        }
        [_cycleBtn addTarget:self action:@selector(changeStatu) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cycleBtn;
}

- (UITextView *)titleTextView{
    if (!_titleTextView) {
        _titleTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _titleTextView.textContainerInset = UIEdgeInsetsZero;
        _titleTextView.textContainer.lineFragmentPadding = 0;
        _titleTextView.font = [UIFont fontWithName:PingFangSCBold size:22];
        _titleTextView.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        _titleTextView.text = self.model.titleStr;
        _titleTextView.delegate = self;
        if (self.model.isDone) {
            _titleTextView.userInteractionEnabled = NO;
            _titleTextView.alpha = 0.46;
        }
    }
    return _titleTextView;
}

- (UILabel *)reminedTimeLbl{
    if (!_reminedTimeLbl) {
        _reminedTimeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _reminedTimeLbl.text = @"提醒时间";
        _reminedTimeLbl.font = [UIFont fontWithName:PingFangSCMedium size:15];
        _reminedTimeLbl.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
    }
    return _reminedTimeLbl;
}

- (UILabel *)reminedBtnLbl{
    if (!_reminedBtnLbl) {
        //进行属性设置
        _reminedBtnLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        if ([self.model.timeStr isEqualToString:@""]) {
            _reminedBtnLbl.text = @"设置重复提醒";
        }else{
            _reminedBtnLbl.text = self.model.timeStr;
        }
        _reminedBtnLbl.font = [UIFont fontWithName:PingFangSCMedium size:15];
        _reminedBtnLbl.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        _reminedBtnLbl.alpha = 0.4;
        _reminedBtnLbl.userInteractionEnabled = YES;
        
        //添加点击手势
        [_reminedBtnLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setReminedTime)]];
    }
    return _reminedBtnLbl;
}

- (UILabel *)repeatTitleLbl{
    if (!_repeatTitleLbl) {
        _repeatTitleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _repeatTitleLbl.text = @"重复";
        _repeatTitleLbl.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        _repeatTitleLbl.font = [UIFont fontWithName:PingFangSCMedium size:18];
        _repeatTitleLbl.userInteractionEnabled = YES;
        
        //添加点击手势
        [_repeatTitleLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseRepeatStytle)]];
    }
    return _repeatTitleLbl;
}

- (UIScrollView *)repeatContentScrollView{
    if (!_repeatContentScrollView) {
        _repeatContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _repeatContentScrollView.showsVerticalScrollIndicator = NO;
        _repeatContentScrollView.showsHorizontalScrollIndicator = NO;
        _repeatContentScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _repeatContentScrollView;
}

- (UILabel *)reminedRepatTimeTitleLbl{
    if (!_reminedRepatTimeTitleLbl) {
        _reminedRepatTimeTitleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _reminedRepatTimeTitleLbl.text = @"设置重复提醒";
        _reminedRepatTimeTitleLbl.font = [UIFont fontWithName:PingFangSCMedium size:15];
        _reminedRepatTimeTitleLbl.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        _reminedRepatTimeTitleLbl.alpha = 0.4;
        
        _reminedRepatTimeTitleLbl.userInteractionEnabled = YES;
        [_reminedRepatTimeTitleLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseRepeatStytle)]];
    }
    return _reminedRepatTimeTitleLbl;
}

- (UILabel *)remarksTitleLbl{
    if (!_remarksTitleLbl) {
        _remarksTitleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _remarksTitleLbl.text = @"备注";
        _remarksTitleLbl.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        _remarksTitleLbl.font = [UIFont fontWithName:PingFangSCMedium size:18];
    }
    return  _remarksTitleLbl;
}

- (UITextView *)remarksTextView{
    if (!_remarksTextView) {
        _remarksTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _remarksTextView.tag = 1;
        _remarksTextView.textContainerInset = UIEdgeInsetsZero;
        _remarksTextView.textContainer.lineFragmentPadding = 0;
        _remarksTextView.font = [UIFont fontWithName:PingFangSCBold size:15];
        _remarksTextView.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        _remarksTextView.text = self.model.detailStr;
        _remarksTextView.delegate = self;
        if (self.model.isDone) {
            _remarksTextView.userInteractionEnabled = NO;
            _remarksTextView.alpha = 0.46;
        }
    }
    return _remarksTextView;
}

- (UILabel *)reminedEditRemarksLbl{
    if (!_reminedEditRemarksLbl) {
        _reminedEditRemarksLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _reminedEditRemarksLbl.font = [UIFont fontWithName:PingFangSCMedium size:15];
        _reminedEditRemarksLbl.text = @"输入备注信息";
        _reminedEditRemarksLbl.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        _reminedEditRemarksLbl.alpha = 0;
    }
    return _reminedEditRemarksLbl;
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
//        _selectReminedTimeView.backgroundColor = [UIColor redColor];
        //添加点击取消手势
        
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_selectReminedTimeView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16, 16)];
//        CAShapeLayer *maskLayer = [CAShapeLayer layer];
//        maskLayer.frame = _selectReminedTimeView.frame;
//        maskLayer.path = maskPath.CGPath;
//        _selectReminedTimeView.layer.mask = maskLayer;
        
        //设置上面的圆角
//        CGRect rect = _selectReminedTimeView.frame;
//        UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(16, 16)];
//        CAShapeLayer* layer = [CAShapeLayer layer];
//        layer.path = path.CGPath;
//        layer.frame = _selectReminedTimeView.frame;
//        _selectReminedTimeView.layer.mask = layer;
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

@end
