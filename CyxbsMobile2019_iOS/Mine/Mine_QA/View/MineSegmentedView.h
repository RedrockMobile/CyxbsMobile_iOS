//
//  MineSegmentedView.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/22.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MineQATableViewController;
@interface MineSegmentedView : UIView

@property (nonatomic, copy) NSArray<MineQATableViewController *> *childViewControllers;

- (instancetype)initWithChildViewControllers:(NSArray *)childViewControllers;

@end

NS_ASSUME_NONNULL_END
