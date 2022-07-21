//
//  PMPPostItem.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/11/3.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PostItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PMPPostItem : PostItem

@property (nonatomic, assign) BOOL is_focus;

@property (nonatomic, assign) BOOL is_be_focused;

@property (nonatomic, copy) NSMutableDictionary * itemMDict;

+ (void)getDataWithPage:(NSInteger)page
                  Redid:(NSString *)redid
                success:(void (^)(NSArray * dataAry))success
                failure:(void (^)(void))failure;

@end

NS_ASSUME_NONNULL_END
