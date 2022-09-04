//
//  ScheduleInteractorMain.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScheduleCollectionViewLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleInteractorMain : NSObject <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    ScheduleCollectionViewLayoutDelegate
>

@end

NS_ASSUME_NONNULL_END
