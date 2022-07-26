//
//  CyxbsMobileURL.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/20.
//  Copyright © 2021 Redrock. All rights reserved.
//这里面放一些 接口URL的宏

#ifndef CyxbsMobileURL_h
#define CyxbsMobileURL_h


#pragma mark - ”重邮地图“接口

/// 重邮地图历史记录偏好设置Key
#define Discover_cquptMapHistoryKey_String @"MapSearchHistory"

/// 重邮地图主页
#define Discover_GET_cquptMapBasicData_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-stumap/basic"]
/// 重邮地图热搜
#define Discover_GET_cquptMapHotPlace_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-stumap/button"]
/// 重邮地图：我的收藏
#define Discover_GET_cquptMapMyStar_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-stumap/rockmap/collect"]
/// 重邮地图：搜索地点
#define Discover_POST_cquptMapSearch_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-stumap/placesearch"]
/// 重邮地图：地点详情
#define Discover_POST_cquptMapPlaceDetail_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-stumap/detailsite"]
/// 重邮地图：上传图片
#define Discover_POST_cquptMapUploadMage_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-stumap/rockmap/upload"]
/// 重邮地图：添加收藏
#define Discover_PATCH_cquptMapAddCollect_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-stumap/rockmap/addkeep"]
/// 重邮地图：删除收藏
#define Discover_POST_cquptMapDeleteCollect_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-stumap/rockmap/delete"]



#pragma mark - “课表”、“备忘”接口

//查课表数据，GET，参数：@{@"stu_num"]:学号}
#define kebiaoAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-jwzx/kebiao"]

//加备忘，POST
#define ADDREMINDAPI @"https://cyxbsmobile.redrock.team/cyxbsMobile/index.php/Home/Person/addTransaction"

//获得备忘，POST
#define GETREMINDAPI @"https://cyxbsmobile.redrock.team/cyxbsMobile/index.php/Home/Person/getTransaction"

//编辑备忘，POST
#define EDITREMINDAPI @"https://cyxbsmobile.redrock.team/cyxbsMobile/index.php/Home/Person/editTransaction"

//删除备忘，POST
#define DELETEREMINDAPI @"https://cyxbsmobile.redrock.team/cyxbsMobile/index.php/Home/Person/deleteTransaction"

//查老师课表数据，POST，参数： @{ @"teaName": 姓名, @"tea": 工号？}
#define TEAkebiaoAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-teakb/api/teaKb"]

/// 空教室接口
#define EMPTYCLASSAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-jwzx/roomEmpty"]

/// 同学课表之查找同学，GET，参数：@{@"stu"]: 用来搜索的数据}
#define SEARCHPEOPLEAPI  [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-text/search/people"]

/// 查找老师，POST，参数：@{@"teaName"]: 用来搜索的数据}
#define SEARCHTEACHERAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-teakb/api/teaSearch"]



#pragma mark - “邮问”接口

/*
 问题部分
 */

//全部问题列表
#define QA_ALL_QUESTIONS_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/Question/getQuestionList"]

//添加新问题
#define QA_ADD_QUESTION_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/Question/add"]

//问题图片上传
#define QA_UPLOAD_PIC_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/Question/uploadPicture"]

//取消提问
#define QA_CANCEL_QUESTION_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/Question/cancelQuestion"]

//问题详情
#define QA_QUESTION_DETAIL_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/Question/getDetailedInfo"]

// 阅读量统计
#define QA_BROWSENUMBER_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/Question/addView"]

//问题回答列表
#define QA_QUESTION_ANSWERLIST [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/Answer/getAnswerlist"]

//忽略问题
#define QA_IGNORE_QUESTION_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/Question/ignore"]



/*
 回答部分
 */

//回答问题
#define QA_ANSWER_QUESTION_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/Answer/add"]

//上传答案图片
#define QA_ANSWER_ANSWERIMAGE_UPLOAD [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/Answer/uploadPicture"]
//某个问题下的回答列表
#define QA_QUESTION_ANSWER_LIST_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/Answer/add"]

//采纳答案
#define QA_ADOPT_ANSWER_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/Answer/adopt"]

//赞接口
#define QA_ADD_LIKE_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/Answer/praise"]

//取消赞接口
#define QA_CANCEL_LIKE_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/Answer/cancelPraise"]

//某个回答下的评论列表
#define QA_QUESTION_DISUCESS_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/Answer/getRemarkList"]

//在回答下添加评论
#define QA_ADD_DISCUSS_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/Answer/remark"]

/*
举报部分
*/
#define QA_ADD_REPORT_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/Feedback/addReport"]

/*
 草稿箱
 */
//添加到草稿箱
#define QA_ADD_DRAFT_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-draft/User/addItemInDraft"]

//更新草稿箱内容
#define QA_UPDATE_DRAFT_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-draft/User/updateItemInDraft"]

#pragma mark- “新版邮问”接口
/*
 搜索部分
 */
//热词搜索列表（非搜索框内）
#define NEWQA_HOT_WORDS_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/search/getSearchHotWord"]
//搜索结果：
    //相关动态
#define NEWQA_SEARCH_DYNAMIC_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/search/searchPost"]
    //重邮知识库
#define NEWQA_SEARCH_KNOWLEDGE_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/search/searchKnowledge"]

/*
 发布动态页
 */
//发布动态
#define NEWQA_RELEASEDYNAMIC_RELEASE_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/post/releaseDynamic"]

// 推荐帖子
#define NEW_QA_POST [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/post/getMainPage"]

// 关注的人帖子
#define NEW_QA_FOCUSLIST [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/post/dynamic/focus"]

// 举报
#define NEW_QA_REPORT [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/comment/report"]

// 热词搜索
#define NEW_QA_HOTWORD [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/search/getSearchHotWord"]

// 我的关注
#define NEW_QA_FOLLOWGROUP [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/ground/getFollowedTopic"]

// 点赞帖子
#define NEW_QA_STAR [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/comment/praise"]

// 屏蔽
#define NEW_QA_SHIELD [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/ignore/addIgnoreUid"]

// 查看未读消息
#define NEW_QA_QUERYNEWCOUNT [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/ground/getUnreadCount"]

// 删除
#define NEW_QA_DELETEPOST [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/comment/deleteId"]

// 关注圈子
#define NEW_QA_STARGROUP [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/ground/followTopicGround"]
/**
 圈子广场
 圈子详情页
 */

//圈子页帖子内容
#define NEW_QA_TOPICCONTENT [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/post/getLoopPage"]
//圈子广场
#define NEW_QA_TOPICGROUP [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/ground/getTopicGround"]
//关注和取消圈子
#define FOLLOWTOPIC [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/ground/followTopicGround"]
/**
 动态详情页
 */
//根据帖子id获取帖子的具体信息
#define NEW_QA_DynamicDetail [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/post/getPostInfo"]

//根据id获取评论/回复
#define NEW_QA_Comment_Reply [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/comment"]

//回复评论
#define New_QA_Comment_Release [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/comment/releaseComment"] 
/*
 删除帖子或评论（POST）     说明：
 参数：
 id                 动态的id
 model              0为动态，1为评论
 */
#define NEW_QA_Dynamic_OR_Comment_Deleted [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/comment/deleteId"]

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
