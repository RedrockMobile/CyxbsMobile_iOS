//
//  LessonViewForAWeek.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/18.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "LessonViewForAWeek.h"
#import "LessonView.h"
#import "ClassDetailViewShower.h"
#import "DLReminderViewController.h"

@interface LessonViewForAWeek()<LessonViewAddNoteDelegate>
//@property (nonatomic,strong)UIScrollView *scrollView;
/// 存放所有课控件的数组，lessonViewsArray[i][j]代表(星期i+1)的(第j+1节大课)
@property(nonatomic,strong)NSMutableArray *lessonViewsArray;

/// 用这个类来显示课详情，懒加载
@property(nonatomic,strong)ClassDetailViewShower *detailViewShower;


@end


@implementation LessonViewForAWeek

- (instancetype)initWithDataArray:(NSArray*)weekDataArray{
    self = [super init];
    if(self){
        self.frame = CGRectMake(0, 0, 0.90315*MAIN_SCREEN_W, 1.79926*MAIN_SCREEN_W);
        
        self.weekDataArray = weekDataArray;
        
        self.lessonViewsArray = [NSMutableArray array];
        
        [self setUpUI];
    }
    return self;
}

/// 把所有按钮的参数都配置好，并加入superView
- (void)setUpUI{
    for (int i=0; i<7; i++) {
        
        NSMutableArray *dayLessonViewsArray = [NSMutableArray array];
        for (int j=0; j<6; j++){
            
            NSArray *lessonDateArray = self.weekDataArray[i][j];
            
            LessonView *lessonView = [[LessonView alloc] init];;
            
            if(lessonDateArray.count!=0){//非空课
                lessonView.isEmptyLesson = NO;
            }else{//空课
                lessonView.isEmptyLesson = YES;
                lessonDateArray = @[@{
                    @"hash_day":[NSNumber numberWithInt:i],
                    @"hash_lesson":[NSNumber numberWithInt:j],
                    @"period":[NSNumber numberWithInt:2],
                    @"week":[NSString stringWithFormat:@"%d",self.week],
                }];
            }
            lessonView.delegate = self.detailViewShower;
            lessonView.addNoteDelegate = self;
            lessonView.courseDataDictArray = lessonDateArray;
            
            [lessonView setUpData];
            [self addSubview:lessonView];
            [dayLessonViewsArray addObject:lessonView];
        }
        [self.lessonViewsArray addObject:dayLessonViewsArray];
    }
}
//emptyLessonData 结构：
//@"hash_day":[NSNumber numberWithInt:i],
//@"hash_lesson":[NSNumber numberWithInt:j],
//@"period":[NSNumber numberWithInt:2],
//@"week":[NSString stringWithFormat:@"%d",self.week],
- (void)addNoteWithEmptyLessonData:(NSDictionary *)emptyLessonData{
    DLReminderViewController *reminderVC = [[DLReminderViewController alloc] init];
    //发送通知，让ClassScheduleTabBarView.VC把课表控制器disMiss
    //disMiss后，ClassScheduleTabBarView会再发送叫@"pushReminderVC"的通知
    //让DiscoverViewController.navgationVC push reminderVC
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disMissSchedul_pushReminderVC" object:reminderVC];
}

-(ClassDetailViewShower *)detailViewShower{
    if(_detailViewShower==nil){
        _detailViewShower = [[ClassDetailViewShower alloc] init];
        [_detailViewShower setFrame:CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_H)];
    }
    return _detailViewShower;
}
@end
