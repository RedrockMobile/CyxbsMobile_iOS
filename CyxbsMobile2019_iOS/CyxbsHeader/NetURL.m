//
//  NetURL.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "NetURL.h"

REDROCK_ENVIRONMENT_URL const REDROCK_ENVIRONMENT_BEDEV = @"https://be-dev.redrock.cqupt.edu.cn/";
REDROCK_ENVIRONMENT_URL const REDROCK_ENVIRONMENT_BEPROD = @"https://be-prod.redrock.cqupt.edu.cn/";
REDROCK_ENVIRONMENT_URL const REDROCK_ENVIRONMENT_CLOUD = @"https://be-prod.redrock.team/";

REDROCK_ENVIRONMENT_URL const __system_check_url__(void) {
#ifdef DEBUG
    return REDROCK_ENVIRONMENT_BEDEV;
#else
    return REDROCK_ENVIRONMENT_BEPROD;
#endif
}
