//
//  YearBtnsView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/3.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YearBtnsView;

@protocol YearBtnsViewDelegate <NSObject>

- (void)yearBtnsView:(YearBtnsView*)view didSelectedYear:(NSInteger)year;

@end


@interface YearBtnsView : UIView
@property(nonatomic, readonly, assign)NSInteger selectedYear;
@property(nonatomic, weak)id <YearBtnsViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
