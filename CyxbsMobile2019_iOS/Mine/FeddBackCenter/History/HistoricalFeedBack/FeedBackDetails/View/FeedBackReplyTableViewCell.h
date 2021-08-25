//
//  FeedBackReplyTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
// model
#import "FeedBackReplyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedBackReplyTableViewCell : UITableViewCell

/// 正文
@property (nonatomic, strong) UILabel * titleLabel;
/// 图片
@property (nonatomic, strong) UICollectionView * picturesCollectionView;

@property (nonatomic, strong) FeedBackReplyModel * cellModel;

- (CGFloat)height;

/// 复用标识
+ (NSString *)reuseIdentifier;

/// 将时间戳转化为字符串 @"YYYY/MM/dd HH:mm"
- (NSString *)getTimeFromTimestamp:(long)time;

@end

NS_ASSUME_NONNULL_END
