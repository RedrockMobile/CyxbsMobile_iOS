//
//  TimeTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VolunteerLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimeTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *bigCircle;
@property (nonatomic, strong) UIView *smallCircle;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) VolunteerLabel *volunteerLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UIImageView *areaImageView;
@property (nonatomic, strong) UIImageView *groupImageView;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UILabel *groupLabel;

@end

NS_ASSUME_NONNULL_END
