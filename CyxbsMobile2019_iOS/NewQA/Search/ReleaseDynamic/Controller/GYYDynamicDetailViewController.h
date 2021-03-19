//
//  GYYDynamicDetailViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 郭蕴尧 on 2021/1/28.
//  Copyright © 2021 Redrock. All rights reserved.
//  动态详情页面

#import <UIKit/UIKit.h>
#import "PostItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYYDynamicDetailViewController : UIViewController
/**以下动态 数据，或post_id 最少填一种。默认取item*/
@property(nonatomic, strong) PostItem *item;
@property (nonatomic,assign) int post_id;//帖子ID
@end

NS_ASSUME_NONNULL_END
