//
//  ScheduleAPI.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/20.
//  Copyright © 2022 Redrock. All rights reserved.
//

#ifndef ScheduleAPI_h
#define ScheduleAPI_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: API

extern const struct Schedule {
    NSString *stu;
    NSString *tea;
    // .transaction
    const struct Transaction {
        NSString *get;
        NSString *add;
        NSString *edit;
        NSString *del;
    } transaction;
} scheule;

NS_ASSUME_NONNULL_END

#endif /* ScheduleAPI_h */
