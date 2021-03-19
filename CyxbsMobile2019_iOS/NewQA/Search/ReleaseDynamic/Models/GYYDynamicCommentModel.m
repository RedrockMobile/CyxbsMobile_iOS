//
//  GYYDynamicCommentModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 郭蕴尧 on 2021/1/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "GYYDynamicCommentModel.h"

@implementation GYYDynamicCommentModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"reply_list":[self class]
    };
}

@end
