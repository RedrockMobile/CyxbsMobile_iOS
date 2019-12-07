//
//  DetailViewController.m
//  Demo
//
//  Created by 李展 on 2016/11/20.
//  Copyright © 2016年 zhanlee. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailPageController.h"
#import "DetailRemindViewController.h"
#import "LessonBtnModel.h"
#import "RemindMatter.h"
#import "LessonMatter.h"
@interface DetailViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) LessonBtnModel *matters;
@property (nonatomic, assign) NSInteger week;
@property (nonatomic, strong) DetailPageController *detailPageController;
@property (nonatomic, strong) DetailRemindViewController *remindController;
@property (nonatomic, strong) UIBarButtonItem *editItem;
@property (nonatomic, assign) BOOL isFirstEnter;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = self.segmentedControl;
    [self.segmentedControl addTarget:self action:@selector(action:) forControlEvents:UIControlEventValueChanged];
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self.remindController didMoveToParentViewController:self];
    self.isFirstEnter = YES;
    [self showLessonView];
}

- (instancetype)initWithMatters:(LessonBtnModel *)matters week:(NSInteger)week{
    self = [self init];
    if(self){
        self.week = week;
        self.matters = matters;
        //        self.time = time;
        NSArray *array = @[@"课程",@"事项"];
        self.segmentedControl = [[UISegmentedControl alloc]initWithItems:array];
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)action:(UISegmentedControl *)segement{
    NSString *string = [segement titleForSegmentAtIndex:segement.selectedSegmentIndex];
    self.navigationItem.rightBarButtonItem = nil;
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    if ([string isEqualToString:@"课程"]) {
        [self showLessonView];
    }
    else if([string isEqualToString:@"事项"]){
        [self showRemindView];
    }
}

- (void)showLessonView{
    BOOL isHaveLessson = NO;
    if (self.week == 0) {
        if (self.matters.lessonArray.count != 0) {
            isHaveLessson = YES;
            self.detailPageController = [[DetailPageController alloc]initWithLessonMatters:self.matters.lessonArray];
        }
    } //整学期
    else{
        NSMutableArray *lessonArray = [NSMutableArray array];
        for (LessonMatter *lesson in self.matters.lessonArray) {
            if([lesson.week containsObject:@(self.week)]){
                [lessonArray addObject:lesson];
                isHaveLessson = YES;
//                break;
            }
        }
        if(lessonArray.count >0){
            self.detailPageController = [[DetailPageController alloc]initWithLessonMatters:lessonArray];
        }
    } //具体周
    if (!isHaveLessson) {
        if (self.isFirstEnter) {
            self.segmentedControl.selectedSegmentIndex = 1;
            [self showRemindView];
            self.isFirstEnter = NO;
            return;
        }
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(MWIDTH, SCREEN_HEIGHT/6+STATUSBARHEIGHT+NVGBARHEIGHT, SCREEN_WIDTH-2*MWIDTH, SCREEN_WIDTH/2)];
        imageView.image = [UIImage imageNamed:@"无课"];
        [self.view addSubview:imageView];
        return;
    }
    [self addChildViewController:self.detailPageController];
    [self.view addSubview:self.detailPageController.view];
    [self.detailPageController didMoveToParentViewController:self];
}

- (void)showRemindView{
    BOOL ishaveRemind = NO;
    if (self.week == 0) {
        if (self.matters.remindArray.count != 0) {
             self.remindController = [[DetailRemindViewController alloc]initWithRemindMatters:self.matters.remindArray];
            ishaveRemind = YES;
        }
    }
    else {
        NSMutableArray *remindArray = [NSMutableArray array];
        for (RemindMatter *remind in self.matters.remindArray) {
            if([remind.week containsObject:@(self.week)]){
                [remindArray addObject:remind];
                ishaveRemind = YES;
            }
        }
        self.remindController = [[DetailRemindViewController alloc]initWithRemindMatters:remindArray];
    }
    if(!ishaveRemind){
        self.remindController = [[DetailRemindViewController alloc]initWithRemindMatters:nil];
    }
    [self addChildViewController:self.remindController];
    [self.view addSubview:self.remindController.view];
    
    UIImageView *imageView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"remind_image_editing"]];
    UIButton *btn = [[UIButton alloc]initWithFrame:imageView.frame];
    [btn setBackgroundImage:imageView.image forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"remind_image_edit"] forState:UIControlStateSelected];
    [btn addTarget:self.remindController action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    self.editItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    if (ishaveRemind) {
        self.navigationItem.rightBarButtonItem = self.editItem;
    }
}


- (void)reloadMatters:(LessonBtnModel *)matters{
    self.matters = matters;
    if (self.week == 0) {
        [self.remindController reloadWithRemindMatters:matters.remindArray];
    }
    else {
        NSMutableArray *remindArray = [NSMutableArray array];
        for (RemindMatter *remind in self.matters.remindArray) {
            if([remind.week containsObject:@(self.week)]){
                [remindArray addObject:remind];
            }
        }
        [self.remindController reloadWithRemindMatters:remindArray];
    }
}

@end
