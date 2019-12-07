//
//  LessonMatter.h
//  Demo
//
//  Created by 李展 on 2016/11/17.
//  Copyright © 2016年 zhanlee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LessonMatter : NSObject
@property (strong, nonatomic)NSNumber *hash_day; //课程从第几天 从0开始
@property (strong, nonatomic)NSNumber *hash_lesson; //课程从第几大节开始(两小节) 从0开始
@property (strong, nonatomic)NSNumber *begin_lesson;//课程从第几节开始 1开始
@property (strong, nonatomic)NSNumber *weekBegin;//课程开始的周
@property (strong, nonatomic)NSNumber *weekEnd;//课程结束的周
@property (strong, nonatomic)NSNumber *period;//课程长度
@property (copy, nonatomic)NSArray *week;//课程的周数组
@property (copy, nonatomic)NSString *day;//星期几
@property (copy, nonatomic)NSString *lesson;//课程节数
@property (copy, nonatomic)NSString *course;//课程名称
@property (copy, nonatomic)NSString *teacher;//老师
@property (copy, nonatomic)NSString *classroom;//教室
@property (copy, nonatomic)NSString *rawWeek;//课程周期 eg：1-16
@property (copy, nonatomic)NSString *weekModel;
@property (copy, nonatomic)NSString *type;//必修 选修 重修
- (instancetype)initWithLesson:(NSDictionary *)lesson;
@end
