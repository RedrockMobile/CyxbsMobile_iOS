//
//  MyGoodsPresenter.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/5/1.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyGoodsProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGoodsPresenter : NSObject

@property (nonatomic, strong) UIViewController<MyGoodsProtocol> *view;

- (void)requestMyGoodsDataWithPage:(NSString *)page andSize:(NSString *)size;

- (void)attatchView:(UIViewController<MyGoodsProtocol> *)view;
- (void)dettatchView;

@end

NS_ASSUME_NONNULL_END
