//
//  HotSearchModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Netblock)(id info);

@interface HotSearchModel : NSObject <NSCoding>

@property (nonatomic, copy) Netblock Block;

@property (nonatomic, strong) NSMutableArray *hotWordsArray;

- (void)getHotSearchArray;

@end

NS_ASSUME_NONNULL_END
