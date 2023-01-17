//
//  ScheduleAPI.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/20.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleAPI.h"

const struct Schedule scheule = {
    .stu = @"/magipoke-jwzx/kebiao",
    .tea = @"/magipoke-teakb/api/teaKb",
    .transaction = {
        .get = @"/magipoke-reminder/Person/getTransaction",
        .add = @"/magipoke-reminder/Person/addTransaction",
        .edit = @"/magipoke-reminder/Person/editTransaction",
        .del = @"/magipoke-reminder/Person/deleteTransaction"
    }
};
