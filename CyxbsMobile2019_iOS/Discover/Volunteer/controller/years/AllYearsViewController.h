//
//  AllYearsViewController.h
//  MoblieCQUPT_iOS
//
//  Created by 方昱恒 on 2019/7/14.
//  Copyright © 2019 Orange-W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VolunteerItem.h"
#import "VolunteeringEventItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface AllYearsViewController : BaseViewController

@property (nonatomic, copy) NSArray *mutableArray;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) VolunteerItem *volunteer;

// 控制器索引值 用于确定年份，0为全部 1为今年， 2为去年，以此类推
@property (nonatomic, assign) NSInteger index;

- (instancetype)initWithVolunteer:(VolunteerItem *)volunteer andYearIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
