//
//  MinePresenter.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/31.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import<Foundation/Foundation.h>
#import "MineContentViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class MineModel;
@interface MinePresenter : NSObject

@property (nonatomic, strong) UIViewController<MineContentViewProtocol> *attachedView;
@property (nonatomic, strong) MineModel *model;

- (void)attachView:(UIViewController<MineContentViewProtocol> *)view;
- (void)detachView;
- (void)requestQAInfo;

@end

NS_ASSUME_NONNULL_END
