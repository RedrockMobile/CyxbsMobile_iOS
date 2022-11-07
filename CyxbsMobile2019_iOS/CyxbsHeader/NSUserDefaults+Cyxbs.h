//
//  NSUserDefaults+Cyxbs.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/5.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (Cyxbs)

/// 和widget共享的degaults
@property (nonatomic, readonly, class) NSUserDefaults *widgetUserDefaults;

@end

NS_ASSUME_NONNULL_END
