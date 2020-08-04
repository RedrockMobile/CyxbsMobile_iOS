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
#import "WYCClassBookView.h"
#import "WYCClassDetailView.h"
#import "WYCShowDetailView.h"
#import "WMTWeekChooseBar.h"
#import "LoginViewController.h"


#import "AddRemindViewController.h"
#import "UIFont+AdaptiveFont.h"
#import "RemindNotification.h"


#define DateStart @"2020-02-17"

NS_ASSUME_NONNULL_BEGIN
//目标：输入[responseObject objectForKey:@"data"]，输出一张课表
@interface WYCClassBookViewController : UIViewController
- (void)initStuNum:(NSString*)stuNum andIdNum:(NSString*)idnum;
- (void)initWYCClassAndRemindDataModel:(WYCClassAndRemindDataModel*)model;
    
@end

NS_ASSUME_NONNULL_END
