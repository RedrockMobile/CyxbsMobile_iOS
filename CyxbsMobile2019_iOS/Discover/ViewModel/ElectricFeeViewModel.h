//
//  ElectricFeeViewModel.h
//  MoblieCQUPT_iOS
//
//  Created by 千千 on 2019/10/28.
//  Copyright © 2019 Orange-W. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ElectricFeeModel.h"
@class LQQGlanceView;
NS_ASSUME_NONNULL_BEGIN

@interface ElectricFeeViewModel : NSObject
@property(nonatomic, copy)NSString *money;
@property(nonatomic, copy)NSString *degree;
@property(nonatomic, copy)NSString *time;

- (void) bindView:(LQQGlanceView*)view;
@end

NS_ASSUME_NONNULL_END
