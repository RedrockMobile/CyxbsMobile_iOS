//
//  JWZXNewsModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "JWZXNewsModel.h"

#pragma mark - JWZXNewsModel

@implementation JWZXNewsModel

- (instancetype)initWithRootNews:(JWZXSectionNews *)sectionNews {
    if (sectionNews == nil) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.sectionNewsAry = [NSMutableArray arrayWithArray:@[sectionNews]];
    }
    return self;
}

- (void)requestMoreSuccess:(void (^)(BOOL))success
                   failure:(void (^)(NSError * _Nonnull))failure {
    [JWZXSectionNews
     requestWithPage:self.sectionNewsAry.lastObject.page + 1
     success:^(JWZXSectionNews * _Nullable sectionNews) {
        if (!sectionNews || sectionNews.page == self.sectionNewsAry.lastObject.page) {
            if (success) {
                success(NO);
            }
            return;
        }
        
        [self.sectionNewsAry addObject:sectionNews];
        if (success) {
            success(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"🔴%s:\n%@", __func__, error);
        if (failure) {
            failure(error);
        }
    }];
}

@end
