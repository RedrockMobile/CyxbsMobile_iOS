//
//  MineContentViewProtocol.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/30.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MineQADataItem;
@protocol MineContentViewProtocol <NSObject>

- (void)QAInfoRequestsSucceededWithItem:(MineQADataItem *)item;

@end

NS_ASSUME_NONNULL_END
