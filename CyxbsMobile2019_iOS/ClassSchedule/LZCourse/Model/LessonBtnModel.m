//
//  LessonBtnModel.m
//  Demo
//
//  Created by 李展 on 2016/11/17.
//  Copyright © 2016年 zhanlee. All rights reserved.
//

#import "LessonBtnModel.h"
#import "LessonMatter.h"
#import "RemindMatter.h"
@implementation LessonBtnModel
- (instancetype)init{
    self = [super init];
    if (self) {
        self.lessonArray = [NSMutableArray array];
        self.remindArray = [NSMutableArray array];
    }
    return self;
}
@end
