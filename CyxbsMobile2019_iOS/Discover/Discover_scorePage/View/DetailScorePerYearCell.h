//
//  DetailScorePerYearCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/13.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailScorePerYearCell : UITableViewCell
@property (nonatomic, weak)UILabel *timeLabel;//2018-2019第一学年
@property (nonatomic, weak)UIView *blueBackgroundView;//淡蓝色背景

@property (nonatomic, weak)UILabel *averangePointLabel;//平均绩点
@property (nonatomic, weak)UILabel *averangePointTitleLabel;//"平均绩点"

@property (nonatomic, weak)UILabel *averangeScoreLabel;//平均成绩
@property (nonatomic, weak)UILabel *averangeScoreTitleLabel;//"平均成绩"

@property (nonatomic, weak)UILabel *averangeRankLabel;//平均排名
@property (nonatomic, weak)UILabel *averangeRankTitleLabel;//平均排名

@property (nonatomic, weak)UIButton *watchMoreButton;//“查看各科成绩”
@end

NS_ASSUME_NONNULL_END
