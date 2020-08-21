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

/// 代表是第week周的课，0就是整学期
@property(nonatomic,assign)int week;
- (void)addNoteLabelWithNoteDataModel:(NoteDataModel*)model;
@end

NS_ASSUME_NONNULL_END
