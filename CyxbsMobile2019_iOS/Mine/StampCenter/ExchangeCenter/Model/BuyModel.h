//
//  BuyModel.h
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/9/5.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^Netblock)(id info);//1

@interface BuyModel : NSObject

@property (nonatomic, copy) Netblock Block;//2

-(void)buyGoodsWithID:(NSString *)ID;

@end

NS_ASSUME_NONNULL_END
