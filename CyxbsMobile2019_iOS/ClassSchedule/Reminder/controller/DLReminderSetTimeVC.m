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
#import "NoticeWaySelectView.h"
#import "NoteDataModel.h"

#define kRateX [UIScreen mainScreen].bounds.size.width/375   //以iPhoneX为基准
#define kRateY [UIScreen mainScreen].bounds.size.height/812  //以iPhoneX为基准
@interface DLReminderSetTimeVC ()<UITextFieldDelegate, WeekSelectDelegate,DLTimeSelectViewDelegate,TimeBtnSelectedBackViewDeleget,NoticeWaySelectViewDelegate>
@property (nonatomic, strong) UIPickerView *timePiker;
@property (nonatomic, strong) DLReminderView *reminderView;

/// 周选择view，懒加载
@property (nonatomic, strong) DLWeeklSelectView *weekselectView;

/// 时间选择view，懒加载
@property (nonatomic, strong) DLTimeSelectView *timeSelectView;

//@property (nonatomic, copy) NSArray *weekArray;

@property (nonatomic, strong)NoticeWaySelectView *notiWaySelecter;

///存储已选择的周
@property (nonatomic, strong) NSArray *weekSelectedArray;

/// 提醒方式的字符串
@property (nonatomic, copy)NSString *notiStr;

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

    [ifNotiBtn addTarget:self action:@selector(pushNotiWaySelecter) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    self.notiStr = @"不提醒";
}

#pragma mark - 点击事件
//点击下方的大勾勾按钮
//@{@"weekString":@"",  @"lessonString":@""}
- (void)didClickNextButton:(UIButton *)button{
    int mark=0;
    if(self.timeDictArray.count==0){
        mark+=1;
    }
    if(self.weekSelectedArray.count==0){
        mark+=2;
    }
//    self.notiStr默认为@“不提醒”，所以不可能为空，故这里不作判断
    NSArray *textArray  = @[@"",@"还没有选择具体时间",@"还没有选择备忘周",@"什么时间都还没选呢",];
    if(mark!=0){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:(MBProgressHUDModeText)];
        hud.labelText = textArray[mark];
        [hud hide:YES afterDelay:1];
        return;
    }else{
        NoteDataModel *model = [[NoteDataModel alloc] initWithNotoDataDict:@{
            @"weeksStrArray":self.weekSelectedArray,
            @"timeStrDictArray":self.timeDictArray,
            @"notiBeforeTime":self.notiStr,
            @"noteTitleStr":self.noticeString,
            @"noteDetailStr":self.detailString,
        }];
        NSArray *modelArray =  [[NSUserDefaults standardUserDefaults] objectForKey:@"userNoteDataModelArray"];
        NSMutableArray *newModelArray = [modelArray mutableCopy];
        [newModelArray addObject:model];
        [[NSUserDefaults standardUserDefaults] setObject:newModelArray forKey:@"userNoteDataModel"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LessonViewShouldAddNote" object:model];
        [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
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
    [self.presentingViewController dismissViewControllerAnimated:self completion:nil];
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

/// 推出选择
- (void)pushNotiWaySelecter{
    [self.notiWaySelecter setFrame:CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_H+0.4261*MAIN_SCREEN_H)];
    [self.view addSubview:self.notiWaySelecter];
    [UIView animateWithDuration:0.5 animations:^{
        self.notiWaySelecter.frame = CGRectMake(0, -0.4261*MAIN_SCREEN_H, MAIN_SCREEN_W, MAIN_SCREEN_H+0.4261*MAIN_SCREEN_H);
    }];
}

- (void)addNotiBtn{
    
}
#pragma mark - delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

/// 点击周选择view的确定按钮后调用的代理方法
/// @param stringArray 在WeekSelect里面选择的周的标题组成的数组
- (void)selectedTimeStringArray:(NSArray *)stringArray{
    self.weekSelectedArray = stringArray;
}

/// 点击时间选择view里的加号后调用的代理方法
/// @param dataDict picker所选择的数据，结构：@{@"weekString":@"",  @"lessonString":@""}
- (void)pickerDidSelectedWithDataDict:(NSDictionary *)dataDict{
    [self.backViewOfTimeSelectedBtn loadSelectedButtonsWithTimeDict:dataDict];
}

/// 选择提醒方式的view上的确定按钮点击后调用的代理方法
/// @param notiStr 提醒方式字符串
- (void)notiPickerDidSelectedWithString:(NSString *)notiStr{
    self.notiStr = notiStr;
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

- (NoticeWaySelectView *)notiWaySelecter{
    if(_notiWaySelecter==nil){
        _notiWaySelecter = [[NoticeWaySelectView alloc] init];
        _notiWaySelecter.delegate = self;
    }
    return _notiWaySelecter;
}
/// 加上背景
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
