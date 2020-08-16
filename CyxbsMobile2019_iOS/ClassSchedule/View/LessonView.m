//
//  LessonView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/17.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "LessonView.h"
@interface LessonView()

/// 课程名称
@property(nonatomic,strong)UILabel *courseNameLabel;

/// 教室名
@property(nonatomic,strong)UILabel *classroomNameLabel;

/// 课程时长
@property(nonatomic,assign)int period;

/// 周几的课，hash_day=3代表周四
@property(nonatomic,assign)int hash_day;

/// 第几节大课，hash_lesson=2代表第3节大课，也就是5-6节
@property(nonatomic,assign)int hash_lesson;

@end
@implementation LessonView

/// 通过信息字典初始化这个类
/// @param courseDataDict 这节课的信息字典
- (instancetype)initWithDataDict:(NSDictionary*)courseDataDict{
    self = [super init];
    if(self){
        self.courseDataDict = courseDataDict;
        [self setUpUI];
        [self setUpData];
    }
    return self;
}
- (void)setUpUI{
    self.layer.cornerRadius = 4;
    self.courseNameLabel = [[UILabel alloc] init];
    self.courseNameLabel.font = [UIFont fontWithName:@".PingFang SC" size: 11];
    
    self.classroomNameLabel = [[UILabel alloc] init];
    self.classroomNameLabel.font = [UIFont fontWithName:@".PingFang SC" size: 11];
}
- (void)setUpData{
    self.courseNameLabel.text = self.courseDataDict[@"course"];
    self.classroomNameLabel.text = self.courseDataDict[@"classroom"];
    
    
    NSString *hash_day = self.courseDataDict[@"hash_day"];
    self.hash_day = [hash_day intValue];
    
    NSString *hash_lesson = self.courseDataDict[@"hash_lesson"];
    self.hash_lesson = [hash_lesson intValue];
    
    NSString *period = self.courseDataDict[@"period"];
    self.period = [period intValue];
    
    UIColor *textColor;
    switch (self.hash_lesson) {
        case 0:
        case 1:
            if(@available(iOS 11.0, *)){
                self.backgroundColor = [UIColor colorNamed:@"hash_lesson.integerValue<2"];
                textColor = [UIColor colorNamed:@"ClassLabelColor1"];
            }else{
                self.backgroundColor = [UIColor colorWithRed:249/255.0 green:231/255.0 blue:216/255.0 alpha:1.0];
                textColor = [UIColor colorWithRed:255/255.0 green:128/255.0 blue:21/255.0 alpha:1.0];
            }
            break;
            
            
        case 2:
        case 3:
        if(@available(iOS 11.0, *)){
            self.backgroundColor = [UIColor colorNamed:@"hash_lesson.integerValue>=2&&hash_lesson.integerValue<4"];
            textColor = [UIColor colorNamed:@"ClassLabelColor2"];
        }else{
            self.backgroundColor = [UIColor colorWithRed:249/255.0 green:227/255.0 blue:228/255.0 alpha:1.0];
            textColor = [UIColor colorWithRed:255/255.0 green:98/255.0 blue:98/255.0 alpha:1.0];
        }
        break;
        
            
        default:
            if(@available(iOS 11.0, *)){
                self.backgroundColor = [UIColor colorNamed:@"hash_lesson.integerValue>4"];
                textColor = [UIColor colorNamed:@"ClassLabelColor3"];
            }else{
                self.backgroundColor = [UIColor colorWithRed:221/255.0 green:227/255.0 blue:248/255.0 alpha:1.0];
                textColor = [UIColor colorWithRed:64/255.0 green:102/255.0 blue:234/255.0 alpha:1.0];
            }
            break;
    }
    self.courseNameLabel.textColor = textColor;
    self.classroomNameLabel.textColor = textColor;
}
@end
//"begin_lesson" = 1;
//教室                                classroom = 2217;
//课程名称                        course = "高等数学A(下)";
//                                    "course_num" = A1110310;
//                                    day = "星期一";
//周几的课                        "hash_day" = 0;
//从第几节开始上                  "hash_lesson" = 0;
//                                    lesson = "一二节";
//这节课的时长                    period = 2;
//                                    rawWeek = "3-17周";
//                                    teacher = "邓志颖";
//                                    type = "必修";
//  那些周有课                    week =         (
//                                                            3,
//                                                          5,
//                                                            7,
//                                                            9,
//                                                            11,
//                                                            13,
//                                                            15,
//                                                            17
//                                                  );
//                                        weekBegin = 3;
//                                        weekEnd = 17;
//                                        weekModel = single;
