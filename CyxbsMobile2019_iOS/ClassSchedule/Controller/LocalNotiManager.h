//
//  LocalNotiManager.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/27.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
NS_ASSUME_NONNULL_BEGIN

@interface LocalNotiManager : NSObject
+ (void)setLocalNotiWithWeekNum:(int)weekNum weekDay:(int)weekDay lesson:(int)lesson before:(int)minute titleStr:(NSString*)title subTitleStr:(NSString* _Nullable)subTitleStr bodyStr:(NSString*)body ID:(NSString*)idStr;
@end

NS_ASSUME_NONNULL_END
