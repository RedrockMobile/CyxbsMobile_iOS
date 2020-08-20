//
//  DLReminderSetTimeVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 丁磊 on 2020/4/10.
//  Copyright © 2020 Redrock. All rights reserved.
//最终编辑备忘时间的页面
/*
 逻辑错误：
 1.
 */

#import "DLReminderSetTimeVC.h"
#import "DLReminderView.h"
#import "DLReminderView+Reset.h"
#import "DLWeeklSelectView.h"
#import "DLTimeSelectView.h"
#import "DLReminderModel.h"
#import "DLTimeSelectedButton.h"
#import "DLHistodyButton.h"
#import "TimeSelectedBtnsView.h"

#define kRateX [UIScreen mainScreen].bounds.size.width/375   //以iPhoneX为基准
#define kRateY [UIScreen mainScreen].bounds.size.height/812  //以iPhoneX为基准
@interface DLReminderSetTimeVC ()<UITextFieldDelegate, WeekSelectDelegate,DLTimeSelectViewDelegate,TimeSelectedBtnsViewDeleget>
@property (nonatomic, strong) UIPickerView *timePiker;
@property (nonatomic, strong) DLReminderView *reminderView;

/// 周选择view，懒加载
@property (nonatomic, strong) DLWeeklSelectView *weekselectView;

/// 时间选择view，懒加载
@property (nonatomic, strong) DLTimeSelectView *timeSelectView;

@property (nonatomic, copy) NSArray *weekArray;


///存储已选择的周
@property (nonatomic, strong) NSArray *weekSelectedArray;

///存储已选择的时间 内容为string
@property (nonatomic, strong) NSMutableArray *timeSelectedArray;

/// 显示已经添加时间的按钮的背景view
@property (nonatomic,strong)TimeSelectedBtnsView *backViewOfTimeSelectedBtn;
@end

@implementation DLReminderSetTimeVC

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.weekSelectedArray = [@[] mutableCopy];
    [self.view addSubview: self.reminderView];
    self.timeDictArray = [NSMutableArray array];
    [self addWeekChooseBtn];
}

#pragma mark - 点击事件
//点击下方的大勾勾按钮
- (void)didClickNextButton:(UIButton *)button{
//    那个idnum不知道是啥，随便写了个
    NSDictionary *dic = @{@"idNum": @123,
                          @"title": self.noticeString,//为你的行程添加标题时选择的标题
                          @"content": self.detailString//为你的行程添加内容时输入的文字
    };
    
    NSLog(@"notice = %@,detail = %@",self.noticeString,self.detailString);
    
    //DLReminderModel只在这里使用过
    DLReminderModel *model = [[DLReminderModel alloc] initWithRemindDict:dic];
    model.week = self.weekSelectedArray;
    //不知道classNum是不是指学号，这里假设就是学号
    model.classNum = [NSNumber numberWithString:[UserDefaultTool getStuNum]];
    //不知道model配置是否正确
    model.week = self.weekArray;
    //不知道model配置是否正确
//    model.day = [self.pickerSlectedItems firstObject];
//    ADDREMINDAPI
    //网络请求参数不知道怎么配置
    NSDictionary *param = [@{
        @"stuNum":model.classNum,
        @"idNum":model.idNum,
//    @"date":jsonString,
//    @"time":model.time,
    @"title":model.title,
        @"content":model.content,
    } mutableCopy];
}

- (void)addWeekChooseBtn{
    UIButton *weekChooseBtn = [[UIButton alloc] init];
    [self.reminderView addSubview:weekChooseBtn];
    
    [weekChooseBtn setTitle:@"备忘周" forState:UIControlStateNormal];
//    [weekChooseBtn setBackgroundColor:[UIColor colorWithRGB:23 alpha:0.5]];
    [weekChooseBtn addTarget:self action:@selector(showWeekselectView) forControlEvents:UIControlEventTouchUpInside];
    
    [weekChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reminderView).offset(MAIN_SCREEN_W*0.0534);
        make.width.mas_equalTo(MAIN_SCREEN_W*0.2267);
        make.height.mas_equalTo(MAIN_SCREEN_W*0.104);
        make.top.equalTo(self.reminderView).offset(MAIN_SCREEN_H*0.3789);
    }];
    if (@available(iOS 11.0, *)) {
        [weekChooseBtn setTitleColor:[UIColor colorNamed:@"HistodayButtonLabelColor"] forState:UIControlStateNormal];
    } else {
        [weekChooseBtn setTitleColor:[UIColor colorWithHexString:@"F0F0F2"] forState:UIControlStateNormal];
    }
    
    if (@available(iOS 11.0, *)) {
        weekChooseBtn.backgroundColor = [UIColor colorNamed:@"HistodayButtonBackGroundColor"];
    } else {
         weekChooseBtn.backgroundColor = [UIColor colorWithHexString:@"#5E5E5E"];
    }
//    DLHistodyButton
    weekChooseBtn.layer.cornerRadius = 20;
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showWeekselectView{
    self.weekselectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAIN_SCREEN_H+360*kRateY);
    [self.reminderView addSubview: self.weekselectView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.weekselectView.frame = CGRectMake(0, -360*kRateY, SCREEN_WIDTH, MAIN_SCREEN_H+360*kRateY);
    }];
}

- (void)showTimeSelectView{

    self.timeSelectView.frame = CGRectMake(0, 0, MAIN_SCREEN_W, 300*kRateY+MAIN_SCREEN_H);
    [self.reminderView addSubview:self.timeSelectView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.timeSelectView.frame = CGRectMake(0, -300*kRateY, SCREEN_WIDTH, 300*kRateY+MAIN_SCREEN_H);
    }];
}

#pragma mark - delegate
//点击周选择view的确定按钮后调用
- (void)selectedTimeStringArray:(NSArray *)stringArray{
    self.weekSelectedArray = stringArray;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

/// 点击周选择view的加号后调用代理方法
/// @param dataDict picker所选择的数据，结构：@{@"weekString":@"",  @"lessonString":@""}
- (void)pickerDidSelectedWithDataDict:(NSDictionary *)dataDict{
    [self.backViewOfTimeSelectedBtn loadSelectedButtonsWithTimeDict:dataDict];
}

#pragma mark - 懒加载&加载
- (DLReminderView *)reminderView{
    if (!_reminderView) {
        _reminderView = [[DLReminderView alloc] init];
        _reminderView.frame = self.view.frame;
        [_reminderView resetConstrains];
        [self addBackViewOfTimeSelectedBtn];
        [_reminderView loadAddButton];
        _reminderView.titleLab.text = _noticeString;
        _reminderView.textFiled.delegate = self;
        _reminderView.textFiled.text = _detailString;
        [_reminderView.textFiled mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_reminderView).offset(MAIN_SCREEN_H*0.2916);
        }];
        
        [_reminderView.addButton addTarget:self action:@selector(showTimeSelectView) forControlEvents:UIControlEventTouchUpInside];
        [_reminderView.nextBtn addTarget:self action:@selector(didClickNextButton:) forControlEvents:UIControlEventTouchUpInside];
        _reminderView.nextBtn.tag = 1;
        [_reminderView.backBtn addTarget: self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reminderView;
}
- (void)addBackViewOfTimeSelectedBtn{
    self.backViewOfTimeSelectedBtn = [[TimeSelectedBtnsView alloc] init];
    [self.reminderView addSubview:self.backViewOfTimeSelectedBtn];
    self.backViewOfTimeSelectedBtn.delegate = self;
    [self.backViewOfTimeSelectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reminderView);
        make.width.mas_equalTo(MAIN_SCREEN_W);
        make.top.equalTo(self.reminderView).offset(0.4515*MAIN_SCREEN_H);
    }];
}
- (DLWeeklSelectView *)weekselectView{
    if (!_weekselectView) {
        _weekselectView = [[DLWeeklSelectView alloc] init];
        _weekselectView.delegate = self;
    }
    return _weekselectView;
}

- (DLTimeSelectView *)timeSelectView{
    if (!_timeSelectView) {
        _timeSelectView = [[DLTimeSelectView alloc] init];
        _timeSelectView.delegate = self;
    }
    return _timeSelectView;
}

@end
