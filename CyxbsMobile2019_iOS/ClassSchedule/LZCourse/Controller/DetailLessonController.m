//
//  DetailLessonController.m
//  Demo
//
//  Created by 李展 on 2016/11/23.
//  Copyright © 2016年 zhanlee. All rights reserved.
//

#import "DetailLessonController.h"
#import "LessonMatter.h"
@interface DetailLessonController ()
@property LessonMatter *lesson;
@property (weak, nonatomic) IBOutlet UILabel *lessonLb;
@property (weak, nonatomic) IBOutlet UILabel *teacherLb;
@property (weak, nonatomic) IBOutlet UILabel *classroomLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *kindLb;
@property (weak, nonatomic) IBOutlet UILabel *weekLb;
@end

@implementation DetailLessonController

- (instancetype)initWithLesson:(LessonMatter *)lesson{
    self = [self init];
    if (self) {
        self.lesson = lesson;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.userInteractionEnabled = NO;
    // Do any additional setup after loading the view from its nib.
}


- (void)loadLesson{
    self.lessonLb.text = self.lesson.course;
    self.teacherLb.text = self.lesson.teacher;
    self.classroomLb.text = self.lesson.classroom;
    self.timeLb.text = [self handleTime:self.lesson];
    self.kindLb.text = self.lesson.type;
    self.weekLb.text = self.lesson.rawWeek;
    //直接在xib里完成了字体初始化;
}

- (NSString *)handleTime:(LessonMatter *)lesson{
    NSArray *beginTimes = @[@"8:00",@"8:55",@"10:15",@"11:10",@"14:00",@"14:55",@"16:15",@"17:10",@"19:00",@"19:55",@"20:50",@"21:45"];
    NSMutableArray *endTimes = [NSMutableArray array];
    for (NSString *timeString in beginTimes) {
        NSArray *tempArray = [timeString componentsSeparatedByString:@":"];
        NSInteger minute = [[tempArray firstObject] integerValue]*60.0+[[tempArray lastObject]integerValue]+45;
        NSString *endTime = [NSString stringWithFormat:@"%02d:%02d",(int)minute/60,(int)minute%60];
        [endTimes addObject:endTime];
    }
    int begin = (int)lesson.begin_lesson.integerValue;
    int end = begin+(int)lesson.period.integerValue-1;
    NSString *time = [NSString stringWithFormat:@"%@ %d-%d %@-%@",lesson.day,begin,end,beginTimes[begin-1],endTimes[end-1]];
    return time;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
