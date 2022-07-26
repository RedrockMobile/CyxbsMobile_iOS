//
//  DiscoverHeader.h
//  CyxbsMobile2019_iOS
//
//  Created by 小艾同学 on 2022/7/26.
//  Copyright © 2022 Redrock. All rights reserved.
//

#ifndef DiscoverHeader_h
#define DiscoverHeader_h

#pragma mark - API

#pragma mark - “发现”接口

// MARK: MineMessage

// 负责人：SSR

/**获取所有信息
 * @Header Authorization : Bearer ${token}
 */
#define Discover_GET_allMsg_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"message-system/user/allMsg"]

/**更改已读状态
 * @Header Content-Type : application//json
 * @Header Authorization : Bearer ${token}
 * @Body @ {"ids" : [String]}
 */
#define Discover_PUT_hasRead_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"message-system/user/msgHasRead"]

/**是否有未读消息
 * @Header Authorization : Bearer ${token}
 */
#define Discover_GET_userHadRead_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"message-system/user/msgHasRead"]

/**删除消息
 * @Header Authorization : Bearer ${token}
 * @Body @ {"ids" : [String]}
 */
#define Discover_DELETE_sysMsg_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"message-system/user/msg"]

/**单个md文档转为h5
 * WKWebView
 */
#define Discover_HTML_md_API(msgID) [CyxbsMobileBaseURL_1 stringByAppendingFormat:@"message-system/user/html/%@", msgID]

// MARK: JWZX

// 负责人： SSR

/**教务在线接口(HTTP)
 * @URI @{@"page" : Long}
 */
#define Discover_GET_NewsPage_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-jwzx/jwNews/list"]

# pragma mark - ###

//校历接口
#define Discover_schoolCalendar_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-jwzx/schoolCalendar"]


/// 教务新闻列表。未使用
///参数：page
///方法：Get
//#define Discover_GET_newsList_API @"https://be-prod.redrock.team/magipoke-jwzx/jwNews/list"
#define Discover_GET_newsList_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-jwzx/jwNews/list"]

/// 教务新闻详情
///方法：Get
///参数：新闻id
#define Discover_GET_newsDetail_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-jwzx/jwNews/content"]

/// 教务新闻附件。未使用
/// 方法：Get
///参数：附件的id
#define Discover_GET_newsFile_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-jwzx/jwNews/file"]

//在NewDetailViewController要单独改一下
/// 电费
#define Discover_POST_electricFee_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-elecquery/getElectric"]


///查询绩点需要先绑定ids
#define Discover_POST_idsBinding_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke/ids/bind"]

///绩点查询
#define Discover_GET_GPA_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke/gpa"]

/// 考试安排接口
#define Discover_POST_examArrange_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-jwzx/examSchedule"]
                   
#define Discover_GET_examModel_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-jwzx/nowStatus"]

/// 校车位置
#define Discover_POST_schoolBus_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"schoolbus/status"]

/// banner
#define Discover_GET_bannerView_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-text/banner/get"]

/// 志愿查询
#define Discover_POST_volunteerBind_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"volunteer-message/binding"]

#define Discover_POST_volunteerRequest_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"volunteer-message/select"]

#define Discover_POST_volunteerBinding_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"volunteer-message/unbinding"]

#define Discover_GET_volunteerActivity_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"/cyb-volunteer/volunteer/activity/info/new"]

#endif /* DiscoverHeader_h */
