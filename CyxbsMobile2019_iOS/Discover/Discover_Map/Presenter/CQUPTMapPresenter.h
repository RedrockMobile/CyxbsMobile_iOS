//
//  CQUPTMapPresenter.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQUPTMapViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class CQUPTMapModel;
@interface CQUPTMapPresenter : NSObject

@property (nonatomic, strong) UIViewController<CQUPTMapViewProtocol> *view;
@property (nonatomic, strong) CQUPTMapModel *model;

- (void)attachView:(UIViewController<CQUPTMapViewProtocol> *)view;
- (void)detachView;


/// 加载地图信息，包含每一个地点的详细位置，id，Hot Place等
- (void)requestMapData;

@end

NS_ASSUME_NONNULL_END
