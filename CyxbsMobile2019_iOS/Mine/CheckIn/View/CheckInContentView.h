//
//  CheckInContentVIew.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/26.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckInModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckInContentView : UIView

// datas
@property (nonatomic, assign) NSInteger signInRank;

// views
@property (nonatomic, weak) UIView *checkInView;
@property (nonatomic, weak) UIView *storeView;

- (void)loadCheckInBarWithModel:(CheckInModel *)model;

@end

NS_ASSUME_NONNULL_END
