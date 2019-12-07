//
//  DetailLessonController.h
//  Demo
//
//  Created by 李展 on 2016/11/23.
//  Copyright © 2016年 zhanlee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LessonMatter;

@interface DetailLessonController : BaseViewController
- (instancetype)initWithLesson:(LessonMatter *)lesson;
- (void)loadLesson;
@end
