//
//  LessonButtonController.h
//  Demo
//
//  Created by 李展 on 2016/11/13.
//  Copyright © 2016年 zhanlee. All rights reserved.
//

@class LessonBtnModel;
@class LessonButton;

@interface LessonButtonController : BaseViewController
@property (nonatomic, strong) LessonBtnModel *matter;
@property (nonatomic, strong) LessonButton *btn;

- (instancetype)initWithDay:(int)day Lesson:(int)lesson;
- (BOOL)matterWithWeek:(NSNumber *)week;

@end
