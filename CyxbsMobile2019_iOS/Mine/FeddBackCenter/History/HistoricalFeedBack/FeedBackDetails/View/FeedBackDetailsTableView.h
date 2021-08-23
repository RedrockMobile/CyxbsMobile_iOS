//
//  FeedBackDetailsTableView.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
// view
#import "FeedBackDetailsTableViewCell.h"
#import "FeedBackReplyTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
/**
 反馈的 table
 */
@interface FeedBackDetailsTableView : UITableView

/// 只用做用来更新 cell 的个数
@property (nonatomic, assign) NSInteger section;

@end

NS_ASSUME_NONNULL_END
