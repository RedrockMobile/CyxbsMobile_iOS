//
//  FeedBackDetailsTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
// model
#import "FeedBackDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN
/**
 反馈详情的 cell
 */
@interface FeedBackDetailsTableViewCell : UITableViewCell

/// 标题
@property (nonatomic, strong) UILabel * titleLabel;
/// 正文
@property (nonatomic, strong) UILabel * subtitleLabel;
/// separator
@property (nonatomic, strong) UIView * separateLine;
/// 问题类型
@property (nonatomic, strong) UILabel * typeLabel;
/// 图片
@property (nonatomic, strong) UICollectionView * picturesCollectionView;

@property (nonatomic, strong) FeedBackDetailsModel * cellModel;

/// 复用标识
+ (NSString *)reuseIdentifier;

/// 将时间戳转化为字符串 @"YYYY/MM/dd HH:mm"
- (NSString *)getTimeFromTimestamp:(long)time;

@end

NS_ASSUME_NONNULL_END
