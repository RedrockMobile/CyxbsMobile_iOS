//
//  MineHeader.h
//  CyxbsMobile2019_iOS
//
//  Created by 小艾同学 on 2022/7/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

#ifndef MineHeader_h
#define MineHeader_h


#pragma mark - API

#pragma mark - "我的"接口
///测试环境
//#define CyxbsMobileBaseURL_1 @"https://be-dev.redrock.cqupt.edu.cn/"
//#define CyxbsMobileBaseURL_2 @"https://be-dev.redrock.cqupt.edu.cn/"

//#define CyxbsMobileBaseURL_1 @"https://be-prod.redrock.team/"
#define CyxbsMobileBaseURL_1 [[NSUserDefaults standardUserDefaults] objectForKey:@"baseURL"]
//#define CyxbsMobileBaseURL_2 @"https://be-prod.redrock.team/"
#define CyxbsMobileBaseURL_2 [[NSUserDefaults standardUserDefaults] objectForKey:@"baseURL"]




/// 登录接口
//#define LOGINAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke/token"]
#define Mine_POST_logIn_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke/token"]

/// 刷新token
//#define REFRESHTOKENAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke/token/refresh"]
#define Mine_POST_refreshToken_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke/token/refresh"]

/// 上传头像。未使用
//#define UPLOADPROFILEAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke/person/upload/avatar"]
#define Mine_GET_upLoadProfile_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke/person/upload/avatar"]

/// 上传用户信息。未使用
//#define UPLOADUSERINFOAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke/Person/SetInfo"]
#define Mine_GET_upLoadUserInfo_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke/Person/SetInfo"]

/// 获取签到信息
//#define CHECKININFOAPI [CyxbsMobileBaseURL_2 stringByAppendingString:@"magipoke-intergral/QA/User/getScoreStatus"]
#define Mine_POST_checkInInfo_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"magipoke-intergral/QA/User/getScoreStatus"]

/// 签到
//#define CHECKINAPI [CyxbsMobileBaseURL_2 stringByAppendingString:@"magipoke-intergral/QA/Integral/checkIn"]
#define Mine_POST_checkIn_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"magipoke-intergral/QA/Integral/checkIn"]

/// 积分商城。未使用
//#define INTEGRALSTORELISTAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-intergral/QA/Integral/getItemList"]
#define Mine_GET_integralStoreList_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-intergral/QA/Integral/getItemList"]

/// 兑换商品。未使用
//#define INTEGRALSTOREORDER [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-intergral/QA/Integral/order"]
#define Mine_GET_integralStoreOrder_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-intergral/QA/Integral/order"]

/// 我的商品。未使用
//#define MYGOODSLISTAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-intergral/QA/Integral/myRepertory"]
#define Mine_GET_myGoodsList_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-intergral/QA/Integral/myRepertory"]

/// “我的”邮问数据。未使用
//#define MINEQADATAAPI [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/User/mine"]
#define Mine_GET_mineQAData_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/User/mine"]

/// 我的提问。未使用
//#define MYQUESTIONSAPI [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/User/question"]
#define Mine_GET_myQuestions_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/User/question"]

/// 提问草稿箱。未使用
//#define MYQUESTIONDRAFTAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-draft/User/getDraftQuestionList"]
#define Mine_GET_myQuestionDraft_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-draft/User/getDraftQuestionList"]

/// 我的回答。未使用
//#define MYANSWERSAPI [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/User/answer"]
#define Mine_GET_myAnswers_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/User/answer"]

/// 回答草稿箱。未使用
//#define MYANSWERSDRAFTAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-draft/User/getDraftAnswerList"]
#define Mine_GET_myAnswersDraft_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-draft/User/getDraftAnswerList"]

/// 发出的评论。未使用
//#define MYCOMMENTAPI [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/User/comment"]
#define Mine_GET_myComment_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/User/comment"]

/// 收到的评论。未使用
//#define MYRECOMMENTAPI [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/User/reComment"]
#define Mine_GET_myRecomment_API [CyxbsMobileBaseURL_2 stringByAppendingString:@"QA/User/reComment"]

/// 删除草稿。未使用
//#define DELETEDRAFT [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-draft/User/deleteItemInDraft"]
#define Mine_GET_deleteDraft_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-draft/User/deleteItemInDraft"]

//取消屏蔽某人
//#define cancelIgnorePeopleUrl [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/ignore/cancelIgnoreUid"]
#define Mine_POST_cancelIgnorePeople_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/ignore/cancelIgnoreUid"]

//屏蔽某人
//#define ignorePeopleUrl [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/ignore/addIgnoreUid"]
#define Mine_POST_ignorePeople_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/ignore/addIgnoreUid"]

//删除帖子
//#define deleteArticle [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/comment/deleteId"]
#define Mine_POST_deleteArticle_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/comment/deleteId"]

//获取自己的帖子
//#define getArticle [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/user/getUserPostList"]
#define Mine_GET_getArticle_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/user/getUserPostList"]

//动态/点赞/获赞评论数
//#define getUserCount [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/user/getUserCount"]
#define Mine_GET_getUserCount_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/user/getUserCount"]

//未读消息数
//#define getMsgCnt [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/user/uncheckedMessage"]
#define Mine_GET_getMsgCnt_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/user/uncheckedMessage"]

//获取收到的评论
//#define getReplyAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/user/replyme"]
#define Mine_GET_getReply_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/user/replyme"]

//获取收到的赞
//#define getPraiseAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/user/praisedme"]
#define Mine_GET_getPraise_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/user/praisedme"]

//获取用户资料，POST
//#define getPersonData [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke/Person/Search"]
#define Mine_POST_getPersonData_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke/Person/Search"]

//获取屏蔽的人
//#define getIgnoreUid [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/user/getIgnoreUid"]
#define Mine_POST_getIgnoreUid_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/user/getIgnoreUid"]

//获取用户服务协议
//#define GetaboutUsMsg [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-text/text/get"]
#define Mine_POST_getAboutUsMsg_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-text/text/get"]

// 通过帖子id 获取帖子数据。未使用
//#define GETPOSTINFO [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/post/getPostInfo"]
#define Mine_GET_getPostInfo_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-loop/post/getPostInfo"]

#pragma mark - 修改密码 接口

/// 密保问题列表
//#define QUESTIONLISTAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/question"]
#define Mine_GET_questionList_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/question"]
///修改密码(个人界面)
//#define CHANGEPASSWORDAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/password/personal"]
#define Mine_POST_changePassword_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/password/personal"]

///修改密码(登录界面)
//#define RESSETPASSWORDAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/password/valid"]
#define Mine_POST_ressetPassword_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/password/valid"]

///发送绑定邮箱验证码
//#define SENDEMAILCODEAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/bind/email/code"]
#define Mine_POST_sendEmailCode_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/bind/email/code"]

///验证绑定邮箱验证码
//#define EMAILCODEAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/bind/email"]
#define Mine_POST_emailCode_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/bind/email"]
///是否绑定信息
//#define BINDINGEMAILANDQUESTIONAPI [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/bind/is"]
#define Mine_POST_bindingEmailAndQuestion_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/bind/is"]
///上传密保消息
//#define SENDQUESTION [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/bind/question"]
#define Mine_POST_sendQuestion_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/bind/question"]

//找回密码

///获取密保问题
//#define GETQUESTION [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/bind/question/detail"]
#define Mine_POST_getQuestion_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/bind/question/detail"]
///判断密保是否正确
//#define CHECKQUESTION [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/valid/question"]
#define Mine_POST_checkQuestion_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/valid/question"]

///判断验证码是否正确
//#define CHECKEMAILCODE [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/valid/email"]
#define Mine_POST_checkEmailCode_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/valid/email"]
///发送验证码请求
//#define GETEMAILCODE [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/valid/email/code"]
#define Mine_POST_getEmailCode_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/valid/email/code"]
///请求密保邮箱账号
//#define GETEMAILDETAIL [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/bind/email/detail"]
#define Mine_POST_getEmailDetail_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/bind/email/detail"]
///判断是否为默认密码
//#define IFORIGINPASSWORD [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/judge/origin"]
#define Mine_POST_ifOriginPassword_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"user-secret/user/judge/origin"]



#endif /* MineHeader_h */
