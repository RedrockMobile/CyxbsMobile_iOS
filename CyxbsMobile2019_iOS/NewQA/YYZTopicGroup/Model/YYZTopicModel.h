//
//  YYZTopicModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 杨远舟 on 2021/4/10.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYZTopicModel : NSObject

@property (nonatomic,strong)NSMutableArray<PostItem *> *postArray;

- (void)loadTopicWithLoop:(NSInteger)loop AndPage:(NSInteger)page AndSize:(NSInteger)size AndType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
