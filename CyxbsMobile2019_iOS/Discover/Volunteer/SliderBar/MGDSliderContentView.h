//
//  MGDSliderContentView.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MGDSliderContentViewScrollCallback)(NSInteger index);

@protocol MGDSliderContentViewDataSource;

@interface MGDSliderContentView : UIView

@property (nonatomic, weak)id<MGDSliderContentViewDataSource> dataSource;

- (void)sliderContentViewScrollFinished:(MGDSliderContentViewScrollCallback)callback;

- (void)scrollSliderContentViewToIndex:(NSInteger)index;

@end

@protocol MGDSliderContentViewDataSource <NSObject>

- (UIViewController *)sliderContentView:(MGDSliderContentView *)contentView viewControllerForIndex:(NSInteger)index;

- (NSInteger)numOfContentView;

@end

NS_ASSUME_NONNULL_END
