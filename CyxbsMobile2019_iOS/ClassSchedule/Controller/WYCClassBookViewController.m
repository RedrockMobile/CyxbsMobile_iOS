//
//  WYCClassBookViewController.m
//  MoblieCQUPT_iOS
//
//  Created by 王一成 on 2018/9/21.
//  Copyright © 2018年 Orange-W. All rights reserved.
//

#import "WYCClassBookViewController.h"
#import "ClassTabBar.h"
#import "TopBarScrollView.h"
//#import "LessonViewController.h"
#import "DayBarView.h"
#import "LeftBar.h"
#import "LessonViewForAWeek.h"
#define LEFTBARW (MAIN_SCREEN_W*0.088)
//某节课详情弹窗的高度

@interface WYCClassBookViewController ()<UIScrollViewDelegate,WYCClassBookViewDelegate,WYCShowDetailDelegate,TopBarScrollViewDelegate>
/**课表顶部的小拖拽条*/
@property (nonatomic, weak) UIView *dragHintView;
@property (nonatomic, assign) NSNumber *index;
@property (nonatomic, strong)  UIScrollView *scrollView;
@property (nonatomic, strong) DateModle *dateModel;
@property (nonatomic, strong)TopBarScrollView *topBarView;
@property (nonatomic, strong)NSMutableArray *lessonVCArray;
/// 课的详情弹窗
@property (nonatomic, strong)UIView *detailView;

@end

const float distance=20;
@implementation WYCClassBookViewController
- (void)viewDidLoad {
    self.lessonVCArray = [NSMutableArray array];
    self.navigationController.navigationBar.hidden = YES;
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ModelDataLoadSuccess)
                                                 name:@"ModelDataLoadSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ModelDataLoadFailure)
                                                 name:@"ModelDataLoadFailure" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadView)
                                                 name:@"RemindAddSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadView)
                                                 name:@"RemindEditSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadView)
                                                 name:@"RemindDeleteSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateScrollViewOffSet)
                                                 name:@"ScrollViewBarChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadView)
                                                 name:@"reloadView" object:nil];
    //登录成功后
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(loginSucceeded)
//                                                 name:@"Login_LoginSuceeded" object:nil];
    
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"peopleListViewBackColor"];
    } else {
        self.view.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:0.14];
    }
    [self initModel];
    self.index = self.dateModel.nowWeek;
    
    //初始化self.scrollView，并把它加到self.view上面
    [self initScrollView];
    //往navgationBar上加了一个按钮
    [self initNavigationBar];
    
    //添加周选择条、显示本周的条
   [self addTopBarView];
   
   [self addDragHintView];
       
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.detailView removeFromSuperview];
}

//view要出现时调用
- (void)viewWillAppear:(BOOL)animated{
    if([self.schedulTabBar respondsToSelector:@selector(updateSchedulTabBarViewWithDic:)]){
        [self.schedulTabBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
//        [UIView animateWithDuration:0.3 animations:^{
            self.topBarView.contentOffset = CGPointMake(MAIN_SCREEN_W, 0);
//        }];
    }
}
//MARK:-懒加载

- (DateModle *)dateModel{
    if(_dateModel==nil){
        _dateModel = [DateModle initWithStartDate:DateStart];
    }
    return _dateModel;
}

//重写set方法，如果index超过25，就让index变成0
- (void)setIndex:(NSNumber *)index{
    if(index.intValue>25)index = [NSNumber numberWithInt:0];
    _index = index;
//    self.scrollView.contentOffset = CGPointMake(_index.intValue*MAIN_SCREEN_W, 0);
    self.topBarView.correctIndex = _index;
}

//MARK:-
//添加周选择条、显示本周的条
- (void)addTopBarView{
    TopBarScrollView *topBarView = [[TopBarScrollView alloc] initWithFrame:CGRectMake(0, MAIN_SCREEN_W*0.07867-15, MAIN_SCREEN_W, 30)];
    self.topBarView = topBarView;
    [self.view addSubview:topBarView];
    topBarView.weekChooseDelegate = self;
    topBarView.correctIndex = self.index;
}
- (void)addDragHintView{
    UIView *dragHintView = [[UIView alloc]initWithFrame:CGRectMake(MAIN_SCREEN_W*0.472,MAIN_SCREEN_W*0.024,27,5)];
    if (@available(iOS 11.0, *)) {
        dragHintView.backgroundColor = [UIColor colorNamed:@"draghintviewcolor"];
    } else {
        dragHintView.backgroundColor = [UIColor whiteColor];
    }
    dragHintView.layer.cornerRadius = 2.5;
    [self.view addSubview:dragHintView];
}
//登录成功后调用
-(void)loginSucceeded{
//    [self initModel];
}

-(void)reloadView{
    [self.view removeAllSubviews];
    [self initModel];
    
    //初始化self.scrollView，并把它加到self.view上面
    [self initScrollView];
    //往navgationBar上加了一个按钮
    [self initNavigationBar];
    [self addTopBarView];
    [self addDragHintView];
}

-(void)updateScrollViewOffSet{
    
}

//登录成功、viewDidLoad、reloadView，时会调用这个方法
- (void)initModel{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载数据中...";
    hud.color = [UIColor colorWithWhite:0.f alpha:0.4f];
}

//WYCClassAndRemindDataModel模型加载成功后调用
- (void)ModelDataLoadSuccess{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    @autoreleasepool {
        
        //无序的一周的课表数据
        NSArray *classBookData;
        
        //hash_day代表(周hash_day+1)，hash_lesson代表(第hash_lesson+1节大课)
        NSNumber *hash_day, *hash_lesson;
        
        self.orderlySchedulArray = [NSMutableArray array];
        for (int dateNum = 0; dateNum < self.dateModel.dateArray.count + 1; dateNum++) {
            
            
//------完成对orderlySchedulArray的初始化操作，初始化后里面就是有序的整学期课表和备忘----------
            //有序的课表数据，day[i][j]代表（星期i+1）的（第j+1节大课）
            NSMutableArray *day = [[NSMutableArray alloc]initWithCapacity:7];
            [self.orderlySchedulArray addObject:day];
            
            for (int i = 0; i < 7; i++) {
                
                NSMutableArray *lesson = [[NSMutableArray alloc]initWithCapacity:6];
                
                for (int j = 0; j < 6; j++) {
                    
                    [lesson addObject:[@[] mutableCopy]];
                }
                [day addObject:[lesson mutableCopy]];
            }
            classBookData = self.model.weekArray[dateNum];
            for (int i = 0; i < classBookData.count; i++) {
                
                hash_day = [classBookData[i] objectForKey:@"hash_day"];
                hash_lesson = [classBookData[i] objectForKey:@"hash_lesson"];
                
                [ day[hash_day.integerValue][hash_lesson.integerValue] addObject: classBookData[i]];
                
            }
            //如果不是整学期课表，那就加入备忘
            if (dateNum !=0) {
                NSArray *noteData = self.model.remindArray[dateNum-1];
                
                for (int i = 0; i < noteData.count; i++) {
                    
                    NSNumber *hash_day = [noteData[i] objectForKey:@"hash_day"];
                    NSNumber *hash_lesson = [noteData[i] objectForKey:@"hash_lesson"];
                    
                    [ day[hash_day.integerValue][hash_lesson.integerValue] addObject: noteData[i]];
                }
            }
//------完成对orderlySchedulArray的初始化操作，初始化后里面就是有序的整学期课表和备忘----------
            
            //左侧课条
            LeftBar *leftBar = [[LeftBar alloc] init];
            leftBar.frame = CGRectMake(0,0, MONTH_ITEM_W, leftBar.frame.size.height);
            
            
            //课表
            LessonViewForAWeek *lessonViewForAWeek = [[LessonViewForAWeek alloc] initWithDataArray:self.orderlySchedulArray[dateNum]];
            [self.lessonVCArray addObject:lessonViewForAWeek];
            
            
            lessonViewForAWeek.week = dateNum;
            lessonViewForAWeek.frame = CGRectMake(MONTH_ITEM_W+DAYBARVIEW_DISTANCE,0, lessonViewForAWeek.frame.size.width, lessonViewForAWeek.frame.size.height);
            
            
            DayBarView *dayBar;
            if(dateNum==0){
                dayBar = [[DayBarView alloc] initForWholeTerm];
            }else{
                //顶部日期条
                dayBar = [[DayBarView alloc] initWithDataArray:self.dateModel.dateArray[dateNum-1]];
            }
            [self.scrollView addSubview:dayBar];
            dayBar.frame = CGRectMake(dateNum*self.scrollView.frame.size.width,MAIN_SCREEN_W*0.1547, self.scrollView.frame.size.width, DAY_BAR_ITEM_H);
            
            
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(dateNum*self.scrollView.frame.size.width, DAY_BAR_ITEM_H+MAIN_SCREEN_W*0.1787, MAIN_SCREEN_W, MAIN_SCREEN_W*1.4)];
            [self.scrollView addSubview:scrollView];
            scrollView.backgroundColor = [UIColor clearColor];
            scrollView.showsVerticalScrollIndicator = NO;
            [scrollView addSubview:lessonViewForAWeek];
            [scrollView addSubview:leftBar];
            [scrollView setContentSize:CGSizeMake(0, lessonViewForAWeek.frame.size.height+10)];
        }
    }
    
    self.scrollView.contentOffset = CGPointMake(self.index.intValue*self.scrollView.frame.size.width,0);
}

//WYCClassAndRemindDataModel模型加载失败后调用
- (void)ModelDataLoadFailure{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
   
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"网络错误" message:@"数据加载失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [controller addAction:act1];
    
    [self presentViewController:controller animated:YES completion:^{
        
    }];
    self.scrollView.contentSize = CGSizeMake(0, self.scrollView.height + 100);
}

//初始化self.scrollView，并把它加到self.view上面
- (void)initScrollView{
    self.scrollView = [[UIScrollView alloc]init];
    [self.scrollView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView.contentSize = CGSizeMake(self.dateModel.dateArray.count * self.scrollView.frame.size.width, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.scrollView removeAllSubviews];
    [self.scrollView layoutIfNeeded];
    [self.view addSubview:self.scrollView];
}

- (void)initNavigationBar{
    //添加备忘按钮
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus"] style:UIBarButtonItemStylePlain target:self action:@selector(addNote)];
    self.navigationItem.rightBarButtonItem = right;
}

//添加备忘
- (void)addNote{
    DLReminderViewController *vc = [[DLReminderViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//WYCClassBookView的代理方法
//点击某节课后调用，出现一个显示该节课信息的弹窗
- (void)showDetail:(NSArray *)array{
    [self.detailView removeFromSuperview];
    WYCShowDetailView *detailClassBookView  = [[WYCShowDetailView alloc]init];
    detailClassBookView.chooseClassListDelegate = self;
    [detailClassBookView initViewWithArray:array];
    
    detailClassBookView.layer.shadowOffset = CGSizeMake(0, 1.5);
    detailClassBookView.layer.shadowRadius = 5;
    detailClassBookView.layer.shadowOpacity = 0.5;
    detailClassBookView.layer.cornerRadius = 8;
    
    
    [detailClassBookView setFrame:CGRectMake(0, DETAILVIEW_H, MAIN_SCREEN_W, MAIN_SCREEN_H)];
    [UIView animateWithDuration:0.5 animations:^{
        [detailClassBookView setFrame:CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_H)];
    }];
    [self.view addSubview:detailClassBookView];
    
    self.detailView = detailClassBookView;
    //添加点击手势
    UIGestureRecognizer *hiddenDetailView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenDetailView)];
    [detailClassBookView addGestureRecognizer:hiddenDetailView];
}

- (void)hiddenDetailView{
    [UIView animateWithDuration:0.3 animations:^{
        [self.detailView setFrame:CGRectMake(0, DETAILVIEW_H, MAIN_SCREEN_W, MAIN_SCREEN_H)];
    } completion:^(BOOL finished) {
        [self.detailView removeFromSuperview];
    }];
}
- (void)clickEditNoteBtn:(NSDictionary *)dic{
    [self hiddenDetailView];
    AddRemindViewController *vc = [[AddRemindViewController alloc]initWithRemind:dic];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)clickDeleteNoteBtn:(NSDictionary *)dic{
    [self hiddenDetailView];
    NSNumber *noteId = [dic objectForKey:@"id"];
    NSString *stuNum = [UserDefaultTool getStuNum];
    NSString *idNum = [UserDefaultTool getIdNum];

    WYCClassAndRemindDataModel *model = [[WYCClassAndRemindDataModel alloc]init];
    [model deleteRemind:stuNum idNum:idNum remindId:noteId];
    [self reloadView];
}


//程序回到前台时调用，在这里更新显示下节课信息的tabBar的信息
- (void)applicationWillEnterForeground:(UIApplication *)application{
    
    NSLog(@"-----back---");
    
    if([self.schedulTabBar respondsToSelector:@selector(updateSchedulTabBarViewWithDic:)]){
        [self.schedulTabBar updateSchedulTabBarViewWithDic:[self getNextLessonData]];
    }
}

/**
    返回值的结构：
    classroomLabel：教室地点
    classTimeLabel：上课时间
    classLabel：课程名称
    is:是否还有课
*/
//获取下一节有课的课在什么时候的方法
- (NSDictionary*)getNextLessonData{
    NSDictionary *nextLessonData = [self transformDataWithDict:[self getCurrentTime]];
    //下节课在（第nowWeek周）的（星期hash_day+1）的（第hash_lesson节大课）
    int hash_week,hash_day,hash_lesson;
    hash_week = self.dateModel.nowWeek.intValue+[nextLessonData[@"isNextWeek"] intValue];
    hash_day = [nextLessonData[@"hash_day"] intValue];
    hash_lesson = [nextLessonData[@"hash_lesson"]intValue];
    
    NSArray *lesson = nil;
    for (; hash_week<25; hash_week++) {
        for (; hash_day<7; hash_day++){
            for (; hash_lesson<6; hash_lesson++) {
                if([self.orderlySchedulArray[hash_week][hash_day][hash_lesson] count]!=0){
                    lesson = self.orderlySchedulArray[hash_week][hash_day][hash_lesson];
                    //找到下一节课后，用goto跳出3层循环
                    goto WYCClassBookViewControllerGetNextLessonDataBreak;
                }
            }
            hash_lesson = 0;
        }
        hash_day = 0;
    }
    hash_week = 0;
    //上面那个三层循环在找到下一节课后会用goto打断3层循环，跳到这里
WYCClassBookViewControllerGetNextLessonDataBreak:;
    NSDictionary *dataDict;
    if(lesson!=nil){
        NSArray *time = @[@"8:00 - 9:40",@"10:15 - 11:55",@"14:00 - 15:40",@"16:15 - 18:55",@"19:00 - 20:40",@"21:15 - 22:55"];
        NSDictionary *lessondata = [lesson firstObject];
        dataDict =  @{
                @"classroomLabel":time[hash_lesson],
                @"classTimeLabel":lessondata[@"classroom"],
                @"classLabel":lessondata[@"course"],
                @"is":@"1",
        };
    }else{
        //没课了
        dataDict = @{
            @"is":@"0",
        };
    }
    return dataDict;
}

/**
    返回的字典的结构：@{
    @"y":年,
    @"M":月,
    @"d":日,
    @"k":小时（24小时制）,
    @"m:分"
    @"e":周几，2～周一，1~周日，4～周3
    @"c":周几，2～周一，1~周日，4～周3
    };
*/
//获取当前时间信息的方法
- (NSDictionary *)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSArray *array = @[@"y",@"M",@"d",@"k",@"m",@"e",@"c"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *str in array) {
        [formatter setDateFormat:str];
        [dict setValue:[formatter stringFromDate:[NSDate date]]forKey:str];
    }
    return dict;
}

/**
    返回值结构：@{
    @"hash_day":星期hash_day+1,
    @"hash_lesson":第hash_lesson节大课
    @"isNextWeek"
    }
 */
//由当前的时间信息，推出下一节课在什么时候的方法，这里的下一节课可能是无课
- (NSDictionary*)transformDataWithDict:(NSDictionary*)dataDict{
    int week = [dataDict[@"e"] intValue],hour = [dataDict[@"k"] intValue],min = [dataDict[@"m"] intValue];
    int totalMin = hour*60+min;
    int a1[] = {6,0,1,2,3,4,5};
    int isNextWeek=0;//用来表示下一节课是否在下周是
    NSString *hash_day = [NSString stringWithFormat:@"%d",a1[week-1]],*hash_lesson;
    
    //这里只能用if语句来从时间推知下一节课是什么时候，不过已经用了二分查找
    if(totalMin<840){//14:00以前
        if(totalMin<480){//0:00-8:00
            hash_lesson = @"0";
        }else if(totalMin<615){//8:00-10:15
            hash_lesson = @"1";
        }else{//10:15-14;00
            hash_lesson = @"2";
        }
    }else
        if(totalMin<1240){
            if(totalMin<975){//14:00-16:15
                hash_lesson = @"3";
            }else if(totalMin<1140){//16:15-19:00
                hash_lesson = @"4";
            }else{//19:00-20:40
                hash_lesson = @"5";
            }
        }else{//20:40-23:59
            if(a1[week-1]==6){//代表是周日的20:40以后，所以下一节课在周一
                hash_day = @"0";
                isNextWeek = 1;
            }else{//非周日的20:40以后的下一节课是明天
                hash_day = [NSString stringWithFormat:@"%d",a1[week-1]+1];
            }
            hash_lesson = @"0";
        }
    
    return @{
        @"hash_day":hash_day,
        @"hash_lesson":hash_lesson,
        @"isNextWeek":[NSString stringWithFormat:@"%d",isNextWeek],
    };
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
    _index = [NSNumber numberWithInt:(int)(scrollView.contentOffset.x/MAIN_SCREEN_W)];
    self.topBarView.correctIndex = _index;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f,%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    if([scrollView isEqual:self.scrollView]){
        if(scrollView.dragging==NO&&scrollView.decelerating==NO&&scrollView.tracking==NO){
            //重写了_index的set方法，内部增加了判断，如果index超过25就让index等0，
            //也就是整学期课表的下标
            _index = [NSNumber numberWithInt:(int)(scrollView.contentOffset.x/MAIN_SCREEN_W)];
            self.topBarView.correctIndex = _index;
        }
    }
}

@end

