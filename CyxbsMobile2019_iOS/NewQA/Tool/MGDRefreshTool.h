//
//  MGDRefreshTool.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGDRefreshTool : NSObject

+ (void)setUPHeader:(MJRefreshNormalHeader *)header AndFooter:(MJRefreshBackNormalFooter *)footer;
+ (void)setUPHeader:(MJRefreshNormalHeader *)header;
@end

NS_ASSUME_NONNULL_END

