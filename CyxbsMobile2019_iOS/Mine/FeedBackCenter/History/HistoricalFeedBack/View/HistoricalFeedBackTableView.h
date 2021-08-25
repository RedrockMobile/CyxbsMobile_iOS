//
//  HistoricalFeedBackTableView.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
// view
#import "FeedBackTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
/**
 历史反馈的 table
 */
@interface HistoricalFeedBackTableView : UITableView

/// 只用做用来更新 cell 的个数
@property (nonatomic, assign) NSInteger row;

@end

NS_ASSUME_NONNULL_END
