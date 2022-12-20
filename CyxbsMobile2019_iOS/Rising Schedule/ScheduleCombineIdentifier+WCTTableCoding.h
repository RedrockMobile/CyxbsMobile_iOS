//
//  ScheduleCombineIdentifier+WCTTableCoding.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/14.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCombineItemSupport.h"

#import <WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleIdentifier (WCTTableCoding) <
    WCTTableCoding
>

WCDB_PROPERTY(sno)
WCDB_PROPERTY(type)
WCDB_PROPERTY(iat)

@end

NS_ASSUME_NONNULL_END
