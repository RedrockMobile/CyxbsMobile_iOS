//
//  ScheduleCourse+WCTTableCoding.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/23.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCourse.h"

#import <WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleCourse (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(inSection)
WCDB_PROPERTY(period_location)
WCDB_PROPERTY(period_lenth)

WCDB_PROPERTY(course)
WCDB_PROPERTY(courseNike)
WCDB_PROPERTY(classRoom)
WCDB_PROPERTY(classRoomNike)

WCDB_PROPERTY(courseID)
WCDB_PROPERTY(rawWeek)
WCDB_PROPERTY(type)

WCDB_PROPERTY(sno)
WCDB_PROPERTY(teacher)
WCDB_PROPERTY(lesson)

@end

NS_ASSUME_NONNULL_END
