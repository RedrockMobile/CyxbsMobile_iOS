//
//  MGJRouterRegister.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/9/23.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MGJRouterRegister.h"
#import "QADetailViewController.h"


/// 用于注册MGJRouter的URL。
/// PrefixHeader.pch中有一个宏：kMGJNavigationControllerKey，用于从跳转的from页面的导航控制器，例如：
/*  NSDictionary *userInfo = @{
        kMGJNavigationController: self.navigationController
    };
    [MGJRouter openURL:@"cyxbs://redrock.team/answer_list/qa/entry?question_id=1985" withUserInfo:userInfo completion:nil];
 */
/// 即可跳转至邮问详情页面
@implementation MGJRouterRegister


// 参数：
// questoin_id: NSString
#define kQADetailURL @"cyxbs://redrock.team/answer_list/qa/entry"

// 参数：无
#define kExample @"cyxbs://redrock.team/xxx"        // 例子，可以删掉


+ (void)load {
    
    [MGJRouter registerURLPattern:kQADetailURL toHandler:^(NSDictionary *routerParameters) {
        
        QADetailViewController *qaDetailVC = [[QADetailViewController alloc] initViewWithId:[routerParameters[@"question_id"] numberValue] title:@""];
        qaDetailVC.hidesBottomBarWhenPushed = YES;
        
        [routerParameters[MGJRouterParameterUserInfo][kMGJNavigationControllerKey] pushViewController:qaDetailVC animated:YES];
    }];
    
    // 在此添加其他页面的URL注册。
    
}

@end
