//
//  LZWeekScrollView.h
//  MoblieCQUPT_iOS
//
//  Created by 李展 on 2017/8/25.
//  Copyright © 2017年 Orange-W. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LZWeekScrollViewDelegate <NSObject>

@required

- (void)eventWhenTapAtIndex:(NSInteger)index;

@end

@interface LZWeekScrollView : UIScrollView
@property (nonatomic, weak) id<LZWeekScrollViewDelegate> eventDelegate;
@property (nonatomic, copy) NSArray <NSString *> *titles;
@property (nonatomic, readonly) NSInteger currentIndex;
@property (nonatomic, readonly) NSString *currentIndexTitle;

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray <NSString *> *)titles;

- (void)scrollToIndex:(NSInteger)index;

@end
