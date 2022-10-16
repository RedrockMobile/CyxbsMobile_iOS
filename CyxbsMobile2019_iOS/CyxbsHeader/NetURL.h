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

typedef NSString * REDROCK_ENVIRONMENT_URL NS_STRING_ENUM;

FOUNDATION_EXPORT REDROCK_ENVIRONMENT_URL const REDROCK_ENVIRONMENT_BEDEV;
FOUNDATION_EXPORT REDROCK_ENVIRONMENT_URL const REDROCK_ENVIRONMENT_BEPROD;
FOUNDATION_EXPORT REDROCK_ENVIRONMENT_URL const REDROCK_ENVIRONMENT_CLOUD;

REDROCK_ENVIRONMENT_URL const __system_check_url__(void);

#define CyxbsMobileBaseURL_1 @""

#import "RisingScheduleHeader.h"

#endif /* NetURL_h */
