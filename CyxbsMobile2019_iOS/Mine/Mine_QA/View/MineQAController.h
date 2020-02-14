//
//  MineQAController.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/22.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MineQAPresenter;
@interface MineQAController : UIViewController

@property (nonatomic, strong) MineQAPresenter *presenter;

@property (nonatomic, copy) NSArray<NSString *> *subTitles;

@end

NS_ASSUME_NONNULL_END
