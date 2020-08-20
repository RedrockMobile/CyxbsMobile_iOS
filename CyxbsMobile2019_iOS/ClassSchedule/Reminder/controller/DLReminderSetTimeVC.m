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
#import "TimeBtnSelectedBackView.h"

#define kRateX [UIScreen mainScreen].bounds.size.width/375   //以iPhoneX为基准
#define kRateY [UIScreen mainScreen].bounds.size.height/812  //以iPhoneX为基准
@interface DLReminderSetTimeVC ()<UITextFieldDelegate, WeekSelectDelegate,DLTimeSelectViewDelegate,TimeBtnSelectedBackViewDeleget>
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
@property (nonatomic,strong)TimeBtnSelectedBackView *backViewOfTimeSelectedBtn;

@property (nonatomic,strong)UIButton *ifNotiBtn;

@end

@implementation DLReminderSetTimeVC

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.weekSelectedArray = [@[] mutableCopy];
    self.timeDictArray = [NSMutableArray array];
    [self addReminderView];
    [self addBackViewOfTimeSelectedBtn];
//    [self loadAddButton];
    
    UIButton *weekChooseBtn =  [self getBtnWithTitileStr:@"备忘周"];
    [self.reminderView addSubview:weekChooseBtn];
    [weekChooseBtn addTarget:self action:@selector(showWeekselectView) forControlEvents:UIControlEventTouchUpInside];

    [weekChooseBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reminderView).offset(MAIN_SCREEN_W*0.0534);
        make.top.equalTo(self.reminderView).offset(MAIN_SCREEN_H*0.3789);
    }];
//
    UIButton *ifNotiBtn = [self getBtnWithTitileStr:@"不提醒"];
    [self.reminderView addSubview:ifNotiBtn];
    self.ifNotiBtn = ifNotiBtn;

    [ifNotiBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reminderView).offset(MAIN_SCREEN_W*0.0534);
        make.top.equalTo(self.backViewOfTimeSelectedBtn.mas_bottom).offset(10);
    }];
    
    [self.reminderView.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ifNotiBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.reminderView);
        make.width.mas_equalTo(66*kRateX);
        make.height.mas_equalTo(66*kRateX);
    }];
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
//    model.week = self.weekArray;
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

/// 添加弹出选择周view的按钮，显示@“备忘周”3字
- (UIButton*)getBtnWithTitileStr:(NSString*)titleStr{
    UIButton *weekChooseBtn = [[UIButton alloc] init];
    
    [weekChooseBtn setTitle:titleStr forState:UIControlStateNormal];
    weekChooseBtn.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:15];
    
    [weekChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(MAIN_SCREEN_W*0.104);

    }];
    
    [weekChooseBtn.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weekChooseBtn).offset(0.03429*MAIN_SCREEN_W);
        make.right.equalTo(weekChooseBtn).offset(-0.03429*MAIN_SCREEN_W);
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
    weekChooseBtn.layer.cornerRadius = 20;
    
    return weekChooseBtn;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

/// 弹出选择周的view
- (void)showWeekselectView{
    self.weekselectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAIN_SCREEN_H+360*kRateY);
    [self.reminderView addSubview: self.weekselectView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.weekselectView.frame = CGRectMake(0, -360*kRateY, SCREEN_WIDTH, MAIN_SCREEN_H+360*kRateY);
    }];
}

/// 弹出选择时间的view
- (void)showTimeSelectView{
    self.timeSelectView.frame = CGRectMake(0, 0, MAIN_SCREEN_W, 300*kRateY+MAIN_SCREEN_H);
    [self.reminderView addSubview:self.timeSelectView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.timeSelectView.frame = CGRectMake(0, -300*kRateY, SCREEN_WIDTH, 300*kRateY+MAIN_SCREEN_H);
    }];
}



- (void)addNotiBtn{
    
}
#pragma mark - delegate
/// 点击周选择view的确定按钮后调用
/// @param stringArray 在WeekSelect里面选择的周的标题组成的数组
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
- (void)loadAddButton{
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage imageNamed:@"timeAddImage"] forState:UIControlStateNormal];
    [btn sizeToFit];
    [self.reminderView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.reminderView).offset(0.4594*MAIN_SCREEN_H);
        make.bottom.equalTo(self.backViewOfTimeSelectedBtn.backView);
        make.right.equalTo(self.reminderView).offset(-0.104*MAIN_SCREEN_W);
        make.height.mas_equalTo(MAIN_SCREEN_W*0.0693);
        make.width.mas_equalTo(MAIN_SCREEN_W*0.0693);
    }];
    [btn addTarget:self action:@selector(showTimeSelectView) forControlEvents:UIControlEventTouchUpInside];
}
- (void)addReminderView{
    self.reminderView = [[DLReminderView alloc] init];
    self.reminderView.frame = self.view.frame;
    [self.view addSubview:self.reminderView];
//    [self.reminderView resetConstrains];
    self.reminderView.titleLab.text = _noticeString;
    self.reminderView.textFiled.delegate = self;
    self.reminderView.textFiled.text = _detailString;
    [self.reminderView.textFiled mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reminderView).offset(MAIN_SCREEN_H*0.2916);
    }];
    [self.reminderView.nextBtn addTarget:self action:@selector(didClickNextButton:) forControlEvents:UIControlEventTouchUpInside];
    self.reminderView.nextBtn.tag = 1;
    [self.reminderView.backBtn addTarget: self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
}
/// 添加带叉的时间按钮的背景
- (void)addBackViewOfTimeSelectedBtn{
    self.backViewOfTimeSelectedBtn = [[TimeBtnSelectedBackView alloc] init];
    [self.reminderView addSubview:self.backViewOfTimeSelectedBtn];
    self.backViewOfTimeSelectedBtn.timeDateDelegate = self;
    [self.backViewOfTimeSelectedBtn.addBtn addTarget:self action:@selector(showTimeSelectView) forControlEvents:UIControlEventTouchUpInside];
    [self.backViewOfTimeSelectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reminderView);
        make.width.mas_equalTo(MAIN_SCREEN_W);
        make.top.equalTo(self.reminderView).offset(0.4515*MAIN_SCREEN_H);
//        make.bottom.equalTo(self.reminderView).offset(-MAIN_SCREEN_H*0.2);
    }];
}
@end
