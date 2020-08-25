//
//  WYCClassBookViewController.h
//  MoblieCQUPT_iOS
//
//  Created by 王一成 on 2018/9/21.
//  Copyright © 2018年 Orange-W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLReminderViewController.h"
#import "WYCClassAndRemindDataModel.h"

#import "DateModle.h"

#import "WYCClassDetailView.h"
#import "WYCShowDetailView.h"
#import "WMTWeekChooseBar.h"
#import "LoginViewController.h"
#import "FakeTabBarView.h"
#import "TopBarScrollView.h"
#import "AddRemindViewController.h"
#import "UIFont+AdaptiveFont.h"
#import "RemindNotification.h"


//#define DateStart @"2020-02-17"

NS_ASSUME_NONNULL_BEGIN
//目标：输入[responseObject objectForKey:@"data"]，输出：显示整学期课表
//现状：输入WYCClassAndRemindDataModel，输出：显示整学期课表
@interface WYCClassBookViewController : UIViewController<WYCClassAndRemindDataModelDelegate,UIApplicationDelegate>

//如果是用代码加载，必须对model赋值，详细说明看底下注释
@property (nonatomic, strong) WYCClassAndRemindDataModel *model;
//如果是用代码加载，必须对schedulType赋值
@property (nonatomic, assign)ScheduleType schedulType;

@property (nonatomic, weak)id <updateSchedulTabBarViewProtocol>schedulTabBar;

/// orderlySchedulArray[i][j][k]代表（第i周）的（星期j+1）的（第k+1节大课）,orderlySchedulArray[i][j][k]是一个数组
@property (nonatomic, strong)NSMutableArray *orderlySchedulArray;

@property (nonatomic, copy) NSString *stuNum;
@property (nonatomic, copy) NSString *idNum;
@property (nonatomic,strong)FakeTabBarView *fakeBar;
@property (nonatomic, strong)TopBarScrollView *topBarView;
//如果WYCClassAndRemindDataModel的代理是课表控制器，那么模型加载操作完毕后无需外界调这两个方法
//但是如果代理不是课表控制器，那么外界需要调用一下这两个方法
- (void)ModelDataLoadFailure;
- (void)ModelDataLoadSuccess;
@end

NS_ASSUME_NONNULL_END
//用代码加载WYCClassBookViewController的使用说明：

//1.创建所需模型，在对模型完成一些初始化操作
//WYCClassAndRemindDataModel *model = [[WYCClassAndRemindDataModel alloc] init];
//model.weekArray = [@[array]mutableCopy];
//[model parsingClassBookData:array];
//[model setValue:@"YES" forKey:@"remindDataLoadFinish"];
//[model setValue:@"YES" forKey:@"classDataLoadFinish"];

//2.从控制器加载WYCClassBookViewController
//WYCClassBookViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WYCClassBookViewController"];

//
//[vc initStuNum:@"x" andIdNum:@"x"];

//4.用模型对vc在初始化一下
//[vc initWYCClassAndRemindDataModel:model];

//5.presentViewController，或pushVC


