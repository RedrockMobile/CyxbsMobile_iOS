//
//  TimeTableViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VolunteerItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimeTableViewController : UITableViewController

@property (nonatomic, assign) BOOL vcCanScroll;
@property (nonatomic, strong) UIViewController *VC;
@property (nonatomic, strong)VolunteerItem *volunteer;
@property (nonatomic, strong) NSMutableArray *dataArray;
// 控制器索引值 用于确定年份，0为全部 1为今年， 2为去年，以此类推
@property (nonatomic, assign) NSInteger index;

- (instancetype)initWithVolunteer:(VolunteerItem *)volunteer andYearIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
