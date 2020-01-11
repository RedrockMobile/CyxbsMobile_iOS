//
//  CheckInBar.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CheckInModel;

@interface CheckInBar : UIView

@property (nonatomic, copy) NSMutableArray<UIView *> *dotArray;
@property (nonatomic, copy) NSMutableArray<UIView *> *barArray;

- (instancetype)initWithCheckInModel:(CheckInModel *)model;

@end

NS_ASSUME_NONNULL_END
