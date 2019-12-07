//
//  LessonBtnModel.h
//  Demo
//
//  Created by 李展 on 2016/11/17.
//  Copyright © 2016年 zhanlee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RemindMatter;
@class LessonMatter;

@interface LessonBtnModel : NSObject
@property NSMutableArray <RemindMatter *> *remindArray;
@property NSMutableArray <LessonMatter *> *lessonArray;
@end
