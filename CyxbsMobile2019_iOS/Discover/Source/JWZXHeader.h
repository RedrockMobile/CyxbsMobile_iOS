//
//  JWZXHeader.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/5/16.
//  Copyright © 2022 Redrock. All rights reserved.
//

#ifndef JWZXHeader_h
#define JWZXHeader_h

#pragma mark - UserDefault

/// 如果没有网的一条JWZX信息
#define JWZX_oneNews_String @"JWZX_oneNews"

#pragma mark - API

/**教务在线接口(HTTP)
 * @URI @{@"page" : Long}
 */
#define Discover_GET_NewsPage_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-jwzx/jwNews/list"]

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

#endif /* JWZXHeader_h */
