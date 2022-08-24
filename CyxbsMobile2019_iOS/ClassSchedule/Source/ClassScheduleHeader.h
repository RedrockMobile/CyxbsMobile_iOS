//
//  ClassScheduleHeader.h
//  CyxbsMobile2019_iOS
//
//  Created by 小艾同学 on 2022/7/26.
//  Copyright © 2022 Redrock. All rights reserved.
//

#ifndef ClassScheduleHeader_h
#define ClassScheduleHeader_h

// “课表”、“备忘”接口
#pragma mark - API

// 学生课表
#define RisingSchedule_POST_stuSchedule_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-jwzx/kebiao"]

// 老师课表
#define RisingSchedule_POST_teaSchedule_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-teakb/api/teaKb"]

// 请求事务
#define RisingSchedule_POST_perTransaction_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-reminder/Person/getTransaction"]

// 添加事务
#define RisingSchedule_POST_addTransaction_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-reminder/Person/addTransaction"]

// 更改事务
#define RisingSchedule_POST_editTransaction_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-reminder/Person/editTransaction"]

// 删除事务
#define RisingSchedule_POST_deleteTransaction_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-reminder/Person/deleteTransaction"]



/// 空教室接口
#define ClassSchedule_POST_emptyClass_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-jwzx/roomEmpty"]

/// 同学课表之查找同学，GET，参数：@{@"stu"]: 用来搜索的数据}
#define ClassSchedule_GET_searchPeople_API  [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-text/search/people"]

/// 查找老师，POST，参数：@{@"teaName"]: 用来搜索的数据}
#define ClassSchedule_POST_searchTeacher_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-teakb/api/teaSearch"]

//获取Store上的掌邮的版本id
//@"http://itunes.apple.com/cn/lookup?id=974026615"
#define ClassSchedule_GET_getNewVersionID_API @"http://itunes.apple.com/cn/lookup?id=974026615"

#endif /* ClassScheduleHeader_h */
