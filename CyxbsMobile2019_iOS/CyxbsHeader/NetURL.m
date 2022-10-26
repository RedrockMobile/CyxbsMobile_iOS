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
    .scheule = {
        .stu = @"/magipoke-jwzx/kebiao",
        .tea = @"/magipoke-teakb/api/teaKb",
        .transaction = {
            .get = @"/magipoke-reminder/Person/getTransaction",
            .add = @"/magipoke-reminder/Person/addTransaction",
            .edit = @"/magipoke-reminder/Person/editTransaction",
            .del = @"/magipoke-reminder/Person/deleteTransaction"
        }
    }
};
