//
//  ClassScheduleHeader.h
//  CyxbsMobile2019_iOS
//
//  Created by 小艾同学 on 2022/7/26.
//  Copyright © 2022 Redrock. All rights reserved.
//

#ifndef ClassScheduleHeader_h
#define ClassScheduleHeader_h

#pragma mark - UserDefault
// 是否关联同学课表
#define ClassSchedule_correlationClass_BOOL @"ClassSchedule_correlationClass"
// 名字
#define ClassSchedule_correlationName_String @"ClassSchedule_correlationName"
// 专业
#define ClassSchedule_correlationMajor_String @"ClassSchedule_correlationMajor"
// 学号
#define ClassSchedule_correlationStuNum_String @"ClassSchedule_correlationStuNum"


// “课表”、“备忘”接口
#pragma mark - API

//查课表数据，POST，参数：@{@"stu_num"]:学号}
#define ClassSchedule_POST_keBiao_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-jwzx/kebiao"]

//加备忘，POST
#define ClassSchedule_POST_addRemind_API @"https://cyxbsmobile.redrock.team/cyxbsMobile/index.php/Home/Person/addTransaction"

//获得备忘，POST
#define ClassSchedule_POST_getRemind_API @"https://cyxbsmobile.redrock.team/cyxbsMobile/index.php/Home/Person/getTransaction"

//编辑备忘，POST
#define ClassSchedule_POST_editRemind_API @"https://cyxbsmobile.redrock.team/cyxbsMobile/index.php/Home/Person/editTransaction"

//删除备忘，POST
#define ClassSchedule_POST_deleteRemind_API @"https://cyxbsmobile.redrock.team/cyxbsMobile/index.php/Home/Person/deleteTransaction"

//查老师课表数据，POST，参数： @{ @"teaName": 姓名, @"tea": 工号？}
#define ClassSchedule_POST_teaKeBiao_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-teakb/api/teaKb"]

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
