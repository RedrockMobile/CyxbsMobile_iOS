//
//  CyxbsMobileURL.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/20.
//  Copyright © 2021 Redrock. All rights reserved.
//这里面放一些 接口URL的宏

#ifndef CyxbsMobileURL_h
#define CyxbsMobileURL_h

#pragma mark - “我的”接口

///测试环境
//#define CyxbsMobileBaseURL_1 @"https://be-dev.redrock.cqupt.edu.cn/"
//#define CyxbsMobileBaseURL_2 @"https://be-dev.redrock.cqupt.edu.cn/"

//#define CyxbsMobileBaseURL_1 @"https://be-prod.redrock.team/"
#define CyxbsMobileBaseURL_1 [[NSUserDefaults standardUserDefaults] objectForKey:@"baseURL"]
//#define CyxbsMobileBaseURL_2 @"https://be-prod.redrock.team/"
#define CyxbsMobileBaseURL_2 [[NSUserDefaults standardUserDefaults] objectForKey:@"baseURL"]

/// 登录接口
#define LOGINAPI @"magipoke/token"
/// 刷新token
#define REFRESHTOKENAPI @"magipoke/token/refresh"

//取消屏蔽某人
#define cancelIgnorePeopleUrl @"magipoke-loop/ignore/cancelIgnoreUid"

//屏蔽某人
#define ignorePeopleUrl @"magipoke-loop/ignore/addIgnoreUid"

//删除帖子
#define deleteArticle @"magipoke-loop/comment/deleteId"

//获取自己的帖子
#define getArticle @"magipoke-loop/user/getUserPostList"


//动态/点赞/获赞评论数
#define getUserCount @"magipoke-loop/user/getUserCount"

//未读消息数
#define getMsgCnt @"magipoke-loop/user/uncheckedMessage"

//获取收到的评论
#define getReplyAPI @"magipoke-loop/user/replyme"

//获取收到的赞
#define getPraiseAPI @"magipoke-loop/user/praisedme"

/// 上传头像	
#define UPLOADPROFILEAPI @"magipoke/person/upload/avatar"

/// 上传用户信息
#define UPLOADUSERINFOAPI @"magipoke/Person/SetInfo"

//获取用户资料，POST
#define getPersonData @"magipoke/Person/Search"

//获取屏蔽的人
#define getIgnoreUid @"magipoke-loop/user/getIgnoreUid"

//获取用户服务协议
#define GetaboutUsMsg @"magipoke-text/text/get"

// 通过帖子id 获取帖子数据
#define GETPOSTINFO @"magipoke-loop/post/getPostInfo"

/// 获取签到信息
#define CHECKININFOAPI @"magipoke-intergral/QA/User/getScoreStatus"
/// 签到
#define CHECKINAPI @"magipoke-intergral/QA/Integral/checkIn"
/// 积分商城
#define INTEGRALSTORELISTAPI @"magipoke-intergral/QA/Integral/getItemList"
/// 兑换商品
#define INTEGRALSTOREORDER @"magipoke-intergral/QA/Integral/order"
/// 我的商品
#define MYGOODSLISTAPI @"magipoke-intergral/QA/Integral/myRepertory"


/// “我的”邮问数据
#define MINEQADATAAPI @"QA/User/mine"
/// 我的提问
#define MYQUESTIONSAPI @"QA/User/question"
/// 提问草稿箱
#define MYQUESTIONDRAFTAPI @"magipoke-draft/User/getDraftQuestionList"
/// 我的回答
#define MYANSWERSAPI @"QA/User/answer"
/// 回答草稿箱
#define MYANSWERSDRAFTAPI @"magipoke-draft/User/getDraftAnswerList"
/// 发出的评论
#define MYCOMMENTAPI @"QA/User/comment"
/// 收到的评论
#define MYRECOMMENTAPI @"QA/User/reComment"
/// 删除草稿
#define DELETEDRAFT @"magipoke-draft/User/deleteItemInDraft"

#pragma mark - 修改密码 借口
/// 密保问题列表
#define QUESTIONLISTAPI @"user-secret/user/question"

///修改密码(个人界面)
#define CHANGEPASSWORDAPI @"user-secret/user/password/personal"

///修改密码(登录界面)
#define RESSETPASSWORDAPI @"user-secret/user/password/valid"

///发送绑定邮箱验证码
#define SENDEMAILCODEAPI @"user-secret/user/bind/email/code"

///验证绑定邮箱验证码
#define EMAILCODEAPI @"user-secret/user/bind/email"
///是否绑定信息
#define BINDINGEMAILANDQUESTIONAPI @"user-secret/user/bind/is"
///上传密保消息
#define SENDQUESTION @"user-secret/user/bind/question"

//找回密码

///获取密保问题
#define GETQUESTION @"user-secret/user/bind/question/detail"
///判断密保是否正确
#define CHECKQUESTION @"user-secret/user/valid/question"

///判断验证码是否正确
#define CHECKEMAILCODE @"user-secret/user/valid/email"
///发送验证码请求
#define GETEMAILCODE @"user-secret/user/valid/email/code"
///请求密保邮箱账号
#define GETEMAILDETAIL @"user-secret/user/bind/email/detail"


#pragma mark - “发现”接口
//校历接口
#define schoolCalendar @"magipoke-jwzx/schoolCalendar"
/// 教务新闻列表
///参数：page
///方法：Get
//#define NEWSLIST @"https://be-prod.redrock.team/magipoke-jwzx/jwNews/list"
#define NEWSLIST @"magipoke-jwzx/jwNews/list"
/// 教务新闻详情
///方法：Get
///参数：新闻id
//#define NEWSDETAIL @"https://be-prod.redrock.team/magipoke-jwzx/jwNews/content"
#define NEWSDETAIL @"magipoke-jwzx/jwNews/content"
/// 教务新闻附件
/// 方法：Get
///参数：附件的id
#define NEWSFILE @"magipoke-jwzx/jwNews/file"

//在NewDetailViewController要单独改一下
/// 电费
#define ELECTRICFEE @"magipoke-elecquery/getElectric"


///查询绩点需要先绑定ids
#define IDSBINDINGAPI @"magipoke/ids/bind"

///绩点查询
#define GPAAPI @"magipoke/gpa"

/// 考试安排接口
#define EXAMARRANGEAPI @"magipoke-jwzx/examSchedule"
                   
#define EXAM_MODEL @"magipoke-jwzx/nowStatus"

/// 校车位置
#define SCHOOLBUSAPI @"schoolbus/status"

/// banner
#define BANNERVIEWAPI @"magipoke-text/banner/get"

/// 志愿查询
#define VOLUNTEERBIND @"volunteer-message/binding"

#define VOLUNTEERREQUEST @"volunteer-message/select"

#define VOLUNTEERUNBINDING @"volunteer-message/unbinding"

#define VOLUNTEERACTIVITY @"/cyb-volunteer/volunteer/activity/info/new"

#pragma mark - ”重邮地图“接口

/// 重邮地图历史记录偏好设置Key
#define CQUPTMAPHISTORYKEY @"MapSearchHistory"

/// 重邮地图主页
#define CQUPTMAPBASICDATA @"magipoke-stumap/basic"
/// 重邮地图热搜
#define CQUPTMAPHOTPLACE @"magipoke-stumap/button"
/// 重邮地图：我的收藏
#define CQUPTMAPMYSTAR @"magipoke-stumap/rockmap/collect"
/// 重邮地图：搜索地点
#define CQUPTMAPSEARCH @"magipoke-stumap/placesearch"
/// 重邮地图：地点详情
#define CQUPTMAPPLACEDETAIL @"magipoke-stumap/detailsite"
/// 重邮地图：上传图片
#define CQUPTMAPUPLOADIMAGE @"magipoke-stumap/rockmap/upload"
/// 重邮地图：添加收藏
#define CQUPTMAPADDCOLLECT @"magipoke-stumap/rockmap/addkeep"
/// 重邮地图：删除收藏
#define CQUPTMAPDELETECOLLECT @"magipoke-stumap/rockmap/delete"



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
#define TEAkebiaoAPI @"magipoke-teakb/api/teaKb"

/// 空教室接口
#define EMPTYCLASSAPI @"magipoke-jwzx/roomEmpty"

/// 同学课表之查找同学，GET，参数：@{@"stu"]: 用来搜索的数据}
#define SEARCHPEOPLEAPI @"magipoke-text/search/people"

/// 查找老师，POST，参数：@{@"teaName"]: 用来搜索的数据}
#define SEARCHTEACHERAPI @"magipoke-teakb/api/teaSearch"



#pragma mark - “邮问”接口

/*
 问题部分
 */

//全部问题列表
#define QA_ALL_QUESTIONS_API @"QA/Question/getQuestionList"

//添加新问题
#define QA_ADD_QUESTION_API @"QA/Question/add"

//问题图片上传
#define QA_UPLOAD_PIC_API @"QA/Question/uploadPicture"

//取消提问
#define QA_CANCEL_QUESTION_API @"QA/Question/cancelQuestion"

//问题详情
#define QA_QUESTION_DETAIL_API @"QA/Question/getDetailedInfo"

// 阅读量统计
#define QA_BROWSENUMBER_API @"QA/Question/addView"

//问题回答列表
#define QA_QUESTION_ANSWERLIST @"QA/Answer/getAnswerlist"

//忽略问题
#define QA_IGNORE_QUESTION_API @"QA/Question/ignore"



/*
 回答部分
 */

//回答问题
#define QA_ANSWER_QUESTION_API @"QA/Answer/add"

//上传答案图片
#define QA_ANSWER_ANSWERIMAGE_UPLOAD @"QA/Answer/uploadPicture"
//某个问题下的回答列表
#define QA_QUESTION_ANSWER_LIST_API @"QA/Answer/add"

//采纳答案
#define QA_ADOPT_ANSWER_API @"QA/Answer/adopt"

//赞接口
#define QA_ADD_LIKE_API @"QA/Answer/praise"

//取消赞接口
#define QA_CANCEL_LIKE_API @"QA/Answer/cancelPraise"

//某个回答下的评论列表
#define QA_QUESTION_DISUCESS_API @"QA/Answer/getRemarkList"

//在回答下添加评论
#define QA_ADD_DISCUSS_API @"QA/Answer/remark"

/*
举报部分
*/
#define QA_ADD_REPORT_API @"QA/Feedback/addReport"

/*
 草稿箱
 */
//添加到草稿箱
#define QA_ADD_DRAFT_API @"magipoke-draft/User/addItemInDraft"

//更新草稿箱内容
#define QA_UPDATE_DRAFT_API @"magipoke-draft/User/updateItemInDraft"

#pragma mark- “新版邮问”接口
/*
 搜索部分
 */
//热词搜索列表（非搜索框内）
#define NEWQA_HOT_WORDS_API @"magipoke-loop/search/getSearchHotWord"
//搜索结果：
    //相关动态
#define NEWQA_SEARCH_DYNAMIC_API @"magipoke-loop/search/searchPost"
    //重邮知识库
#define NEWQA_SEARCH_KNOWLEDGE_API @"magipoke-loop/search/searchKnowledge"

/*
 发布动态页
 */
//发布动态
#define NEWQA_RELEASEDYNAMIC_RELEASE_API @"magipoke-loop/post/releaseDynamic"

// 推荐帖子
#define NEW_QA_POST @"magipoke-loop/post/getMainPage"

// 关注的人帖子
#define NEW_QA_FOCUSLIST @"magipoke-loop/post/dynamic/focus"

// 举报
#define NEW_QA_REPORT @"magipoke-loop/comment/report"

// 热词搜索
#define NEW_QA_HOTWORD @"magipoke-loop/search/getSearchHotWord"

// 我的关注
#define NEW_QA_FOLLOWGROUP @"magipoke-loop/ground/getFollowedTopic"

// 点赞帖子
#define NEW_QA_STAR @"magipoke-loop/comment/praise"

// 屏蔽
#define NEW_QA_SHIELD @"magipoke-loop/ignore/addIgnoreUid"

// 查看未读消息
#define NEW_QA_QUERYNEWCOUNT @"magipoke-loop/ground/getUnreadCount"

// 删除
#define NEW_QA_DELETEPOST @"magipoke-loop/comment/deleteId"

// 关注圈子
#define NEW_QA_STARGROUP @"magipoke-loop/ground/followTopicGround"
/**
 圈子广场
 圈子详情页
 */

//圈子页帖子内容
#define NEW_QA_TOPICCONTENT @"magipoke-loop/post/getLoopPage"
//圈子广场
#define NEW_QA_TOPICGROUP @"magipoke-loop/ground/getTopicGround"
//关注和取消圈子
#define FOLLOWTOPIC @"magipoke-loop/ground/followTopicGround"
/**
 动态详情页
 */
//根据帖子id获取帖子的具体信息
#define NEW_QA_DynamicDetail @"magipoke-loop/post/getPostInfo"

//根据id获取评论/回复
#define NEW_QA_Comment_Reply @"magipoke-loop/comment"

//回复评论
#define New_QA_Comment_Release @"magipoke-loop/comment/releaseComment"
/*
 删除帖子或评论（POST）     说明：
 参数：
 id                 动态的id
 model              0为动态，1为评论
 */
#define NEW_QA_Dynamic_OR_Comment_Deleted @"magipoke-loop/comment/deleteId"

#pragma mark - 邮票中心

// 积分兑换记录, 对应 =兑换记录= 界面
#define Stamp_Store_details_exchange @"magipoke-intergral/User/exchange"

// 积分获得信息, 对应 =获取记录= 界面
#define Stamp_store_details_getRecord @"magipoke-intergral/User/getRecord"

//主页信息
#define Stamp_Store_Main_Page @"magipoke-intergral/User/info"

//任务
#define TASK @"magipoke-intergral/Integral/progress"

// 商品
#define Stamp_Store_Goods @"magipoke-intergral/Integral/getItemInfo"
// 兑换
#define Stamp_Store_Exchange @"magipoke-intergral/Integral/purchase"

#pragma mark - 反馈中心

// 测试环境, 请在正式环境出来的时候
// 历史反馈列表
// 参数 product_id 区分数据来源, 掌邮只填1
#define FeedBack_Center_History_List @"feedback-center/feedback/list"

// 历史反馈页, 点击一个进入详情
// 参数 feedback_id 信息的id
// 参数 product_id 区分数据来源, 掌邮只填1
#define FeedBack_Center_History_View @"feedback-center/feedback/view"

//常见问题
#define COMMON_QUESTION @"feedback-center/question/list?product_id=1"

//提交反馈
#define SUBMIT @"feedback-center/feedback/create?product_id=1"

#endif /* CyxbsMobileURL_h */
