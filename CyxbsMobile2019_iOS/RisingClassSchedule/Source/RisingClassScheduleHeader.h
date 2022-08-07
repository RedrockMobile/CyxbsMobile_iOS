//
//  RisingClassScheduleHeader.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/2.
//  Copyright © 2022 Redrock. All rights reserved.
//

#ifndef RisingClassScheduleHeader_h
#define RisingClassScheduleHeader_h

/// 25周
#define RisingClassSchedule_section 25

// 8周（为了下标对应）
#define RisingClassSchedule_week 8

// 13节课（为了下标对应）
#define RisingClassSchedule_perItem 13

#define RisingClassSchedule

#pragma mark - User Default

/// 课程是从哪一天开始的
#define RisingClassSchedule_classBegin_String @"RisingClassSchedule_classBegin"

/// 当前所在周（避免计算）
#define RisingClassSchedule_nowWeek_String @"RisingClassSchedule_nowWeek"

/// 双人课表中，另一个人的学号
#define RisingClassSchedule_coupleNum_String @"RisingClassSchedule_coupleNum"

#endif /* RisingClassScheduleHeader_h */
