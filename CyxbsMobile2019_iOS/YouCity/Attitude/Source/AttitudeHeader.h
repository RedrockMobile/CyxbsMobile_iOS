//
//  AttitudeHeader.h
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/7.
//  Copyright © 2023 Redrock. All rights reserved.
//

#ifndef AttitudeHeader_h
#define AttitudeHeader_h
// "表态"接口
#pragma mark - API

// 获取表态主页数据
#define Attitude_GET_homePageData_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-attitude/declare/homepage"]

// 获取表态页详细信息
#define Attitude_GET_expressDetailData_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-attitude/declare"]

// 表态投票
#define Attitude_PUT_expressPickData_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-attitude/declare"]

// 表态撤销投票
#define Attitude_DELETE_expressDeletePick_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-attitude/declare"]

#endif /* AttitudeHeader_h */
