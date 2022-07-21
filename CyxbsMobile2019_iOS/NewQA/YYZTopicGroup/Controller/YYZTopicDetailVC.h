//
//  YYZTopicDetailVC.h
//  CyxbsMobile2019_iOS
//
//  Created by 杨远舟 on 2021/3/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "TopBarBasicViewController.h"
#import "ReportView.h"
#import "ShareView.h"
#import "FuncView.h"
#import "PostItem.h"
#import "SelfFuncView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYZTopicDetailVC : TopBarBasicViewController

///背景蒙版
@property (nonatomic, strong) UIView *backViewWithGesture;

///多功能View -- 他人
@property (nonatomic, strong) FuncView *popView;

///多功能View -- 自己
@property (nonatomic, strong) SelfFuncView *selfPopView;

@property (nonatomic, strong) NSMutableArray *heightArray;
///举报页面
@property (nonatomic, strong) ReportView *reportView;

///分享页
@property (nonatomic, strong) ShareView *shareView;

@property (nonatomic, strong) PostItem *item;

@property(nonatomic,strong) NSString *topicIdString; //当前圈子名

@property(nonatomic,assign) NSInteger topicID;//当前圈子编号

@property(nonatomic,assign) NSInteger isFromSub;//是否从发布页跳转

@end
NS_ASSUME_NONNULL_END
