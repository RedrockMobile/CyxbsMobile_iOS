//
//  WYCClassBookViewController.m
//  MoblieCQUPT_iOS
//
//  Created by 王一成 on 2018/9/21.
//  Copyright © 2018年 Orange-W. All rights reserved.
//

#import "WYCClassBookViewController.h"
#import "ClassTabBar.h"
#import "NextLessonFinder.h"
#import "DLReminderSetTimeVC.h"
#import "DayBarView.h"
#import "LeftBar.h"
#import "LessonViewForAWeek.h"
#import "TransitionManager.h"
#import <UserNotifications/UserNotifications.h>
#import "LocalNotiManager.h"
#define LEFTBARW (MAIN_SCREEN_W*0.088)
//某节课详情弹窗的高度
#import "掌上重邮-Swift.h"        // 将Swift中的类暴露给OC

@interface WYCClassBookViewController ()<
    UIScrollViewDelegate,
    TopBarScrollViewDelegate
>
/**课表顶部的小拖拽条*/
@property (nonatomic, weak) UIView *dragHintView;
//当前显示的课表对应的下标
@property (nonatomic, assign) NSNumber *index;
//承载20几张课表的view
@property (nonatomic, strong)  UIScrollView *scrollView;
//日期数据模型
@property (nonatomic, strong) DateModle *dateModel;


//拖动手势，下拉弹回课表
@property (nonatomic, strong)UIPanGestureRecognizer *PGR;

@property (nonatomic, assign)BOOL isReloading;
/// 用来存储课表信息的，如学号、老师的数据等
@property (nonatomic, strong)id schedulInfo;

/// 已经添加到scrollView的课表的backView字典，scBackViewDict[@"0"]代表整学期页
@property (nonatomic, strong)NSMutableDictionary *scBackViewDict;

/// lessonViewDict[0]代表整学期页的课表，lessonViewDict[x]代表第x周
@property (nonatomic, strong)NSMutableDictionary <NSString*, LessonViewForAWeek*>* lessonViewDict;
@end

@implementation WYCClassBookViewController
- (instancetype)initWithType:(ScheduleType)type andInfo:(nonnull id)info{
    self = [super init];
    if (self) {
//        [[NSFileManager defaultManager]removeItemAtPath:remDataDirectory error:nil];
        WYCClassAndRemindDataModel *model = [[WYCClassAndRemindDataModel alloc]initWithType:type];
        self.schedulType = type;
        model.delegate = self;
        self.model = model;
        self.schedulInfo = info;
        //要延迟一点再调用，确保：
        //个人课表状态下，调用modelLoadDataWithInfo方法时self.schedulTabBar已经有值
        //第一次登录时，不会显示在第一周
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self modelLoadDataWithInfo: self->_schedulInfo];
        });
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加对通知中心的监听
    [self addNoti];
    
    self.lessonViewDict = [[NSMutableDictionary alloc] init];
    self.scBackViewDict = [[NSMutableDictionary alloc] init];
    
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"peopleListViewBackColor"];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    [self showHud];
    
    self.view.layer.shadowOffset = CGSizeMake(0, -15);
    
    self.view.layer.shadowOpacity = 0.5;
    
    //用贝塞尔曲线给左上和右上加圆角，避免没课约、查课表页的课表再底部出现圆角
    [self addRoundRect];
    
    //加拖拽提示条
    [self addDragHintView];
    
    //初始化self.scrollView，并把它加到self.view上面
    [self addScrollView];
    
    _index = self.dateModel.nowWeek;
    
    //添加周选择条、显示本周的条
    [self addTopBarView];
    
    //如果是自己的课表，那就加上下拉dismiss手势、假的tabBar
    if(self.schedulType==ScheduleTypePersonal) {
        [self addFakeBar];
        [self addGesture];
    }
}

//MARK:- 添加控件
///用贝塞尔曲线给左上和右上加圆角，避免没课约、查课表页的课表再底部出现圆角
- (void)addRoundRect{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(16, 0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
}

//添加周选择条、显示本周的条
- (void)addTopBarView{
    TopBarScrollView *topBarView = [[TopBarScrollView alloc] initWithFrame:CGRectMake(0, MAIN_SCREEN_W*0.07867-15, MAIN_SCREEN_W, 40)];
    self.topBarView = topBarView;
    [self.view addSubview:topBarView];
    
    topBarView.dateModel = self.dateModel;
    topBarView.weekChooseDelegate = self;
    topBarView.correctIndex = self.index;
}

//在课表顶部添加一个假的Bar
- (void)addFakeBar{
    FakeTabBarView *bar = [[FakeTabBarView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, 58)];
    self.fakeBar = bar;
    [self.view addSubview:bar];
}

/// 添加提示可拖拽的条
- (void)addDragHintView{
    UIView *dragHintView = [[UIView alloc]init];
    [self.view addSubview:dragHintView];
    if (@available(iOS 11.0, *)) {
        dragHintView.backgroundColor = [UIColor colorNamed:@"draghintviewcolor"];
    } else {
        dragHintView.backgroundColor = [UIColor whiteColor];
    }
    dragHintView.layer.cornerRadius = 2.5;
    [dragHintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@27);
        make.height.equalTo(@5);
        make.top.equalTo(self.view).offset(8);
        make.centerX.equalTo(self.view);
    }];
}

//初始化self.scrollView，并把它加到self.view上面
- (void)addScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    [scrollView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.contentSize = CGSizeMake((self.dateModel.dateArray.count+1) * scrollView.frame.size.width, 0);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
}

-(void)reloadView{
    [self.view removeAllSubviews];
    [self showHud];
    //初始化self.scrollView，并把它加到self.view上面
    [self addScrollView];
    [self addTopBarView];
    [self addDragHintView];
}



//MARK:-懒加载
- (DateModle *)dateModel{
    if(_dateModel==nil){//@"2020-09-07"
        //@"2020-08-24" @"2020-07-20" DateStart
        _dateModel = [DateModle initWithStartDate:DateStart];
    }
    return _dateModel;
}

//重写set方法，如果index超过25，就让index变成0
- (void)setIndex:(NSNumber *)index{
    if(index.intValue>25)index = [NSNumber numberWithInt:0];
    _index = index;
    self.topBarView.correctIndex = _index;
    int count = (int)self.dateModel.dateArray.count + 1;
    
    if(count==0) return;
    int start, end;
    DeviceUtil *u = [[DeviceUtil alloc] init];
    switch (u.hardwareLevel) {
        case DeviceHardwareLevelLow:
            //加2张
            start = index.intValue;
            end = index.intValue + 2;
            break;
        case DeviceHardwareLevelMedium:
            //加4张
            start = index.intValue - 1;
            end = index.intValue + 3;
            break;
        case DeviceHardwareLevelHigh:
            //加6张
            start = index.intValue - 2;
            end = index.intValue + 4;
            break;
    }
    
    if (start<0) {
        start = 0;
    }
    if (end>count) {
        end = count;
    }
    for (int i=start; i<end; i++) {
        [self addSchedulWithIndex:i];
    }
}


//MARK:-代理方法：
//scrollView的代理方法：
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //重写了_index的set方法，内部增加了判断，如果index超过25就让index等0，也就是整学期课表的下标
    if([scrollView isEqual:self.scrollView]){
        self.index = [NSNumber numberWithInt:(int)(scrollView.contentOffset.x/MAIN_SCREEN_W)];
        self.topBarView.correctIndex = self.index;
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([scrollView isEqual:self.scrollView]){
        if(scrollView.dragging==NO&&scrollView.decelerating==NO&&scrollView.tracking==NO){
            //重写了_index的set方法，内部增加了判断，如果index超过25就让index等0，
            //也就是整学期课表的下标
            self.index = [NSNumber numberWithInt:(int)(self.scrollView.contentOffset.x/MAIN_SCREEN_W)];
            self.topBarView.correctIndex = self.index;
        }
    }else if(scrollView.contentOffset.y<-100&&self.isReloading==NO&&self.schedulType==ScheduleTypePersonal){
        //下拉刷新
        self.isReloading = YES;
        [self showHud];
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.alpha = 0;
        }completion:^(BOOL finished) {
            [self.scrollView removeAllSubviews];
            self.scrollView.alpha = 1;
            [self.scBackViewDict removeAllObjects];
            [self.model getPersonalClassBookArrayWithStuNum:self.schedulInfo];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isReloading = NO;
        });
    }
}


//TopBarScrollView的代理方法，去某一周
- (void)gotoWeekAtIndex:(NSNumber*)index{
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(index.intValue*MAIN_SCREEN_W, 0);
    }];
}


//课表、备忘数据模型的代理方法：
/// WYCClassAndRemindDataModel模型加载成功后调用
- (void)ModelDataLoadSuccess{
    [self.scrollView removeAllSubviews];
    [self.lessonViewDict removeAllObjects];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //让tabBar和假的tabBar更新一下下节课信息
    [self.schedulTabBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
    [self.fakeBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
    self.scrollView.contentOffset = CGPointMake(self.index.intValue*self.scrollView.frame.size.width,0);
    //调一下set方法
    self.index = self.index;
}

/// WYCClassAndRemindDataModel模型加载失败后调用
- (void)ModelDataLoadFailure{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [NewQAHud showHudWith:@"数据加载失败了～" AddView:self.view];
    [self ModelDataLoadSuccess];
}



//MARK: - 通知中心
/// 添加对通知中心的监听
- (void)addNoti {
    //添加备忘信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNoteWithNoti:) name:@"LessonViewShouldAddNote" object:nil];
    
    //删除备忘信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteNoteWithNoti:) name:@"shouldDeleteNote" object:nil];
    
    //编辑备忘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editNoteWithNoti:) name:@"DLReminderSetTimeVCShouldEditNote" object:nil];
    
    //课前提醒开关打开时，MineViewController发送通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remindBeforeClass) name:@"remindBeforeClass" object:nil];
    
    //课前提醒开关关闭时，MineViewController发送通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notRemindBeforeClass) name:@"notRemindBeforeClass" object:nil];
    
    //收到通知后，课表会present通知里面的VC，ClassDetailView发通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldPresentVC:) name:@"WYCClassBookVCShouldPresentVC" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editNoteDataWithNoti:) name:@"LessonViewShouldEditNote" object:nil];
}

///通过通知中心调用，调用后全屏presentVC
- (void)shouldPresentVC:(NSNotification*)noti{
    UIViewController *VC = noti.object;
    [self presentViewController:VC animated:YES completion:nil];
}

/// 课前提醒
- (void)remindBeforeClass{
    //刷新tabar的数据，tabbar会根据偏好设置缓存决定是否添加课前提醒或者移除提醒
    [self.schedulTabBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
    //fakeBar不会对本地通知做出改动，只是刷新数据
    [self.fakeBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
}

/// 移除课前提醒
- (void)notRemindBeforeClass{
    //刷新tabar的数据，tabbar会根据偏好设置缓存决定是否提醒或者移除提醒
    [self.schedulTabBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
    //fakeBar不会对本地通知做出改动，只是刷新数据
    [self.fakeBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
}

/// DLReminderSetTimeVC发送通知后调用
/// @param noti 内部的object是备忘数据对应的NoteDataModel
- (void)addNoteWithNoti:(NSNotification*)noti{
    //虽然其他地方也会作判断以避免在没课约、查课表页使用了个人课表才有的操作，但是这是为了以防疏忽
    //这里也做一次判断：如果课表类型不是自己的，那么return
    if(self.schedulType!=ScheduleTypePersonal)return;
    NoteDataModel *model = noti.object;
    [self addNoteWithModel:model];
}
- (void)addNoteWithModel:(NoteDataModel*)model {
    [self.model addNoteDataWithModel:model];
    /// 若model.weeksArray==@[@4,@1,@18],代表第4、1、18周的备忘
    
    //添加本地通知
    if(![model.notiBeforeTime isEqual:@"不提醒"]){
        NSString *notiIdStr;
        for (NSNumber *weekNum in model.weeksArray) {
            for (NSDictionary *timeDict in model.timeDictArray) {
                notiIdStr = [NSString stringWithFormat:@"%@.%d.%@.%@",
                             model.noteID, weekNum.intValue,
                             timeDict[@"weekNum"], timeDict[@"lessonNum"]];
                
                [LocalNotiManager setLocalNotiWithWeekNum:weekNum.intValue weekDay:[timeDict[@"weekNum"] intValue]
                                                   lesson:[timeDict[@"lessonNum"] intValue]
                                                   before:model.notiBeforeTimeLenth
                                                 titleStr:model.noteTitleStr
                                              subTitleStr:nil
                                                  bodyStr:model.noteDetailStr
                                                       ID:notiIdStr];
            }
        }
    }
    
    for (NSNumber *weekNum in model.weeksArray) {
        if(weekNum.intValue==0){
            [self.lessonViewDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, LessonViewForAWeek * _Nonnull obj, BOOL * _Nonnull stop) {
                [obj addNoteLabelWithNoteDataModel:model];
            }];
        }else{
            [self.lessonViewDict[weekNum.stringValue] addNoteLabelWithNoteDataModel:model];
        }
    }
}


/// 接收要删除/修改备忘的通知时调用，由NoteDetailView、DLReminderSetTimeVC发送通知，
/// @param noti 通知
- (void)deleteNoteWithNoti:(NSNotification*)noti{
    //虽然其他地方也会作判断以避免在没课约、查课表页使用了个人课表才有的操作，但是这是为了以防疏忽
    //这里也做一次判断：如果课表类型不是自己的，那么return
    if(self.schedulType!=ScheduleTypePersonal)return;
    NoteDataModel *model = noti.object;
    [self deleteNoteWithModel:model];
}

- (void)deleteNoteWithModel:(NoteDataModel*)model {
    //  如果不是@“不提醒”，那就去除本地通知,
    if(![model.notiBeforeTime isEqualToString:@"不提醒"]) {
        if([model.weeksArray firstObject].intValue==0){
            for (int i=1; i<25; i++) {
                for (NSDictionary *timeDict in model.timeDictArray) {
                    NSString *notiID = [NSString stringWithFormat:@"%@.%d.%@.%@",model.noteID,i,timeDict[@"weekNum"],timeDict[@"lessonNum"]];
                    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[notiID]];
                }
            }
        }else{
            for (NSNumber *weekNum in model.weeksArray) {
                for (NSDictionary *timeDict in model.timeDictArray) {
                    NSString *notiID = [NSString stringWithFormat:@"%@.%d.%@.%@",model.noteID,weekNum.intValue,timeDict[@"weekNum"],timeDict[@"lessonNum"]];
                    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[notiID]];
                }
            }
        }
    }
    //移除备忘数据
    [self.model deleteNoteDataWithModel:model];
    //更新UI
    for (NSNumber *weekNum in model.weeksArray) {
        [self.lessonViewDict[weekNum.stringValue] deleteNoteWithNoteDataModel:model];
    }
}


/// 接收要修改备忘的通知时调用，由NoteDetailView发送通知
/// @param noti 通知
- (void)editNoteWithNoti:(NSNotification*)noti{
    //虽然其他地方也会作判断以避免在没课约、查课表页使用了个人课表才有的操作，但是这是为了以防疏忽
    //这里也做一次判断：如果课表类型不是自己的，那么return
    if(self.schedulType!=ScheduleTypePersonal)return;
    NoteDataModel *model = noti.object;
    DLReminderSetTimeVC *vc = [[DLReminderSetTimeVC alloc] init];
    [vc setModalPresentationStyle:(UIModalPresentationCustom)];
    [self presentViewController:vc animated:YES completion:nil];
    //通过原备忘的数据，来设置好信息
    [vc initDataForEditNoteWithMode:model];
}

- (void)editNoteDataWithNoti:(NSNotification*)noti {
    NSDictionary *modelDict = noti.object;
    NoteDataModel *new = modelDict[@"new"];
    NoteDataModel *old = modelDict[@"old"];
    
    [self deleteNoteWithModel:old];
    
    [self addNoteWithModel:new];
}


//MARK: - 其他
/// 根据课表类型来加载课表数据
/// @param info 包含了发送网络请求时的参数，具体参数格式看课表.h的init方法处的说明
- (void)modelLoadDataWithInfo:(id)info{
    if (info==nil) {
        [_model getPersonalClassBookArrayWithStuNum:[[UserItem defaultItem]stuNum]];
        return;
    }
    switch (self.schedulType) {
        case ScheduleTypePersonal:
            //要求info是学号
            [_model getPersonalClassBookArrayWithStuNum:info];
            break;
        case ScheduleTypeClassmate:
            //要求info是学号
            [_model getClassBookArrayFromNet:info];
            break;
        case ScheduleTypeTeacher:
            //要求info是这种结构@{ @"teaName": name, @"tea": teaNum }
            [_model getTeaClassBookArrayFromNet:info];
            break;
        case ScheduleTypeWeDate:
            //要求info是这种结构@[@{@"stuNum":学号}, @{@"stuNum":学号}...]
            [_model getClassBookArrayFromNetWithInfoDictArr:info];
            break;
    }
}
/// 加上下拉dismiss手势
- (void)addGesture{
    if(self.schedulType==ScheduleTypePersonal){
        UIPanGestureRecognizer *PGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissSelf)];
        self.PGR = PGR;
        [self.view addGestureRecognizer:PGR];
    }
}

/// 自己课表页下拉收回后调用
- (void)dissMissSelf{
    if(self.PGR.state==UIGestureRecognizerStateBegan){
        TransitionManager *TM =  (TransitionManager*)self.transitioningDelegate;
        TM.PGRToInitTransition = self.PGR;
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            TM.PGRToInitTransition=nil;
            int nowIndex = [self.index intValue];
            [self.scBackViewDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                int intIndex = [key intValue];
                //移除 除以当前下标为中心的三个课表 的所有课表
                //如：假设index==3， 那么移除key不等于2、3、4的所有课表
                if ([obj superview]!=nil&&!(nowIndex-1<= intIndex&&intIndex <=nowIndex+1)) {
                    [obj removeFromSuperview];
//                    CLog(@"remove %d",intIndex);
                }
            }];
        }];
    }
}

//view要出现时调用
- (void)viewWillAppear:(BOOL)animated{
    if([self.schedulTabBar respondsToSelector:@selector(updateSchedulTabBarViewWithDic:)]){
        //让tabBar和假的tabBar更新一下下节课信息
        [self.fakeBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
        [self.schedulTabBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
            self.topBarView.contentOffset = CGPointMake(MAIN_SCREEN_W, 0);
    }
}

//登录成功、viewDidLoad、reloadView，时会调用这个方法
- (void)showHud{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载数据中...";
    hud.color = [UIColor colorWithWhite:0.f alpha:0.4f];
}
/// 为第index添加课表，index等0时代表整学期页
- (void)addSchedulWithIndex:(int)index{
    NSString *indexStr = [NSString stringWithFormat:@"%d",index];
    UIView *scBackView = self.scBackViewDict[indexStr];
    if (scBackView!=nil) {
        if ([scBackView superview]==nil) {
//            CLog(@"add1 %d",index);
            [self.scrollView addSubview:scBackView];
        }
        return;
    }
//    UIDevice.currentDevice.name
    scBackView = [[UIView alloc] init];
    [self.scrollView addSubview:scBackView];
    self.scBackViewDict[indexStr] = scBackView;
    
    scBackView.frame = CGRectMake(index*self.scrollView.frame.size.width-0.1,MAIN_SCREEN_W*0.1547, self.scrollView.frame.size.width, MAIN_SCREEN_H);
    
    //显示日期信息的条
    DayBarView *dayBar;
    if(index==0){
        dayBar = [[DayBarView alloc] initForWholeTerm];
    }else{
        //顶部日期条
        dayBar = [[DayBarView alloc] initWithDataArray:self.dateModel.dateArray[index-1]];
    }
    [scBackView addSubview:dayBar];
    dayBar.frame = CGRectMake(0,0, self.scrollView.frame.size.width, DAY_BAR_ITEM_H);
    
    
    //承载课表和左侧第几节课信息的条的view
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, DAY_BAR_ITEM_H+MAIN_SCREEN_W*0.024, MAIN_SCREEN_W, MAIN_SCREEN_H*0.8247)];
    [scBackView addSubview:scrollView];
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [scrollView setContentSize:CGSizeMake(0, MAIN_SCREEN_W*1.979186)];
    
    
    
    
    //左侧课条
    LeftBar *leftBar = [[LeftBar alloc] init];
    [scrollView addSubview:leftBar];
    leftBar.frame = CGRectMake(0,0, MONTH_ITEM_W, leftBar.frame.size.height);
    
    
    
    //课表
    LessonViewForAWeek *lessonViewForAWeek = [[LessonViewForAWeek alloc] initWithDataArray:self.model.orderlySchedulArray[index]];
    [scrollView addSubview:lessonViewForAWeek];
    self.lessonViewDict[indexStr] = lessonViewForAWeek;
    lessonViewForAWeek.week = index;
    lessonViewForAWeek.schType = self.schedulType;
    [lessonViewForAWeek setUpUI];
    lessonViewForAWeek.frame = CGRectMake(MONTH_ITEM_W+DAYBARVIEW_DISTANCE,0, lessonViewForAWeek.frame.size.width, lessonViewForAWeek.frame.size.height);
    
    //如果是自己的课表,那就添加备忘
    if (self.schedulType==ScheduleTypePersonal) {
        for (NoteDataModel *model in self.model.noteDataModelArray[index]) {
            [lessonViewForAWeek addNoteLabelWithNoteDataModel:model];
        }
    }
}

//程序回到前台时调用，在这里更新显示下节课信息的tabBar的信息
- (void)applicationWillEnterForeground:(UIApplication *)application{
    NSLog(@"-----back---");
    if([self.schedulTabBar respondsToSelector:@selector(updateSchedulTabBarViewWithDic:)]){
        //让tabBar和假的tabBar更新一下下节课信息
        [self.fakeBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
        [self.schedulTabBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
    }
}

/**
    返回值的结构：
    @"classroomLabel"：教室地点
    @"classTimeLabel"：上课时间
    @"classLabel"：课程名称
    @"is"：是否有课的标志,1就是有课
    @"hash_lesson"：第几节大课，0代表第一节
    @"hash_day"：星期几，0代表星期一
    @"hash_week"：第几周，1代表第一周
*/
- (NSDictionary*)getNextLessonData{
    return [NextLessonFinder getNextLessonDataWithOSArr:self.model.orderlySchedulArray andNowWeek:self.dateModel.nowWeek.intValue];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
