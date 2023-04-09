//
//  ScheduleEventTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/4/8.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *ScheduleEventTableViewCellReuseIdentifier;

@class ScheduleEventTableViewCell;

#pragma mark - <ScheduleEventTableViewCellDelegate>

@protocol ScheduleEventTableViewCellDelegate <NSObject>

@optional

- (void)tableViewCell:(ScheduleEventTableViewCell *)cell didResponseSwitch:(UISwitch *)swi;

@end

#pragma mark - ScheduleEventTableViewCell

@interface ScheduleEventTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *title;

@property (nonatomic) BOOL switchOn;

@property (nonatomic, weak) id <ScheduleEventTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
