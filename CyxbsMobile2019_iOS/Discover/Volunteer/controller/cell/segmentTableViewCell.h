//
//  segmentTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VolunteerItem.h"
#import "TimeTableViewController.h"
#import "ActivityTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

///志愿活动和志愿时长的选择器（我选择做成一个特殊的cell，放在tableView的第一个group里）

@protocol segmentTableViewCellDelegate <NSObject>

///segment选择器的滑动
- (void)segmentScrollViewDidScroll:(UIScrollView *)scrollView;

///segment选择器结束滑动
- (void)segmentScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

@interface segmentTableViewCell : UITableViewCell

@property (nonatomic,strong) UIViewController *VC;

- (void)configScrollView;

@property (nonatomic, strong, readonly) UIScrollView *scrollView;

///是否可以被滑动
@property (nonatomic, assign) BOOL objectCanScroll;
///当前被选择的tableViewController（NO为0，YES为1）
@property (nonatomic, assign) BOOL isSelectIndex;

@property (nonatomic, strong) VolunteerItem *volunteer;

///志愿时长和志愿活动
@property (nonatomic, strong) TimeTableViewController *timeVC;
@property (nonatomic, strong) ActivityTableViewController *activityVC;

@property (nonatomic,weak) id<segmentTableViewCellDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithVolunteerItem: (VolunteerItem *)volunteer Andindex:(NSString *) index;

@end

NS_ASSUME_NONNULL_END
