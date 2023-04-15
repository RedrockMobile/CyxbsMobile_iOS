//
//  ScheduleEventTableViewHeaderView.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/4/4.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *ScheduleEventTableViewHeaderViewReuseIdentifier;

@class ScheduleEventTableViewHeaderView;

#pragma mark - <ScheduleEventTableViewHeaderViewDelegate>

@protocol ScheduleEventTableViewHeaderViewDelegate <NSObject>

@optional

- (void)tableViewHeaderView:(ScheduleEventTableViewHeaderView *)view didResponseBtn:(UIButton *)btn;

@end

#pragma mark - ScheduleEventTableViewHeaderView

@interface ScheduleEventTableViewHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *btnDetail;

@property (nonatomic) NSInteger section;

@property (nonatomic, weak) id <ScheduleEventTableViewHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
