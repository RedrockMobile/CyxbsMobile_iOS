//
//  FeedBackDetailsModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 反馈详情
 */
@interface FeedBackDetailsModel : NSObject

@property (nonatomic, assign) long date;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * contentText;
@property (nonatomic, assign) NSInteger imgCount;
@property (nonatomic, copy) NSString * type;

@end

NS_ASSUME_NONNULL_END