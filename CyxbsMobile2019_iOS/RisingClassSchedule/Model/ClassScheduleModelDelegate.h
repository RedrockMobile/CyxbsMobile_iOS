//
//  ClassScheduleModelDelegate.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/3.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ClassScheduleModel, SchoolLesson;

@protocol ClassScheduleModelDelegate <NSObject>

- (void)handleLesson:(SchoolLesson *)lesson;

@end

NS_ASSUME_NONNULL_END
