//
//  NewQAMainPageMainController.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/7/14.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupItem.h"
#import "GroupModel.h"
#import "HotSearchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewQAMainPageMainController : UIViewController

@property (nonatomic, strong) GroupModel *groupModel;

@property (nonatomic, strong) NSMutableArray<GroupItem *> *dataArray;   // 我的关注数据源数组

@property (nonatomic, strong) HotSearchModel *hotWordModel;
@property (nonatomic, strong) NSMutableArray *hotWordsArray;
@property (nonatomic, assign) int hotWordIndex;

@property (nonatomic, assign) BOOL isNeedFresh;


@end

NS_ASSUME_NONNULL_END
