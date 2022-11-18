//
//  SearchPersonModel.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SearchPerson.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchPersonModel : NSObject

/// datasorse
@property (nonatomic, readonly, nonnull) NSArray <SearchPerson *> *personAry;

/// sets
@property (nonatomic, strong) NSSet <NSString *> *snoSet;

- (void)reqestWithInfo:(NSString *)info
               success:(void (^)(void))success
               failure:(void (^)(NSError *))failure;

- (void)removeSno:(NSString *)sno;

@end

NS_ASSUME_NONNULL_END
