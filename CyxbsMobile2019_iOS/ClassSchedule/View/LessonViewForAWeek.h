//
//  LessonViewForAWeek.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/18.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LessonView.h"
NS_ASSUME_NONNULL_BEGIN

@interface LessonViewForAWeek : UIView
- (instancetype)initWithDataArray:(NSArray*)dataArray;
@property(nonatomic,strong)NSArray *weekDataArray;

/// 存放所有课控件的数组，lessonViewsArray[i][j]代表(星期i+1)的(第j+1节大课)
@property(nonatomic,strong)NSMutableArray *lessonViewsArray;

@property(nonatomic,assign)ScheduleType schType;
/// 代表是第week周的课，0就是整学期
@property(nonatomic,assign)int week;
- (void)addNoteLabelWithNoteDataModel:(NoteDataModel*)model;
//调用前确保self.week、self.schType已赋值
- (void)setUpUI;
@end

NS_ASSUME_NONNULL_END
