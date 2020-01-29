//
//  MineQADataItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineQADataItem : NSObject

@property (nonatomic, copy) NSString *askNum;
@property (nonatomic, copy) NSString *answerNum;
@property (nonatomic, copy) NSString *commentNum;
@property (nonatomic, copy) NSString *praiseNum;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (NSString *)archivePath;
- (void)archiveItem;

@end

NS_ASSUME_NONNULL_END
