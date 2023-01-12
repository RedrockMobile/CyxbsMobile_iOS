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

#import "ScheduleAPI.h"

extern const struct NetURL {
    // .base
    const struct Base {
        __unsafe_unretained NSString *bedev;
        __unsafe_unretained NSString *beprod;
        __unsafe_unretained NSString *cloud;
    } base;
    const struct Search {
        __unsafe_unretained NSString *stu;
    } search;
} NetURL;

#endif /* NetURL_h */
