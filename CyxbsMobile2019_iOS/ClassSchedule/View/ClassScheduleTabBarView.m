//
//  ClassScheduleTabBarView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/3/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ClassScheduleTabBarView.h"
#import "WYCClassBookViewController.h"
#import "TransitionManager.h"
#import "FakeTabBarView.h"
@interface ClassScheduleTabBarView ()<WYCClassAndRemindDataModelDelegate>

@property (nonatomic, weak) UIView *bottomCoverView;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, weak) UIView *dragHintView;
@property (nonatomic, assign)BOOL isPresenting;
@property (nonatomic, strong)UINavigationController *nav;
@property (nonatomic,strong)UIPanGestureRecognizer *PGR;
@property (nonatomic,strong)TransitionManager *TM;
//用户的课表
@property (nonatomic, strong)WYCClassBookViewController *mySchedul;
@end

@implementation ClassScheduleTabBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"peopleListViewBackColor"];
               } else {
                  self.backgroundColor = [UIColor whiteColor];
               }
        
        self.layer.shadowOffset = CGSizeMake(0, -5);
        self.layer.shadowOpacity = 0.05;
        
        self.TM = [[TransitionManager alloc] init];
        
        // 遮住下面两个圆角
        UIView *bottomCoverView = [[UIView alloc] init];
        bottomCoverView.backgroundColor = self.backgroundColor;
        [self addSubview:bottomCoverView];
        self.bottomCoverView = bottomCoverView;
        
        UIView *dragHintView = [[UIView alloc] init];
        
        if (@available(iOS 11.0, *)) {
            dragHintView.backgroundColor = [UIColor colorNamed:@"draghintviewcolor"];
        } else {
            // Fallback on earlier versions
            dragHintView.backgroundColor = [UIColor whiteColor];
        }
        dragHintView.layer.cornerRadius = 2.5;
        [self addSubview:dragHintView];
        self.dragHintView = dragHintView;
        
        
        FYHCycleLabel *classLabel = [[FYHCycleLabel alloc] initWithFrame:CGRectMake(10, 10, 0.3*MAIN_SCREEN_W, 50)];
        classLabel.cycleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:22];
//        classLabel.cycleLabel.textColor = [UIColor blackColor];
        [self addSubview:classLabel];
        self.classLabel = classLabel;
        
        
        UIImageView *clockImageView = [[UIImageView alloc] init];
        [clockImageView setImage:[UIImage imageNamed:@"nowClassTime"]];
        [self addSubview:clockImageView];
        self.clockImageView = clockImageView;
        
        FYHCycleLabel *classTimeLabel = [[FYHCycleLabel alloc] initWithFrame:CGRectMake(10, 10, 0.2*MAIN_SCREEN_W, 50)];
        classTimeLabel.cycleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        [self addSubview:classTimeLabel];
        self.classTimeLabel = classTimeLabel;
        
        UIImageView *locationImageView = [[UIImageView alloc] init];
        [locationImageView setImage:[UIImage imageNamed:@"nowLocation"]];
        [self addSubview:locationImageView];
        self.locationImageView = locationImageView;
        
        FYHCycleLabel *classroomLabel = [[FYHCycleLabel alloc] initWithFrame:CGRectMake(10, 10, 0.2*MAIN_SCREEN_W, 50)];
        classroomLabel.cycleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        [self addSubview:classroomLabel];
        self.classroomLabel = classroomLabel;
        
        
        //加上登录成功通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initMySchedul)
            name:@"Login_LoginSuceeded" object:nil];
        
        UserItem *item = [UserItem defaultItem];
        
        //如果真实姓名非空，那么已登录
        if(item.realName!=nil||![item.realName isEqualToString:@""]){
            [self initMySchedul];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bottomCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.equalTo(@16);
    }];
    
    [self.dragHintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@27);
        make.height.equalTo(@5);
        make.top.equalTo(self).offset(8);
        make.centerX.equalTo(self);
    }];
    
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(23);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(0.3*MAIN_SCREEN_W);
        make.height.mas_equalTo(50);
    }];
    
    [self.clockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.classLabel.mas_trailing).offset(10);
        make.centerY.equalTo(self.classLabel);
        make.height.width.equalTo(@11);
    }];
    
    [self.classTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.clockImageView.mas_trailing).offset(3);
        make.centerY.equalTo(self.classLabel);
        make.width.mas_equalTo(0.25*MAIN_SCREEN_W);
        make.height.mas_equalTo(50);
    }];
    
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.classTimeLabel.mas_trailing).offset(10);
        make.centerY.equalTo(self.classLabel);
        make.height.width.equalTo(@11);
    }];
    
    [self.classroomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.locationImageView.mas_trailing).offset(3);
        make.centerY.equalTo(self.classLabel);
        make.width.mas_equalTo(0.25*MAIN_SCREEN_W);
        make.height.mas_equalTo(50);
    }];
}

/// 课表的一个代理方法，用来更新下节课信息
/// @param paramDict 下节课的数据字典
- (void)updateSchedulTabBarViewWithDic:(NSDictionary *)paramDict{
    if( [paramDict[@"is"] intValue]==1){//有下一节课
        self.classroomLabel.labelText = paramDict[@"classroomLabel"];
        self.classTimeLabel.labelText = paramDict[@"classTimeLabel"];
        self.classLabel.labelText = paramDict[@"classLabel"];
    }else{//无下一节课
        self.classroomLabel.labelText = @"无课了";
        self.classTimeLabel.labelText = @"无课了";
        self.classLabel.labelText = @"无课了";
    }
}

/// 添加一个上拉后显示弹窗的手势
- (void)addGesture{
    UIPanGestureRecognizer *PGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(presentMySchedul)];
    self.PGR = PGR;
    [self addGestureRecognizer:PGR];
}

- (void)presentMySchedul{
    if(self.PGR.state==UIGestureRecognizerStateBegan){
        self.TM.PGRToInitTransition = self.PGR;
        [self.viewController presentViewController:self.mySchedul animated:YES completion:^{
            self.TM.PGRToInitTransition = nil;
        } ];
    }
}
/// 初始化课表，课表控制器是这个类的一个属性
- (void)initMySchedul{
    
    self.mySchedul = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WYCClassBookViewController"];
    
    self.mySchedul.idNum = [UserDefaultTool getIdNum];
    
    self.mySchedul.stuNum = [UserDefaultTool getStuNum];
    
    self.mySchedul.schedulType = ScheduleTypePersonal;
    
    WYCClassAndRemindDataModel *model = [[WYCClassAndRemindDataModel alloc]init];
    
    self.mySchedul.model = model;
    
    model.delegate = self;
    
    model.writeToFile = YES;
    
    [model setValue:@"YES" forKey:@"remindDataLoadFinish"];
    
    if (self.mySchedul.stuNum) {
        [model getPersonalClassBookArrayFromNet:self.mySchedul.stuNum];
//        [model getClassBookArrayFromNet:self.mySchedul.stuNum];
    }
    
    self.mySchedul.transitioningDelegate = self.TM;
    
    [self.mySchedul setModalPresentationStyle:(UIModalPresentationCustom)];
    
    self.mySchedul.schedulTabBar = self;
    
    [self.mySchedul viewWillAppear:YES];
    
    [self addGesture];
}
- (void)ModelDataLoadFailure{
    [self.mySchedul ModelDataLoadFailure];
}

- (void)ModelDataLoadSuccess:(id)model{
    [self.mySchedul ModelDataLoadSuccess:model];
    //如果非空，那么就是选择了启动app时优先显示课表
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"Mine_LaunchingWithClassScheduleView"]){
        
        self.mySchedul.transitioningDelegate = self.TM;
        [self.mySchedul setModalPresentationStyle:(UIModalPresentationCustom)];
        self.mySchedul.fakeBar.alpha = 0;
        [self.viewController presentViewController:self.mySchedul animated:YES completion:nil];
        
    }
}

@end
