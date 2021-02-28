//
//  ActivityTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VolunteerLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) VolunteerLabel *activityLabel;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *countdownLabel;

@end

NS_ASSUME_NONNULL_END
