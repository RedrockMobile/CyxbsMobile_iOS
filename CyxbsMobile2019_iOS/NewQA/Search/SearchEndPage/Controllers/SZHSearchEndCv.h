//
//  SZHSearchEndCv.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/27.
//  Copyright © 2021 Redrock. All rights reserved.
//
/**
 搜索结果页，主要是知识库、搜索结果table
 
 1.点击举报功能后，举报的view随键盘上下移动的功能由通知中心监听键盘出现、消失的时候去改变举报view的布局
 <注>：在willApper里面注册通知者，willDisapper里面移除通知中心。以防止在其他页面的相同通知会调用本界面的方法
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZHSearchEndCv : UIViewController
/// 相关动态列表的数据源数组
@property (nonatomic, strong) NSArray *tableDataAry;

/// 重邮知识库的内容数组
@property (nonatomic, strong) NSArray *knowlegeAry;

/// 搜索的文字
@property (nonatomic, copy) NSString *searchStr;
@end

NS_ASSUME_NONNULL_END
