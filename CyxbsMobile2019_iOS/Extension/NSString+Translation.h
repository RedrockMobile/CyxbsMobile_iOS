//
//  NSString+Translation.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/6.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Translation)

+ (NSString *)translation:(NSString *)arebic;

+ (NSString *)arabicNumberalsFromChineseNumberals:(NSString *)arabic;

@end

NS_ASSUME_NONNULL_END
