//
//  NetURL.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "NetURL.h"

const struct NetURL NetURL = {
    .base = {
        .bedev = @"https://be-dev.redrock.cqupt.edu.cn",
        .beprod = @"https://be-prod.redrock.cqupt.edu.cn",
        .cloud =  @"https://be-prod.redrock.team"
    },
    .search = {
        .stu = @"/magipoke-text/search/people"
    },
};
