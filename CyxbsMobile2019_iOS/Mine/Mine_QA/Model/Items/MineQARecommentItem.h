//
//  MineQARecommentItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/17.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineQARecommentItem : NSObject

@property (nonatomic, copy) NSString *questionID;
@property (nonatomic, copy) NSString *answerID;
@property (nonatomic, copy) NSString *commentContent;
@property (nonatomic, copy) NSString *commenterNicname;
@property (nonatomic, copy) NSString *commenterImageURL;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
