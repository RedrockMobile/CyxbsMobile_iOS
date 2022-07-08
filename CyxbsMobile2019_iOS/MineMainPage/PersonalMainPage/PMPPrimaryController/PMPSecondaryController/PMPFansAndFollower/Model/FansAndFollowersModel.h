//
//  FansAndFollowersModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/11/6.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FansAndFollowersModel : NSObject

@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, assign) BOOL is_focus;
@property (nonatomic, copy) NSString * introduction;
@property (nonatomic, strong) NSString * redid;
@property (nonatomic, strong) NSString * stuNum;

+ (void)getDataWithRedid:(NSString*)redid
                 Success:(void (^)(NSArray * fans, NSArray * followers))success
                  Failure:(void (^)(void))failure;

@end

NS_ASSUME_NONNULL_END
