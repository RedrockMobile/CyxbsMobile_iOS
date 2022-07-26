//
//  CyxbsMobileURL.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/20.
//  Copyright © 2021 Redrock. All rights reserved.
//这里面放一些 接口URL的宏

#ifndef CyxbsMobileURL_h
#define CyxbsMobileURL_h



#pragma mark - 邮票中心

// 积分兑换记录, 对应 =兑换记录= 界面
#define Stamp_Store_details_exchange [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-intergral/User/exchange"]

// 积分获得信息, 对应 =获取记录= 界面
#define Stamp_store_details_getRecord [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-intergral/User/getRecord"]

//主页信息
#define Stamp_Store_Main_Page [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-intergral/User/info"]

//任务
#define TASK [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-intergral/Integral/progress"]

// 商品
#define Stamp_Store_Goods [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-intergral/Integral/getItemInfo"]
// 兑换
#define Stamp_Store_Exchange [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-intergral/Integral/purchase"]

#pragma mark - 反馈中心

// 测试环境, 请在正式环境出来的时候
// 历史反馈列表
// 参数 product_id 区分数据来源, 掌邮只填1
#define FeedBack_Center_History_List [CyxbsMobileBaseURL_1 stringByAppendingString:@"feedback-center/feedback/list"]

// 历史反馈页, 点击一个进入详情
// 参数 feedback_id 信息的id
// 参数 product_id 区分数据来源, 掌邮只填1
#define FeedBack_Center_History_View [CyxbsMobileBaseURL_1 stringByAppendingString:@"feedback-center/feedback/view"]

//常见问题
#define COMMON_QUESTION [CyxbsMobileBaseURL_1 stringByAppendingString:@"feedback-center/question/list?product_id=1"]

//提交反馈
#define SUBMIT [CyxbsMobileBaseURL_1 stringByAppendingString:@"feedback-center/feedback/create?product_id=1"]

#endif /* CyxbsMobileURL_h */
