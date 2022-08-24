//
//  LessonController.m
//  Demo
//
//  Created by 李展 on 2016/10/28.
//  Copyright © 2016年 zhanlee. All rights reserved.
//

#import "LessonController.h"
#import "LessonButtonController.h"
#import "DetailViewController.h"
#import "AddRemindViewController.h"
//#import "LoginViewController.h"
#import "RemindNotification.h"
#import "UIFont+AdaptiveFont.h"
#import "MainView.h"
#import "NoLoginView.h"
#import "LZWeekScrollView.h"
#import "LessonMatter.h"
#import "RemindMatter.h"
#import "LessonBtnModel.h"
#import "LessonButton.h"
#import "掌上重邮-Swift.h"        // 将Swift中的类暴露给OC
#import "UserDefaultTool.h"

@interface LessonController ()<LZWeekScrollViewDelegate>
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) LZWeekScrollView *weekScrollView;
@property (nonatomic, strong) UIButton *barBtn;
@property (nonatomic, strong) NSMutableArray *lessonArray;
@property (nonatomic, strong) NSMutableArray *remindArray;
@property (nonatomic, strong) NSMutableArray <LessonButtonController *> *controllerArray;
@property (nonatomic, strong) UIImageView *noLessonImageView;
@property (nonatomic, strong) UIImageView *pullImageView;
@property (nonatomic, strong) NoLoginView *noLoginView;
@property (nonatomic, assign) NSInteger nowWeek;
//防止数组越界使用的nowWeek(0~20),与Userdefault中的数值不同
@property (nonatomic, strong) DetailViewController *detailViewController;
@property (nonatomic, assign) NSInteger currentSelectIndex;
@property (nonatomic, assign) BOOL isNetWorkSuccess;
@property (nonatomic, assign) CGFloat weekScrollViewHeight;

@end

@implementation LessonController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.weekScrollViewHeight = 0.06*SCREEN_HEIGHT;
    self.isNetWorkSuccess = YES;
    self.nowWeek = [[UserDefaultTool valueWithKey:@"nowWeek"] integerValue];
    if (self.nowWeek <0 ) {
        self.nowWeek = 0;
    }else if(self.nowWeek > 20){
        self.nowWeek = 20;
    }
    self.currentSelectIndex = self.nowWeek;
    NSString *stuNum = [UserDefaultTool getStuNum];
    NSString *idNum = [UserDefaultTool getIdNum];
    if (stuNum == nil || idNum == nil) {
         self.noLoginView = [[NoLoginView alloc]initWithFrame:CGRectMake(0, HEADERHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-(HEADERHEIGHT+TABBARHEIGHT))];
        [self.view addSubview:self.noLoginView];
        [self.noLoginView.loginButton addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [self afterLogin];
    }
    [self addNotification];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNotification{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(reloadView) name:@"deleteRemind" object:nil];
    [center addObserver:self selector:@selector(reloadView) name:@"addRemind" object:nil];
    [center addObserver:self selector:@selector(reloadView) name:@"editRemind" object:nil];
    [center addObserver:self selector:@selector(afterLogin) name:@"loginSuccess" object:nil];

}

- (void)reloadView{
    [self initMainView];
    [self.detailViewController reloadMatters:self.controllerArray[_currentSelectIndex].matter];
    //感觉有更好的写法 这样的写的话感觉耦合程度较高
}

- (void)clickLoginBtn{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否登录" message:@"马上登录拯救课表菌" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我再看看" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"马上登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LoginViewController *loginViewController = [[LoginViewController alloc]init];
        UINavigationController *navC =[[UINavigationController alloc]initWithRootViewController:loginViewController];

//        loginViewController.loginSuccessHandler = ^(BOOL success) {
//            if (success) {
////                [self afterLogin];
//            }
//        };
        [self.navigationController presentViewController:navC animated:YES completion:nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:loginAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (void)afterLogin{
    [self.noLoginView removeFromSuperview];
    [self request];
    [self initWeekScrollView];
    [self initNavigationBar];
    [self initMainView];
    [self reTryRequest];
}

- (void)request{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getLessonData];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getRemindData];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (self.isNetWorkSuccess) {
            [self afterRequest];
        }
        
    });
    
}

- (void)afterRequest{
   
    if ([UserDefaultTool valueWithKey:@"nowWeek"]!=nil && [UserDefaultTool valueWithKey:@"lessonResponse"]!=nil) {
        [[RemindNotification shareInstance] addNotifictaion];
        [self initWeekScrollView];
        [self initMainView];
    }
}

- (void)initWeekScrollView{
    [self.weekScrollView removeFromSuperview];
    NSMutableArray *weekArray = @[@"整学期",@"第一周",@"第二周",@"第三周",@"第四周",@"第五周",@"第六周",@"第七周",@"第八周",@"第九周",@"第十周",@"第十一周",@"第十二周",@"第十三周",@"第十四周",@"第十五周",@"第十六周",@"第十七周",@"第十八周",@"第十九周",@"第二十周"].mutableCopy;
    if (self.nowWeek>0 && self.nowWeek <=20) {
        weekArray[self.nowWeek] = @"本周";
    }
    self.weekScrollView = [[LZWeekScrollView alloc]initWithFrame:CGRectMake(0, HEADERHEIGHT, SCREEN_WIDTH, _weekScrollViewHeight) andTitles:weekArray];
    self.weekScrollView.eventDelegate = self;
    [self.weekScrollView scrollToIndex:self.nowWeek];
    [self.view addSubview:self.weekScrollView];
}


- (void)initNavigationBar{
    self.barBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, NVGBARHEIGHT*2, NVGBARHEIGHT)];
    [self.barBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.barBtn setTitle:self.weekScrollView.titles[self.currentSelectIndex] forState:UIControlStateNormal];
    [self.barBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.barBtn.titleLabel.font = [UIFont adaptFontSize:18];
    self.navigationItem.titleView = self.barBtn;
    //初始化点击Button
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    addBtn.frame = CGRectMake(0, 0, NVGBARHEIGHT/2, NVGBARHEIGHT/2);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"timeTable_image_add"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    //初始化右边添加button
    
    self.pullImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timeTable_image_pull"]];
    [self.barBtn addSubview:self.pullImageView];
    [self.pullImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.barBtn.titleLabel.mas_right).offset(5);
        make.centerY.equalTo(self.barBtn.titleLabel);
    }];
    //初始化下拉箭头
}

- (void)initMainView{
    [self.mainView removeFromSuperview];
    self.mainView = [[MainView alloc]initWithFrame:CGRectMake(0, HEADERHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-HEADERHEIGHT-TABBARHEIGHT)];
    [self.view addSubview:self.mainView]; //初始化主界面
    [self initBtnController];
    [self showMatterWithWeek:@(self.weekScrollView.currentIndex)];
}

- (void)initBtnController{
    self.lessonArray = [UserDefaultTool valueWithKey:@"lessonResponse"][@"data"];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *remindPath = [path stringByAppendingPathComponent:@"remind.plist"];
    self.remindArray = [NSMutableArray arrayWithContentsOfFile:remindPath];
    // 获取数据
    self.controllerArray = [[NSMutableArray alloc]initWithCapacity:(LONGLESSON*DAY)];
    for (int i = 0; i<DAY; i++) {
        for (int j = 0; j<LONGLESSON; j++) {
            self.controllerArray[i*LONGLESSON+j] = [[LessonButtonController alloc]initWithDay:i Lesson:j];
         [self.controllerArray[i*LONGLESSON+j].btn addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    for (NSDictionary *lessonDic in self.lessonArray) {
        LessonMatter *lesson = [[LessonMatter alloc]initWithLesson:lessonDic];
        NSInteger index = lesson.hash_day.integerValue*LONGLESSON+lesson.begin_lesson.integerValue/2;
        [self.controllerArray[index].matter.lessonArray addObject:lesson];
    }
    
    for (NSDictionary *remind in self.remindArray) {
        for (NSDictionary *date in remind[@"date"]) {
            RemindMatter *remindMatter = [[RemindMatter alloc]initWithRemind:remind];
            remindMatter.week = date[@"week"];
            remindMatter.classNum = date[@"class"];
            remindMatter.day = date[@"day"];
            NSInteger index = remindMatter.day.integerValue*LONGLESSON+remindMatter.classNum.integerValue;
            [self.controllerArray[index].matter.remindArray addObject:remindMatter];
        }
    }
    //初始化课程button
}

- (void)showMatterWithWeek:(NSNumber *)week{
    int lessonNum = 0;
    [self.noLessonImageView removeFromSuperview];
    for (LessonButtonController *controller in self.controllerArray) {
        [controller.view removeFromSuperview];
        if([controller matterWithWeek:week]){
            [self.mainView.scrollView addSubview:controller.view];
            lessonNum++;
        }
    }
    if (lessonNum == 0) {
        self.noLessonImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"无课"]];
        self.noLessonImageView.frame = CGRectMake(2*MWIDTH, SCREEN_HEIGHT/6, SCREEN_WIDTH-3*MWIDTH, SCREEN_WIDTH/2);
        [self.mainView.scrollView addSubview:self.noLessonImageView];
    }
    [self.mainView loadDayLbTimeWithWeek:week.integerValue nowWeek:[[UserDefaultTool valueWithKey:@"nowWeek"] integerValue]];
}

- (void)showDetail:(UIButton *)sender{
    self.detailViewController = [[DetailViewController alloc]initWithMatters:self.controllerArray[sender.tag].matter week:self.weekScrollView.currentIndex];
    self.currentSelectIndex = sender.tag;
    self.detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

- (void)addAction{
    AddRemindViewController *vc = [[AddRemindViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)eventWhenTapAtIndex:(NSInteger)index{
    [self.barBtn setTitle:self.weekScrollView.titles[index] forState:UIControlStateNormal];
    [self showMatterWithWeek:@(index)];
    [self clickBtn];
}


- (void)clickBtn{
    if (!self.weekScrollView.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.pullImageView.transform = CGAffineTransformMakeScale(1.0,1.0);
            self.weekScrollView.frame = CGRectMake(0, HEADERHEIGHT, SCREEN_WIDTH, 0);
            self.mainView.frame = CGRectMake(0, HEADERHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-(TABBARHEIGHT+HEADERHEIGHT));
        }completion:^(BOOL finished) {
            self.weekScrollView.hidden = YES;
        }];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            self.pullImageView.transform = CGAffineTransformMakeScale(1.0,-1.0);
            self.weekScrollView.frame = CGRectMake(0, HEADERHEIGHT, SCREEN_WIDTH, self->_weekScrollViewHeight);
            self.mainView.frame = CGRectMake(0, HEADERHEIGHT+self->_weekScrollViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-(TABBARHEIGHT+HEADERHEIGHT+_weekScrollViewHeight));
            
        }completion:^(BOOL finished) {
            self.weekScrollView.hidden = NO;
        }];
    }
}

- (void)getLessonData {
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSString *stuNum = [UserDefaultTool valueWithKey:@"stuNum"];
//    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameter = @{@"stuNum":stuNum,@"forceFetch":@"true"};
    
    [HttpTool.shareTool
     request:RisingSchedule_POST_stuSchedule_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:parameter
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        
        //NSLog(@"%@",responseObject);
        NSNumber *nowWeek = object[@"nowWeek"];
        self.nowWeek = nowWeek.integerValue;
        if (self.nowWeek <0 ) {
            self.nowWeek = 0;
        }else if(self.nowWeek > 20){
            self.nowWeek = 20;
        }
        [UserDefaultTool saveValue:nowWeek forKey:@"nowWeek"];
        [UserDefaultTool saveValue:object forKey:@"lessonResponse"];
    
        // 共享数据
        NSUserDefaults *shared = [[NSUserDefaults alloc]initWithSuiteName:kAPPGroupID];
        [shared setObject:object forKey:@"lessonResponse"];
        [shared synchronize];
        //
        dispatch_semaphore_signal(sema);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",error);
    }];
    
//    [client requestWithPath:ClassSchedule_POST_keBiao_API method:HttpRequestPost parameters:parameter prepareExecute:nil progress:^(NSProgress *progress) {
//
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        //NSLog(@"%@",responseObject);
//        NSNumber *nowWeek = responseObject[@"nowWeek"];
//        self.nowWeek = nowWeek.integerValue;
//        if (self.nowWeek <0 ) {
//            self.nowWeek = 0;
//        }else if(self.nowWeek > 20){
//            self.nowWeek = 20;
//        }
//        [UserDefaultTool saveValue:nowWeek forKey:@"nowWeek"];
//        [UserDefaultTool saveValue:responseObject forKey:@"lessonResponse"];
//
//        // 共享数据
//        NSUserDefaults *shared = [[NSUserDefaults alloc]initWithSuiteName:kAPPGroupID];
//        [shared setObject:responseObject forKey:@"lessonResponse"];
//        [shared synchronize];
//        //
//        dispatch_semaphore_signal(sema);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        dispatch_semaphore_signal(sema);
//        NSLog(@"%@",error);
//    }];
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC));
}

- (void)getRemindData{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSString *stuNum = [UserDefaultTool getStuNum];
    NSString *idNum =  [UserDefaultTool getIdNum];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *remindPath = [path stringByAppendingPathComponent:@"remind.plist"];
    
    [HttpTool.shareTool
     request:RisingSchedule_POST_perTransaction_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:@{@"stuNum":stuNum,@"idNum":idNum}
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        
        NSMutableArray *reminds = [object objectForKey:@"data"];
        [reminds writeToFile:remindPath atomically:YES];
        dispatch_semaphore_signal(sema);
        
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",error);
    }];
    
//    [client requestWithPath:ClassSchedule_POST_getRemind_API method:HttpRequestPost parameters:@{@"stuNum":stuNum,@"idNum":idNum} prepareExecute:^{
//
//    } progress:^(NSProgress *progress) {
//
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSMutableArray *reminds = [responseObject objectForKey:@"data"];
////        NSMutableArray *handledReminds = [NSMutableArray array];
////        for (NSDictionary *dic in reminds) {
////            NSMutableDictionary *newDic = dic.mutableCopy;
////            NSString *title = dic[@"title"];
////            NSString *content = dic[@"content"];
////            [newDic setObject:title forKey:@"title"];
////            [newDic setObject:content forKey:@"content"];
////            [handledReminds addObject:newDic];
////        }
//        [reminds writeToFile:remindPath atomically:YES];
//        dispatch_semaphore_signal(sema);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        dispatch_semaphore_signal(sema);
//        NSLog(@"%@",error);
//    }];
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC));
}

- (void)reTryRequest{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *failurePath = [path stringByAppendingPathComponent:@"failure.plist"];
    NSMutableArray *failureRequests = [NSMutableArray arrayWithContentsOfFile:failurePath];
    if (failureRequests.count == 0) {
        return;
    }
    else{
        NSDictionary *failure = failureRequests[0];
        NSString *type = [failure objectForKey:@"type"];
        NSMutableDictionary *parameters = [failure objectForKey:@"parameters"];
        NSError *error;
        NSArray *dateArray = [parameters objectForKey:@"date"];
        NSMutableDictionary *jsonParameters = [parameters mutableCopy];
        if (dateArray != nil) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dateArray options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            [jsonParameters setObject:jsonString forKey:@"date"];
        }
        NSMutableDictionary *realParameters;
        NSString *path = [NSString string];
        if ([type isEqualToString:@"edit"]) {
            path = RisingSchedule_POST_editTransaction_API;
            realParameters = jsonParameters;
        }
        else if ([type isEqualToString:@"delete"]) {
            path = RisingSchedule_POST_deleteTransaction_API;
            realParameters = parameters;
        }
        else if ([type isEqualToString:@"add"]) {
            path = RisingSchedule_POST_addTransaction_API;
            realParameters = jsonParameters;
        }
        
        [HttpTool.shareTool
         request:path
         type:HttpToolRequestTypePost
         serializer:HttpToolRequestSerializerHTTP
         bodyParameters:realParameters
         progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
            NSLog(@"%@",object);
            [failureRequests removeObject:failure];
            if ([failureRequests writeToFile:failurePath atomically:YES]) {
                 dispatch_async(dispatch_get_global_queue(0, 0), ^{
                     [self reTryRequest];
                 });
            }
        }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            return;
        }];
        
//        [client requestWithPath:path method:HttpRequestPost parameters:realParameters prepareExecute:^{
//
//        } progress:^(NSProgress *progress) {
//
//        } success:^(NSURLSessionDataTask *task, id responseObject) {
//            NSLog(@"%@",responseObject);
//            [failureRequests removeObject:failure];
//            if ([failureRequests writeToFile:failurePath atomically:YES]) {
//                 dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                     [self reTryRequest];
//                 });
//            }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            NSLog(@"%@",error);
//            return;
//
//        }];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
