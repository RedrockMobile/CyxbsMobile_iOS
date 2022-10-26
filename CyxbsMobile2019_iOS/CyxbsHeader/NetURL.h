//
//  NetURL.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

#ifndef NetURL_h
#define NetURL_h

#import <Foundation/Foundation.h>

extern const struct NetURL {
    // .base
    const struct Base {
        __unsafe_unretained NSString *bedev;
        __unsafe_unretained NSString *beprod;
        __unsafe_unretained NSString *cloud;
    } base;
    // .schedule
    const struct Schedule {
        __unsafe_unretained NSString *stu;
        __unsafe_unretained NSString *tea;
        // .transaction
        const struct Transaction {
            __unsafe_unretained NSString *get;
            __unsafe_unretained NSString *add;
            __unsafe_unretained NSString *edit;
            __unsafe_unretained NSString *del;
        } transaction;
    } scheule;
} NetURL;

#import "RisingScheduleHeader.h"

#endif /* NetURL_h */
