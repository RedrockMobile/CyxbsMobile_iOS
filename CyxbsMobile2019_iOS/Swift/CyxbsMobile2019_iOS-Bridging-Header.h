//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//


#pragma mark - 头文件

#import <AFNetworking.h>
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import <YYKit.h>
#import <Masonry.h>
#import <MBProgressHUD.h>
#import <MJExtension.h>
#import "HttpClient.h"
#import "UIColor+Helper.h"
#import "UITextView+Placeholder.h"
#import "UserDefaultTool.h"
#import "UserItemTool.h"
#import "BaseViewController.h"
#import "QABaseViewController.h"
#import "NSDate+Timestamp.h"
#import "URLController.h"
#import <UMAnalytics/MobClick.h>
#import "SDMask.h"
#import "CQUPTMapPlaceRect.h"   // 重邮地图里用的，很多文件都要导入这个，太麻烦了，直接写这里好了
#import "AESCipher.h"           // AES加密算法
#import <MGJRouter.h>
#import "UserProtocolViewController.h"
#import "ByWordViewController.h"
#import "ByPasswordViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "YYZGetIdVC.h"
#import "TodoSyncTool.h"

#pragma mark - Group共享

#define kAPPGroupID @"group.com.redrock.mobile"
#define kAppGroupShareNowDay @"nowDay"
#define kAppGroupShareThisWeekArray @"thisWeekArray"

#define kAPPUserDefaultLoginName @"name"
#define kAPPUserDefaultStudentID @"stuNum"

#define kWidthGrid  (SCREEN_WIDTH/7.5)
#define RGBColor(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])

#define ColorArray [[NSMutableArray alloc]initWithObjects:@"254,145,103",@"120,201,252",@"111,219,188",@"191,161,233",nil]

#define kPhotoImageViewW (SCREEN_WIDTH - 2 * 10 - 4) / 3

//gege
#define BACK_GRAY_COLOR [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1]



#pragma mark - 友盟

// 友盟DeciveToken
#define kUMDeviceToken @"kUMDeviceToken"



#pragma mark - 屏幕适配相关

/* 小屏适配 */
#define IS_IPHONESE (SCREEN_WIDTH == 320.f && SCREEN_HEIGHT == 568.f)

/* 全面屏相关 */
#define IS_IPHONEX ((SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f) || (SCREEN_WIDTH == 414.f && SCREEN_HEIGHT == 896.f)? YES : NO)
#define SAFE_AREA_BOTTOM (IS_IPHONEX ? (34.f) : (0.f))

/* 屏幕宽高 */
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

/* TabBar高度 */
#define TABBARHEIGHT (IS_IPHONEX ? (49.f + SAFE_AREA_BOTTOM) : (49.f))

/* 状态栏高度 */
#define STATUSBARHEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

/* NavigationBar高度 */
#define NVGBARHEIGHT (44.f)

/* 顶部总高度 */
#define TOTAL_TOP_HEIGHT (STATUSBARHEIGHT + NVGBARHEIGHT)

#define kSegmentViewTitleHeight (SCREEN_HEIGHT * 50 / 667)

//学期开始时间
#define DateStart @"2021-03-01"



#pragma mark - MGJRouter用到的宏

// MGJRouter中用到的一些宏
// UserInfo的key：
#define kMGJNavigationControllerKey @"MGJNavigationControllerKey"


#pragma mark - 字体
//苹方-简 极细体
#define PingFangSCUltralight    @"PingFangSC-Ultralight"
//苹方-简 纤细体
#define PingFangSCThin @"PingFangSC-Thin"
//苹方-简 细体
#define PingFangSCLight @"PingFangSC-Light"
//苹方-简 常规体
#define PingFangSCRegular @"PingFangSC-Regular"
//苹方-简 中黑体
#define PingFangSCMedium @"PingFangSC-Medium"
//苹方-简 中粗体
#define PingFangSCSemibold @"PingFangSC-Semibold"
/*
 下面这个for，可以打印出现有的所有字体
for(NSString *fontFamilyName in [UIFont familyNames]){
        NSLog(@"family:'%@'",fontFamilyName);
        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontFamilyName]){
            NSLog(@"\tfont:'%@'",fontName);
        }
        NSLog(@"-------------");
}
*/

#define PingFangSCBold @"PingFangSC-Semibold"


// Bahnschrift字体
#define BahnschriftBold @"Bahnschrift_Bold"



#define HEADERHEIGHT (STATUSBARHEIGHT+NVGBARHEIGHT)
#define MWIDTH ((SCREEN_WIDTH)/(DAY*2+1)) //monthLabel的宽度
#define MHEIGHT (1.6*MWIDTH) //monthLabel的高度
#define DAY 7
#define LESSON 12
#define WEEK 20
#define LONGLESSON (LESSON/2)
#define LESSONBTNSIDE (((SCREEN_WIDTH)-(MWIDTH))/DAY)
#define SEGMENT 2
#define autoSizeScaleX SCREEN_WIDTH/375.0
#define autoSizeScaleY SCREEN_HEIGHT/667.0
#define font(R) (R)*([UIScreen mainScreen].bounds.size.width)/375.0
#define SCREEN_RATE (667/[UIScreen mainScreen].bounds.size.height)
#define ZOOM(x) x / SCREEN_RATE



#pragma mark - “我的”接口

/// 登录接口
#define LOGINAPI @"https://be-prod.redrock.cqupt.edu.cn/magipoke/token"
/// 刷新token
//#define REFRESHTOKENAPI @"https://cyxbsmobile.redrock.team/wxapi/magipoke/token/refresh"
#define REFRESHTOKENAPI @"https://be-prod.redrock.cqupt.edu.cn/magipoke/token/refresh"


/// 上传头像
#define UPLOADPROFILEAPI @"https://cyxbsmobile.redrock.team/app/index.php/Home/Photo/uploadArticle"
/// 上传用户信息
#define UPLOADUSERINFOAPI @"http://api-234.redrock.team/magipoke/Person/SetInfo"


/// 获取签到信息
#define CHECKININFOAPI @"https://cyxbsmobile.redrock.team/app/index.php/QA/User/getScoreStatus"
/// 签到
#define CHECKINAPI @"https://cyxbsmobile.redrock.team/app/index.php/QA/Integral/checkIn"
/// 积分商城
#define INTEGRALSTORELISTAPI @"https://cyxbsmobile.redrock.team/wxapi/magipoke-intergral/QA/Integral/getItemList"
/// 兑换商品
#define INTEGRALSTOREORDER @"https://cyxbsmobile.redrock.team/wxapi/magipoke-intergral/QA/Integral/order"
/// 我的商品
#define MYGOODSLISTAPI @"https://cyxbsmobile.redrock.team/wxapi/magipoke-intergral/QA/Integral/myRepertory"


/// “我的”邮问数据
#define MINEQADATAAPI @"https://cyxbsmobile.redrock.team/app/index.php/QA/User/mine"
/// 我的提问
#define MYQUESTIONSAPI @"https://cyxbsmobile.redrock.team/app/index.php/QA/User/question"
/// 提问草稿箱
#define MYQUESTIONDRAFTAPI @"https://cyxbsmobile.redrock.team/wxapi/magipoke-draft/User/getDraftQuestionList"
/// 我的回答
#define MYANSWERSAPI @"https://cyxbsmobile.redrock.team/app/index.php/QA/User/answer"
/// 回答草稿箱
#define MYANSWERSDRAFTAPI @"https://cyxbsmobile.redrock.team/wxapi/magipoke-draft/User/getDraftAnswerList"
/// 发出的评论
#define MYCOMMENTAPI @"https://cyxbsmobile.redrock.team/app/index.php/QA/User/comment"
/// 收到的评论
#define MYRECOMMENTAPI @"https://cyxbsmobile.redrock.team/app/index.php/QA/User/reComment"
/// 删除草稿
#define DELETEDRAFT @"https://cyxbsmobile.redrock.team/wxapi/magipoke-draft/User/deleteItemInDraft"



#pragma mark - “发现”接口

/// 教务新闻列表
#define NEWSLIST @"https://cyxbsmobile.redrock.team/234/newapi/jwNews/list"//参数page，方法Get
/// 教务新闻详情
#define NEWSDETAIL @"https://cyxbsmobile.redrock.team/234/newapi/jwNews/content"
/// 教务新闻附件
#define NEWSFILE @"https://cyxbsmobile.redrock.team/234/newapi/jwNews/file"

/// 电费
#define ELECTRICFEE @"https://cyxbsmobile.redrock.team/MagicLoop/index.php?s=/addon/ElectricityQuery/ElectricityQuery/queryElecByRoom"
//#define ELECTRICFEE @"http://api-234.redrock.team/wxapi/magipoke-elecquery/getElectric"   // 这好像也是电费接口

/// 教务新闻列表
#define NEWSLIST @"https://cyxbsmobile.redrock.team/234/newapi/jwNews/list"
/// 教务新闻详情
#define NEWSDETAIL @"https://cyxbsmobile.redrock.team/234/newapi/jwNews/content"
/// 教务新闻附件下载
#define NEWSDOWNLOAD @"https://cyxbsmobile.redrock.team/234/newapi/jwNews/file"

///查询绩点需要先绑定ids
#define IDSBINDINGAPI @"https://cyxbsmobile.redrock.team/wxapi/magipoke/ids/bind"
///绩点查询
//#define GPAAPI @"https://cyxbsmobile.redrock.team/wxapi/magipoke/gpa"

/// 考试安排接口
#define EXAMARRANGEAPI @"https://cyxbsmobile.redrock.team/api/examSchedule"

/// 校车位置
#define SCHOOLBUSAPI @"https://cyxbsmobile.redrock.team/wxapi/schoolbus/status"

/// banner
#define BANNERVIEWAPI @"http://api-234.redrock.team/magipoke-text/banner/get"

/// 志愿查询
#define VOLUNTEERBIND @"https://cyxbsmobile.redrock.team/wxapi/volunteer/binding"
#define VOLUNTEERREQUEST @"https://cyxbsmobile.redrock.team/wxapi/volunteer/select"



#pragma mark - ”重邮地图“接口

/// 重邮地图历史记录偏好设置Key
#define CQUPTMAPHISTORYKEY @"MapSearchHistory"

/// 重邮地图主页
#define CQUPTMAPBASICDATA @"https://cyxbsmobile.redrock.team/wxapi/magipoke-stumap/basic"
/// 重邮地图热搜
#define CQUPTMAPHOTPLACE @"https://cyxbsmobile.redrock.team/wxapi/magipoke-stumap/button"
/// 重邮地图：我的收藏
#define CQUPTMAPMYSTAR @"https://cyxbsmobile.redrock.team/wxapi/magipoke-stumap/rockmap/collect"
/// 重邮地图：搜索地点
#define CQUPTMAPSEARCH @"https://cyxbsmobile.redrock.team/wxapi/magipoke-stumap/placesearch"
/// 重邮地图：地点详情
#define CQUPTMAPPLACEDETAIL @"https://cyxbsmobile.redrock.team/wxapi/magipoke-stumap/detailsite"
/// 重邮地图：上传图片
#define CQUPTMAPUPLOADIMAGE @"https://cyxbsmobile.redrock.team/wxapi/magipoke-stumap/rockmap/upload"
/// 重邮地图：添加收藏
#define CQUPTMAPADDCOLLECT @"https://cyxbsmobile.redrock.team/wxapi/magipoke-stumap/rockmap/addkeep"
/// 重邮地图：删除收藏
#define CQUPTMAPDELETECOLLECT @"https://cyxbsmobile.redrock.team/wxapi/magipoke-stumap/rockmap/delete"



#pragma mark - “课表”、“备忘”接口

#define kebiaoAPI @"https://cyxbsmobile.redrock.team/api/kebiao"


#define ADDREMINDAPI @"https://cyxbsmobile.redrock.team/cyxbsMobile/index.php/Home/Person/addTransaction"


#define GETREMINDAPI @"https://cyxbsmobile.redrock.team/cyxbsMobile/index.php/Home/Person/getTransaction"


#define EDITREMINDAPI @"https://cyxbsmobile.redrock.team/cyxbsMobile/index.php/Home/Person/editTransaction"


#define DELETEREMINDAPI @"https://cyxbsmobile.redrock.team/cyxbsMobile/index.php/Home/Person/deleteTransaction"


#define TEAkebiaoAPI @"https://cyxbsmobile.redrock.team/wxapi/magipoke-teaKb/api/teaKb"
/// 空教室接口
#define EMPTYCLASSAPI @"https://cyxbsmobile.redrock.team/234/newapi/roomEmpty"

/// 同学课表之查找同学
#define SEARCHPEOPLEAPI @"https://cyxbsmobile.redrock.team/cyxbsMobile/index.php/home/searchPeople/peopleList"
/// 查找老师
#define SEARCHTEACHERAPI @"https://cyxbsmobile.redrock.team/wxapi/magipoke-teaKb/api/teaSearch"



#pragma mark - “邮问”接口

/*
 问题部分
 */

//全部问题列表
#define QA_ALL_QUESTIONS_API @"https://cyxbsmobile.redrock.team/app/index.php/QA/Question/getQuestionList"

//添加新问题
#define QA_ADD_QUESTION_API @"https://cyxbsmobile.redrock.team/app/index.php/QA/Question/add"

//问题图片上传
#define QA_UPLOAD_PIC_API @"https://cyxbsmobile.redrock.team/app/index.php/QA/Question/uploadPicture"

//取消提问
#define QA_CANCEL_QUESTION_API @"https://cyxbsmobile.redrock.team/app/index.php/QA/Question/cancelQuestion"

//问题详情
#define QA_QUESTION_DETAIL_API @"https://cyxbsmobile.redrock.team/app/index.php/QA/Question/getDetailedInfo"

// 阅读量统计
#define QA_BROWSENUMBER_API @"https://cyxbsmobile.redrock.team/app/index.php/QA/Question/addView"

//问题回答列表
#define QA_QUESTION_ANSWERLIST @"https://cyxbsmobile.redrock.team/app/index.php/QA/Answer/getAnswerlist"

//忽略问题
#define QA_IGNORE_QUESTION_API @"https://cyxbsmobile.redrock.team/app/index.php/QA/Question/ignore"



/*
 回答部分
 */

//回答问题
#define QA_ANSWER_QUESTION_API @"https://cyxbsmobile.redrock.team/app/index.php/QA/Answer/add"

//上传答案图片
#define QA_ANSWER_ANSWERIMAGE_UPLOAD @"https://cyxbsmobile.redrock.team/app/index.php/QA/Answer/uploadPicture"
//某个问题下的回答列表
#define QA_QUESTION_ANSWER_LIST_API @"https://cyxbsmobile.redrock.team/app/index.php/QA/Answer/add"

//采纳答案
#define QA_ADOPT_ANSWER_API @"https://cyxbsmobile.redrock.team/app/index.php/QA/Answer/adopt"

//赞接口
#define QA_ADD_LIKE_API @"https://cyxbsmobile.redrock.team/app/index.php/QA/Answer/praise"

//取消赞接口
#define QA_CANCEL_LIKE_API @"https://cyxbsmobile.redrock.team/app/index.php/QA/Answer/cancelPraise"

//某个回答下的评论列表
#define QA_QUESTION_DISUCESS_API @"https://cyxbsmobile.redrock.team/app/index.php/QA/Answer/getRemarkList"

//在回答下添加评论
#define QA_ADD_DISCUSS_API @"https://cyxbsmobile.redrock.team/app/index.php/QA/Answer/remark"

/*
举报部分
*/
#define QA_ADD_REPORT_API @"https://cyxbsmobile.redrock.team/app/index.php/QA/Feedback/addReport"

/*
 草稿箱
 */
//添加到草稿箱
#define QA_ADD_DRAFT_API @"https://cyxbsmobile.redrock.team/wxapi/magipoke-draft/User/addItemInDraft"
//更新草稿箱内容
#define QA_UPDATE_DRAFT_API @"https://cyxbsmobile.redrock.team/wxapi/magipoke-draft/User/updateItemInDraft"


typedef NS_ENUM(NSInteger, PeopleType) {
    /**代表传入的是学生相关*/
    PeopleTypeStudent,
    /**代表传入的是老师相关*/
    PeopleTypeTeacher
};

////data[i][j]代表（星期i+1）的（第j+1节课）是否有课，有课则为1，无课则为0
//typedef struct weekData{
//    int data[7][12];
//} weekData;

typedef NS_ENUM(NSInteger, ScheduleType) {
    /**代表是用户自己的课表*/
    ScheduleTypePersonal,
    /**代表是在查课表处显示的课表*/
    ScheduleTypeClassmate,
    /**代表是在没课约显示的课表*/
    ScheduleTypeWeDate,
};
//更新显示下节课内容的tabBar要用的协议
@protocol updateSchedulTabBarViewProtocol <NSObject>
//paramDict的3个key：
//classroomLabel：教室地点
//classTimeLabel：上课时间
//classLabel：课程名称
- (void)updateSchedulTabBarViewWithDic:(NSDictionary*)paramDict;
@end
//显示月份的view宽度；显示第几节课的竖条宽度
#define MONTH_ITEM_W (MAIN_SCREEN_W*0.088)
//显示月份、周几、日期的条内部item的间距；课表view和leftBar的距离
#define DAYBARVIEW_DISTANCE (MAIN_SCREEN_W*0.0075)
//0.00885

//记录最后一次登陆的时间戳，类型是Double，用来避免后端出问题后的强制退出登录
#define LastLogInTimeKey_double @"LastLogInTimeKey_TimeInterval"

