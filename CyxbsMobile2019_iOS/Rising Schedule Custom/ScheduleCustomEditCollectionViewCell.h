//
//  ScheduleCustomEditCollectionViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/2/28.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 复用标志
UIKIT_EXTERN NSString *ScheduleCustomEditCollectionViewCellReuseIdentifier;

@interface ScheduleCustomEditCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
