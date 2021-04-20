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

NS_ASSUME_NONNULL_BEGIN

@interface YYZTopicDetailVC : TopBarBasicViewController

- (instancetype)initWithId:(NSString *) topicID;
///背景蒙版
@property (nonatomic, strong) UIView *backViewWithGesture;

///多功能View
@property (nonatomic, strong) FuncView *popView;

///举报页面
@property (nonatomic, strong) ReportView *reportView;

///分享页面
@property (nonatomic, strong) ShareView *shareView;

@property (nonatomic, strong) PostItem *item;

@property(nonatomic,strong) NSString *topicIdString; //当前圈子名

@property(nonatomic,assign) NSInteger topicID;//当前圈子编号

@end
NS_ASSUME_NONNULL_END
