//
//  LessonViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/17.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "LessonViewController.h"
#import "LessonView.h"
#import "ClassDetailView.h"

@interface LessonViewController ()<LessonViewDelegate>
//@property (nonatomic,strong)UIScrollView *scrollView;
/// 存放所有课控件的数组，lessonViewsArray[i][j]代表(星期i+1)的(第j+1节大课)
@property(nonatomic,strong)NSMutableArray *lessonViewsArray;

/// 只显示一节课时，就用这个UIScrollView来显示多个课详情，懒加载
@property(nonatomic,strong)UIScrollView *detailScrollView;

/// 只显示一节课时，就用这个类来显示课详情，懒加载
@property(nonatomic,strong)ClassDetailView *detailView;

@property(nonatomic,strong)UIView *viewToShow;
@end

@implementation LessonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (instancetype)initWithDataArray:(NSArray*)weekDataArray{
    self = [super init];
    if(self){
        self.view.frame = CGRectMake(0, 0, 0.90315*MAIN_SCREEN_W, 1.79926*MAIN_SCREEN_W);
        
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
            lessonView.delegate = self;
            
            lessonView.courseDataDictArray = lessonDateArray;
            
            [lessonView setUpData];
            [self.view addSubview:lessonView];
            [dayLessonViewsArray addObject:lessonView];
        }
        [self.lessonViewsArray addObject:dayLessonViewsArray];
    }
}

- (void)showDetailWithCourseDataDict:(NSArray *)courseDataDictArray{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.viewToShow];
    //已经重写了self.detailView的setDataDict方法，对dataDict赋值，自动完成对内部label文字的设置
    if(courseDataDictArray.count==1){
        self.detailView.dataDict = [courseDataDictArray firstObject];
        [self.detailView setFrame:CGRectMake(0, MAIN_SCREEN_H, MAIN_SCREEN_W, DETAILVIEW_H)];
        [self.viewToShow addSubview:self.detailView ];
        [UIView animateWithDuration:0.5 animations:^{
            [self.detailView setFrame:CGRectMake(0, MAIN_SCREEN_H-DETAILVIEW_H+30, MAIN_SCREEN_W, MAIN_SCREEN_H)];
        }];
        
    }else{
        
        [self.viewToShow addSubview:self.detailView];
        
    }
    
    UITapGestureRecognizer *TGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDetail)];
    [self.viewToShow addGestureRecognizer:TGR];
}

- (void)hideDetail{
    [UIView animateWithDuration:0.3 animations:^{
        [self.viewToShow setFrame:CGRectMake(0, DETAILVIEW_H-30, MAIN_SCREEN_W, MAIN_SCREEN_H)];
    }completion:^(BOOL finished) {
        [self.viewToShow removeAllSubviews];
        [self.viewToShow removeFromSuperview];
        [self.viewToShow setFrame:CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_H)];
    }];
    
}

- (void)addNoteWithEmptyLessonData:(NSDictionary *)emptyLessonData{
    
}
- (ClassDetailView *)detailView{
    if(_detailView==nil){
        _detailView = [[ClassDetailView alloc] init];
        [_detailView setFrame:CGRectMake(0, MAIN_SCREEN_H-DETAILVIEW_H, MAIN_SCREEN_W, DETAILVIEW_H)];
    }
    return _detailView;
}

- (UIScrollView *)detailScrollView{
    if(_detailScrollView==nil){
        _detailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MAIN_SCREEN_H-DETAILVIEW_H, MAIN_SCREEN_W, DETAILVIEW_H)];
    }
    return _detailScrollView;
}
- (UIView *)viewToShow{
    if(_viewToShow==nil){
        _viewToShow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_H)];
//        _viewToShow.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.5];
    }
    return _viewToShow;
}
@end
