//
//  IgnoreDataModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/3.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IgnoreDataModel : NSObject
@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,copy)NSString *introduction;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *uid;
- (instancetype)initWithDict:(NSDictionary*)dict;
@end

NS_ASSUME_NONNULL_END
