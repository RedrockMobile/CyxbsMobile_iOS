//
//  DeletePostModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/4/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Netblock)(id info);

@interface DeletePostModel : NSObject

@property (nonatomic, copy) Netblock Block;

- (void)deletePostWithID:(NSNumber *)postID AndModel:(NSNumber *)model;

@end

NS_ASSUME_NONNULL_END
