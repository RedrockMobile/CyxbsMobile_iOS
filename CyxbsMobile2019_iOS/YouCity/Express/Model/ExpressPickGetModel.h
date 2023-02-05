//
//  ExpressPickGetModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExpressPickGetModel : NSObject
// id
@property (nonatomic, copy) NSNumber *getId;
// title
@property (nonatomic, copy) NSString *title;
// choices
@property (nonatomic, copy) NSArray *choices;
// voted
@property (nonatomic, copy) NSString *getVoted;
// statistic
@property (nonatomic, copy) NSDictionary *getStatistic;
//@property (nonatomic, copy) NSString *statisticStr;
//@property (nonatomic, copy) NSNumber *statisticNum;

@end

NS_ASSUME_NONNULL_END
