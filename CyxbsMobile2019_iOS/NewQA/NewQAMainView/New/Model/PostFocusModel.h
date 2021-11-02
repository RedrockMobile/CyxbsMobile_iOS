//
//  PostFocusModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/10/7.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostFocusModel : NSObject

@property (nonatomic, strong) NSMutableArray<PostItem *> *postArray;

- (void)handleFocusDataWithPage:(NSInteger)page
                      Success:(void (^)(NSArray *arr))success
                      failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
