//
//  MGDRefreshTool.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MGDRefreshTool.h"

@implementation MGDRefreshTool

+ (void)setUPHeader:(MJRefreshNormalHeader *)header AndFooter:(MJRefreshBackNormalFooter *)footer {
    //上滑加载的设置
    [footer setTitle:@"上滑加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"上滑加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在加载中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
    
    [header setTitle:@"正在刷新中………"forState:MJRefreshStateRefreshing];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
//    //刷新字体的深色模式适配
//    if (@available(iOS 11.0, *)) {
//        header.stateLabel.textColor = MGDTextColor1;
//        footer.stateLabel.textColor = MGDTextColor1;
//        } else {
//               // Fallback on earlier versions
//    }
}

+ (void)setUPHeader:(MJRefreshNormalHeader *)header {
    [header setTitle:@"正在刷新中………"forState:MJRefreshStateRefreshing];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
//    if (@available(iOS 11.0, *)) {
//        header.stateLabel.textColor = MGDTextColor1;
//        } else {
//               // Fallback on earlier versions
//    }
}

@end

