//
//  LessonView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/17.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
//一节小课的宽度
#define LESSON_W (MAIN_SCREEN_W*0.1253)
//一节小课的高度
#define LESSON_H (LESSON_W*1.1702)

#define DISTANCE_W (MAIN_SCREEN_W*0.0053)

#define DISTANCE_H (DISTANCE_W*1.5)
NS_ASSUME_NONNULL_BEGIN

@protocol LessonViewDelegate <NSObject>
- (void)showDetailWithCourseDataDict:(NSArray*)courseDataDictArray;
- (void)hideDetail;
- (void)addNoteWithEmptyLessonData:(NSDictionary*)emptyLessonData;
@end

@interface LessonView : UIView

/// 这节课的信息字典，空课的结构：dict = @{
//    @"hash_day":0,
//    @"hash_lesson":2,
//    @"period":2,
//    @"week":第week周的空课，week代表整学期
//};
@property(nonatomic,strong)NSDictionary *courseDataDict;
@property(nonatomic,strong)NSArray *courseDataDictArray;
/// 是不是一节空课
@property(nonatomic,assign)BOOL isEmptyLesson;

@property(nonatomic,weak)id<LessonViewDelegate>delegate;

/// 更新数据，调用前需确保已经对self.courseDataDict进行更新
- (void)setUpData;

@end

NS_ASSUME_NONNULL_END
//这个类的用法：

//1.
//  LessonView *lessonView = [[LessonView alloc] init];

//2.
//  lessonView.isEmptyLesson = NO;


//3.
//NSArray *dictArray = @[@{
//        @"hash_day":[NSNumber numberWithInt:i],
//        @"hash_lesson":[NSNumber numberWithInt:j],
//        @"period":[NSNumber numberWithInt:2],
//        @"week":[NSString stringWithFormat:@"%d",self.week],
//    }];
//}

//4.
//lessonView.delegate = self;

//5.
//lessonView.courseDataDict = dictArray;

//6.
//[lessonView setUpData];

//7.
//[self.view addSubview:lessonView];

