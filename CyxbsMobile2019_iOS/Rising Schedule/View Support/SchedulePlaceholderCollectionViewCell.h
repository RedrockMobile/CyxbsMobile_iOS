//
//  SchedulePlaceholderCollectionViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/3/13.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 复用标志
UIKIT_EXTERN NSString *SchedulePlaceholderCollectionViewCellReuseIdentifier;

@interface SchedulePlaceholderCollectionViewCell : UICollectionViewCell

@property (nonatomic) BOOL isError404;

@end

NS_ASSUME_NONNULL_END
