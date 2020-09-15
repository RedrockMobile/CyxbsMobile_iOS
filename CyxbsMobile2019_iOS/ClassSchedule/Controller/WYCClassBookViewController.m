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
#define LEFTBARW (MAIN_SCREEN_W*0.088)
//某节课详情弹窗的高度

@interface WYCClassBookViewController ()<UIScrollViewDelegate,TopBarScrollViewDelegate>
/**课表顶部的小拖拽条*/
@property (nonatomic, weak) UIView *dragHintView;
//当前显示的课表对应的下标
@property (nonatomic, assign) NSNumber *index;
//承载20几张课表的view
@property (nonatomic, strong)  UIScrollView *scrollView;
//日期数据模型
@property (nonatomic, strong) DateModle *dateModel;

//20几张LessonViewForAWeek课表组成的数组，lessonViewArray[0]是整学期
@property (nonatomic, strong)NSMutableArray <LessonViewForAWeek*> *lessonViewArray;
//拖动手势，下拉弹回课表
@property (nonatomic, strong)UIPanGestureRecognizer *PGR;

@property (nonatomic, assign)BOOL isReloading;
@property (nonatomic, strong)NSMutableArray <UIView*> *backViewArray;
@end

@implementation WYCClassBookViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lessonViewArray = [NSMutableArray array];
    self.backViewArray = [NSMutableArray array];
    
//    for (int i=0; i<self.dateModel.dateArray.count+1; i++) {
//        [self.backViewArray addObject:[[UIView alloc]init]];
//    }

    //添加备忘信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNoteWithModel:) name:@"LessonViewShouldAddNote" object:nil];
    
    //删除备忘信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteNoteWithModel:) name:@"shouldDeleteNote" object:nil];
    
    //编辑备忘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editNoteWithModel:) name:@"DLReminderSetTimeVCShouldEditNote" object:nil];
    
    //课前提醒开关打开时，MineViewController发送通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remindBeforeClass) name:@"remindBeforeClass" object:nil];
    
    //课前提醒开关关闭时，MineViewController发送通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notRemindBeforeClass) name:@"notRemindBeforeClass" object:nil];
    
    //收到通知后，课表会present通知里面的VC，ClassDetailView发通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldPresentVC:) name:@"WYCClassBookVCShouldPresentVC" object:nil];
    
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"peopleListViewBackColor"];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    //如果是自己的课表，那就加假的tabBar
    if(self.schedulType==ScheduleTypePersonal){
        [self addFakeBar];
    }
    
    [self showHud];
    
    //初始化self.scrollView，并把它加到self.view上面
    [self initScrollView];
    
    self.index = self.dateModel.nowWeek;
    
    //添加周选择条、显示本周的条
   [self addTopBarView];
    
   //加拖拽提示条
   [self addDragHintView];
    
    //如果是自己的课表，那就加上下拉dismiss手势
    if(self.schedulType==ScheduleTypePersonal)[self addGesture];
    
    //用贝塞尔曲线给左上和右上加圆角，避免没课约、查课表页的课表再底部出现圆角
    [self addRoundRect];
    
    self.view.layer.shadowOffset = CGSizeMake(0, -15);
    
    self.view.layer.shadowOpacity = 0.5;
}
- (void)remindBeforeClass{
    //刷新tabar的数据，tabbar会根据偏好设置缓存决定是否提醒或者移除提醒
    [self.schedulTabBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
    //fakeBar不会对本地通知做出改动，只是刷新数据
    [self.fakeBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
}
- (void)notRemindBeforeClass{
    //刷新tabar的数据，tabbar会根据偏好设置缓存决定是否提醒或者移除提醒
    [self.schedulTabBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
    //fakeBar不会对本地通知做出改动，只是刷新数据
    [self.fakeBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
}
//加上下拉dismiss手势
- (void)addGesture{
    if(self.schedulType==ScheduleTypePersonal){
        UIPanGestureRecognizer *PGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissSelf)];
        self.PGR = PGR;
        [self.view addGestureRecognizer:PGR];
    }
}
//自己课表页下拉后调用
- (void)dissMissSelf{
    if(self.PGR.state==UIGestureRecognizerStateBegan){
        TransitionManager *TM =  (TransitionManager*)self.transitioningDelegate;
        TM.PGRToInitTransition = self.PGR;
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            
            TM.PGRToInitTransition=nil;
            
            int count = (int)self.dateModel.dateArray.count, i;
            for (i=0; i<self.index.intValue-1; i++) {
                if(self.backViewArray[i].superview!=nil){
                    [self.backViewArray[i] removeFromSuperview];
                }
            }
            
            for (i=self.index.intValue+2; i<count+1; i++) {
                if(self.backViewArray[i].superview!=nil){
                    [self.backViewArray[i] removeFromSuperview];
                }
            }
        }];
    }
}
/// DLReminderSetTimeVC发送通知后调用
/// @param noti 内部的object是备忘数据对应的NoteDataModel
- (void)addNoteWithModel:(NSNotification*)noti{
    //虽然其他地方也会作判断以避免在没课约、查课表页使用了个人课表才有的操作，但是这是为了以防疏忽
    //这里也做一次判断：如果课表类型不是自己的，那么return
    if(self.schedulType!=ScheduleTypePersonal)return;
    NoteDataModel *model = noti.object;
    [self.model addNoteDataWithModel:model];
    /// 若model.weeksArray==@[@4,@1,@18],代表第4、1、18周的备忘
    
    for (NSNumber *weekNum in model.weeksArray) {
        if(weekNum.intValue==0){
            for (LessonViewForAWeek *lvfw in self.lessonViewArray) {
                [lvfw addNoteLabelWithNoteDataModel:model];
            }
        }else{
            [self.lessonViewArray[weekNum.intValue] addNoteLabelWithNoteDataModel:model];
        }
    }
}

/// 接收要修改备忘的通知时调用，由NoteDetailView、DLReminderSetTimeVC发送通知，
/// @param noti 通知
- (void)deleteNoteWithModel:(NSNotification*)noti{
    //虽然其他地方也会作判断以避免在没课约、查课表页使用了个人课表才有的操作，但是这是为了以防疏忽
    //这里也做一次判断：如果课表类型不是自己的，那么return
    if(self.schedulType!=ScheduleTypePersonal)return;
    NoteDataModel *model = noti.object;
    //  如果不是@“不提醒”，那就去除本地通知,
    if(![model.notiBeforeTime isEqualToString:@"不提醒"]){
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
    [self.model deleteNoteDataWithModel:model];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载数据中...";
    hud.color = [UIColor colorWithWhite:0.f alpha:0.4f];
    [self ModelDataLoadSuccess:self.model];
}

/// 接收要修改备忘的通知时调用，由NoteDetailView发送通知
/// @param noti 通知
- (void)editNoteWithModel:(NSNotification*)noti{
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

//view要出现时调用
- (void)viewWillAppear:(BOOL)animated{
    if([self.schedulTabBar respondsToSelector:@selector(updateSchedulTabBarViewWithDic:)]){
        //让tabBar和假的tabBar更新一下下节课信息
        [self.fakeBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
        [self.schedulTabBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
            self.topBarView.contentOffset = CGPointMake(MAIN_SCREEN_W, 0);
    }
}

///用贝塞尔曲线给左上和右上加圆角，避免没课约、查课表页的课表再底部出现圆角
- (void)addRoundRect{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(16, 0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
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
    int count = (int)self.backViewArray.count;
    if(count==0)return;
    if(0<index.intValue&&index.intValue<count-1){
        [self addSchedulWithIndex:index.intValue];
        [self addSchedulWithIndex:index.intValue-1];
        [self addSchedulWithIndex:index.intValue+1];
    }else if(index.intValue==0){
        [self addSchedulWithIndex:index.intValue];
        [self addSchedulWithIndex:index.intValue+1];
    }else if(index.intValue==count-1){
        [self addSchedulWithIndex:index.intValue];
        [self addSchedulWithIndex:index.intValue-1];
    }
}

- (void)addSchedulWithIndex:(int)index{
    if(self.backViewArray[index].superview!=nil)return;
    [self.scrollView addSubview:self.backViewArray[index]];
}

//MARK:-
//添加周选择条、显示本周的条
- (void)addTopBarView{
    TopBarScrollView *topBarView = [[TopBarScrollView alloc] initWithFrame:CGRectMake(0, MAIN_SCREEN_W*0.07867-15, MAIN_SCREEN_W, 40)];
    self.topBarView = topBarView;
    [self.view addSubview:topBarView];
    topBarView.dateModel = self.dateModel;
    topBarView.weekChooseDelegate = self;
    topBarView.correctIndex = self.index;
}

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

-(void)reloadView{
    [self.view removeAllSubviews];
    [self showHud];
    //初始化self.scrollView，并把它加到self.view上面
    [self initScrollView];
    [self addTopBarView];
    [self addDragHintView];
}

//登录成功、viewDidLoad、reloadView，时会调用这个方法
- (void)showHud{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载数据中...";
    hud.color = [UIColor colorWithWhite:0.f alpha:0.4f];
}

//WYCClassAndRemindDataModel模型加载成功后调用
- (void)ModelDataLoadSuccess:(id)model{
    [self.scrollView removeAllSubviews];
    [self.lessonViewArray removeAllObjects];
    [self.backViewArray removeAllObjects];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //让tabBar和假的tabBar更新一下下节课信息
    [self.schedulTabBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
    [self.fakeBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
    
    @autoreleasepool {
        for (int dateNum = 0; dateNum < self.dateModel.dateArray.count + 1; dateNum++) {
            UIView *backView = [[UIView alloc] init];
            backView.frame = CGRectMake(dateNum*self.scrollView.frame.size.width-0.1,MAIN_SCREEN_W*0.1547, self.scrollView.frame.size.width, MAIN_SCREEN_H);
            
            //显示日期信息的条
            DayBarView *dayBar;
            if(dateNum==0){
                dayBar = [[DayBarView alloc] initForWholeTerm];
            }else{
                //顶部日期条
                dayBar = [[DayBarView alloc] initWithDataArray:self.dateModel.dateArray[dateNum-1]];
            }
            [backView addSubview:dayBar];
            dayBar.frame = CGRectMake(0,0, self.scrollView.frame.size.width, DAY_BAR_ITEM_H);
            
            
            
            //承载课表和左侧第几节课信息的条的view
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, DAY_BAR_ITEM_H+MAIN_SCREEN_W*0.024, MAIN_SCREEN_W, MAIN_SCREEN_H*0.8247)];
            [backView addSubview:scrollView];
            scrollView.delegate = self;
            scrollView.backgroundColor = [UIColor clearColor];
            scrollView.showsVerticalScrollIndicator = NO;
            [scrollView setContentSize:CGSizeMake(0, MAIN_SCREEN_W*1.979186)];
            
            
            
            
            //左侧课条
            LeftBar *leftBar = [[LeftBar alloc] init];
            [scrollView addSubview:leftBar];
            leftBar.frame = CGRectMake(0,0, MONTH_ITEM_W, leftBar.frame.size.height);
            
            
            
            //课表
            LessonViewForAWeek *lessonViewForAWeek = [[LessonViewForAWeek alloc] initWithDataArray:self.model.orderlySchedulArray[dateNum]];
            [scrollView addSubview:lessonViewForAWeek];
            [self.lessonViewArray addObject:lessonViewForAWeek];
            lessonViewForAWeek.week = dateNum;
            lessonViewForAWeek.schType = self.schedulType;
            [lessonViewForAWeek setUpUI];
            lessonViewForAWeek.frame = CGRectMake(MONTH_ITEM_W+DAYBARVIEW_DISTANCE,0, lessonViewForAWeek.frame.size.width, lessonViewForAWeek.frame.size.height);
            
            
            
            
            self.backViewArray[dateNum] = backView;
            
        }
    }
    //如果是自己的课表,那就添加备忘
    if(self.schedulType==ScheduleTypePersonal){
        for (NoteDataModel *model in self.model.noteDataModelArray) {
            for (NSNumber *weekNum in model.weeksArray) {
                //如果是整学期处的备忘，那么每张课表都要加一下备忘信息
                if(weekNum.intValue==0){
                    for (LessonViewForAWeek *lvfw in self.lessonViewArray) {
                        [lvfw addNoteLabelWithNoteDataModel:model];
                    }
                }else{
                    [self.lessonViewArray[weekNum.intValue] addNoteLabelWithNoteDataModel:model];
                }
            }
        }
    }
    
    self.scrollView.contentOffset = CGPointMake(self.index.intValue*self.scrollView.frame.size.width,0);
    self.index = self.index;
}

//WYCClassAndRemindDataModel模型加载失败后调用
- (void)ModelDataLoadFailure{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
   
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"网络错误" message:@"数据加载失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [controller addAction:act1];
    
    [self presentViewController:controller animated:YES completion:nil];
}

//初始化self.scrollView，并把它加到self.view上面
- (void)initScrollView{
    self.scrollView = [[UIScrollView alloc]init];
    [self.scrollView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView.contentSize = CGSizeMake((self.dateModel.dateArray.count+1) * self.scrollView.frame.size.width, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.scrollView layoutIfNeeded];
    [self.view addSubview:self.scrollView];
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

//MARK:-代理方法：
//代理方法，去某一周
- (void)gotoWeekAtIndex:(NSNumber*)index{
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(index.intValue*MAIN_SCREEN_W, 0);
    }];
}

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
        self.isReloading = YES;
        [self showHud];
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.alpha = 0;
        }completion:^(BOOL finished) {
            [self.scrollView removeAllSubviews];
            self.scrollView.alpha = 1;
            
            [self.model getPersonalClassBookArrayWithStuNum:self.stuNum];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isReloading = NO;
        });
    }
}
///通过通知中心调用，调用后全屏presentVC
- (void)shouldPresentVC:(NSNotification*)noti{
    UIViewController *VC = noti.object;
    [self presentViewController:VC animated:YES completion:nil];
}
@end
