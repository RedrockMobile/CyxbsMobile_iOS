//
//  LessonMatter.m
//  Demo
//
//  Created by 李展 on 2016/11/17.
//  Copyright © 2016年 zhanlee. All rights reserved.
//

#import "LessonMatter.h"

@implementation LessonMatter
- (instancetype)initWithLesson:(NSDictionary *)lesson{
    self = [self init];
    if (self) {
        self.hash_day = [lesson objectForKey:@"hash_day"];
        self.hash_lesson = [lesson objectForKey:@"hash_lesson"];;
        self.begin_lesson = [lesson objectForKey:@"begin_lesson"];//课程从第几节开始
        self.day = [lesson objectForKey:@"day"];//星期几
        self.lesson = [lesson objectForKey:@"lesson"];//课程节数
        self.course = [lesson objectForKey:@"course"];//课程名称
        self.teacher = [lesson objectForKey:@"teacher"];//老师
        self.classroom = [lesson objectForKey:@"classroom"];//教室
        self.rawWeek = [lesson objectForKey:@"rawWeek"];//课程周期 eg：1-16
        self.weekModel = [lesson objectForKey:@"weekModel"];
        self.weekBegin = [lesson objectForKey:@"weekBegin"];//课程开始的周
        self.weekEnd = [lesson objectForKey:@"weekEnd"];//课程结束的周
        self.type = [lesson objectForKey:@"type"];//必修 选修 重修
        self.period = [lesson objectForKey:@"period"];//课程长度
        self.week = [lesson objectForKey:@"week"];//课程的周数组
    }
    return self;
}
@end
