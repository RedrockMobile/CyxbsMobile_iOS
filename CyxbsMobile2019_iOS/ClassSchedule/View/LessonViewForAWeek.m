//
//  LessonViewForAWeek.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/18.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "LessonViewForAWeek.h"
#import "ClassDetailViewShower.h"
#import "DLReminderViewController.h"

@interface LessonViewForAWeek()<LessonViewAddNoteDelegate>
//@property (nonatomic,strong)UIScrollView *scrollView;

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
        
    }
    return self;
}

/// 把所有按钮的参数都配置好，并加入superView,外界调用，调用前确保self.week、self.schType已赋值
- (void)setUpUI{
    for (int i=0; i<7; i++) {
        
        NSMutableArray <LessonView*> *dayLessonViewsArray = [NSMutableArray array];
        for (int j=0; j<6; j++){
            
            NSArray *lessonDateArray = self.weekDataArray[i][j];
            
            LessonView *lessonView = [[LessonView alloc] init];
            lessonView.schType = self.schType;
            if([dayLessonViewsArray lastObject].period>2){
                lessonView.noteShowerDelegate = [dayLessonViewsArray lastObject];
            }
            if(lessonDateArray.count!=0){//非空课
                lessonView.isEmptyLesson = NO;
                lessonView.courseDataDictArray = self.weekDataArray[i][j];
            }else{//空课
                lessonView.isEmptyLesson = YES;
                lessonView.emptyClassDate = @{
                    @"hash_day":[NSNumber numberWithInt:i],
                    @"hash_lesson":[NSNumber numberWithInt:j],
                    @"period":[NSNumber numberWithInt:2],
                    @"week":[NSString stringWithFormat:@"%d",self.week],
                };
            }
            lessonView.delegate = self.detailViewShower;
            lessonView.addNoteDelegate = self;
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
    reminderVC.remind = emptyLessonData;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:reminderVC];
//    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [nav setModalPresentationStyle:(UIModalPresentationCustom)];
    [self.viewController presentViewController:nav animated:YES completion:nil];
}

-(ClassDetailViewShower *)detailViewShower{
    if(_detailViewShower==nil){
        _detailViewShower = [[ClassDetailViewShower alloc] init];
        [_detailViewShower setFrame:CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_H)];
    }
    return _detailViewShower;
}
//self.lessonViewsArray[i][j]代表(星期i+1)的(第j+1节大课)的LessonView控件

/// 由课表控制器调用，调用后根据model的信息在本周课表view的相应位置加备忘
/// @param model 数据model
- (void)addNoteLabelWithNoteDataModel:(NoteDataModel*)model{
    NSNumber *weekNum,*lessonNum;
    LessonView *lv;
    for (NSDictionary *timeDict in model.timeDictArray) {
        weekNum = timeDict[@"weekNum"];//星期weekNum
        lessonNum = timeDict[@"lessonNum"];//第lessonNum节大课
        
        //lv是周（weekNum+1），第（lessonNum+1）节大课的LessonView
        lv = self.lessonViewsArray[weekNum.intValue][lessonNum.intValue];
        //某课前面是长度为3或4的大课时，备忘信息将显示在noteShowerDelegate上
        //noteShowerDelegate设置为那节长度过长的大课
        if(lv.noteShowerDelegate!=nil)lv = lv.noteShowerDelegate;
        [lv.noteDataModelArray addObject:model];
        lv.isNoted = YES;
        [lv setUpData];
    }
}
//NoteDataModel.timeDictArray的结构：
/// @[
///     @{@"weekNum":@0,  @"lessonNum":@2},
///     @{@"weekNum":@1,  @"lessonNum":@0}
/// ]
///代表某周的周一 第3节大课和周二的第一节大课的备忘
@end
