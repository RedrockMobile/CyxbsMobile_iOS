//
//  ClassScheduleTabBarView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/3/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ClassScheduleTabBarView.h"
#import "WYCClassBookViewController.h"
@interface ClassScheduleTabBarView ()

@property (nonatomic, weak) UIView *bottomCoverView;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, weak) UIView *dragHintView;
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
        
        UILabel *classLabel = [[UILabel alloc] init];
//        classLabel.text = @"数据结构";
//        self.classLabel.text = [dic objectForKey:@"course"];
        classLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:22];
        [self addSubview:classLabel];
        self.classLabel = classLabel;
        
        UIImageView *clockImageView = [[UIImageView alloc] init];
//        clockImageView.backgroundColor = [UIColor blueColor];
        [clockImageView setImage:[UIImage imageNamed:@"nowClassTime"]];
        [self addSubview:clockImageView];
        self.clockImageView = clockImageView;
        
        UILabel *classTimeLabel = [[UILabel alloc] init];
//        classTimeLabel.text = @"8:00 - 9:40";
        classTimeLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        [self addSubview:classTimeLabel];
        self.classTimeLabel = classTimeLabel;
        
        UIImageView *locationImageView = [[UIImageView alloc] init];
//        locationImageView.backgroundColor = [UIColor blueColor];
        [locationImageView setImage:[UIImage imageNamed:@"nowLocation"]];
        [self addSubview:locationImageView];
        self.locationImageView = locationImageView;
        
        UILabel *classroomLabel = [[UILabel alloc] init];
//        classroomLabel.text = @"综合实验楼8452";
        classroomLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        [self addSubview:classroomLabel];
        self.classroomLabel = classroomLabel;
        [self addGesture];
        
        [self initMySchedul];
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
        make.top.equalTo(self).offset(4);
        make.centerX.equalTo(self);
    }];
    
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(23);
        make.centerY.equalTo(self);
    }];
    
    [self.clockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.classLabel.mas_trailing).offset(22);
        make.centerY.equalTo(self.classLabel);
        make.height.width.equalTo(@11);
    }];
    
    [self.classTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.clockImageView.mas_trailing).offset(3);
        make.centerY.equalTo(self.classLabel);
    }];
    
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.classTimeLabel.mas_trailing).offset(22);
        make.centerY.equalTo(self.classLabel);
        make.height.width.equalTo(@11);
    }];
    
    [self.classroomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.locationImageView.mas_trailing).offset(3);
        make.centerY.equalTo(self.classLabel);
    }];
}
//dataDict =  @{
//        @"classroomLabel":time[hash_lesson],
//        @"classTimeLabel":lessondata[@"classroom"],
//        @"classLabel":lessondata[@"course"],
//        @"is":@"1",
//};
- (void)updateSchedulTabBarViewWithDic:(NSDictionary *)paramDict{
    if( [paramDict[@"is"] intValue]==1){//有下一节课
        self.classroomLabel.text = paramDict[@"classroomLabel"];
        self.classTimeLabel.text = paramDict[@"classTimeLabel"];
        self.classLabel.text = paramDict[@"classLabel"];
    }else{//无下一节课
        self.classroomLabel.text = @"无课了";
        self.classTimeLabel.text = @"无课了";
        self.classLabel.text = @"无课了";
    }
}
- (void)addGesture{
    UITapGestureRecognizer *TGR = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self.viewController presentViewController:self.mySchedul animated:YES completion:nil];
    }];
    [self addGestureRecognizer:TGR];
}
- (void)initMySchedul{
    
    self.mySchedul = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WYCClassBookViewController"];
    
    self.mySchedul.idNum = [UserDefaultTool getIdNum];
    
    self.mySchedul.stuNum = [UserDefaultTool getStuNum];
    
    self.mySchedul.schedulType = ScheduleTypePersonal;
    
    WYCClassAndRemindDataModel *model = [[WYCClassAndRemindDataModel alloc]init];
    
    self.mySchedul.model = model;
    
    model.delegate = self.mySchedul;
    
    model.writeToFile = YES;
    
    [model setValue:@"YES" forKey:@"remindDataLoadFinish"];
    
    if (self.mySchedul.stuNum) {
        [model getClassBookArrayFromNet:self.mySchedul.stuNum];
    }
    
    
    self.mySchedul.schedulTabBar = self;
    
    [self.mySchedul viewWillAppear:YES];
}
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//}
@end
