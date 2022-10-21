//
//  ScheduleDetailMessageTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/18.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 复用标志
UIKIT_EXTERN NSString *ScheduleDetailMessageTableViewCellReuseIdentifier;

#pragma mark - ScheduleDetailMessageTableViewCell

@interface ScheduleDetailMessageTableViewCell : UITableViewCell

/// 左边视图
@property (nonatomic, copy) NSString *leftDescription;

/// 右边细节
@property (nonatomic, copy) NSString *rightDetail;

@end

NS_ASSUME_NONNULL_END
