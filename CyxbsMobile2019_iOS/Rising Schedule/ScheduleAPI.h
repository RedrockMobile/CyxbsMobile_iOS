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

/**MARK: API
 * API Supported but without base URL.
 * use like \c scheule.stu
 * See https://metersphere.redrock.team/#/api/definition
 */

extern const struct Schedule {
    NSString *stu; // POST
    NSString *tea; // POST
    // .transaction
    const struct Transaction {
        NSString *get; // POST
        NSString *add; // POST
        NSString *edit; // POST
        NSString *del; // POST
    } transaction;
} scheule;

NS_ASSUME_NONNULL_END

#endif /* ScheduleAPI_h */
