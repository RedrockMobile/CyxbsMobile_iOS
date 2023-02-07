//
//  ExpressPickPutModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExpressPickPutModel : NSObject
// statistic
@property (nonatomic, copy) NSDictionary *putStatistic;
// voted
@property (nonatomic, copy) NSString *putVoted;

@end

NS_ASSUME_NONNULL_END
