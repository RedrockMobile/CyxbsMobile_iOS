//
//  PostModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostModel : NSObject

@property (nonatomic, strong) NSMutableArray<PostItem *> *postArray;

- (void)handleDataWithPage:(NSInteger)page
                      Success:(void (^)(NSArray *arr))success
                      failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
