//
//  MineContentView.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/30.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MineContentViewDelegate <NSObject>

- (void)editButtonClicked;

@end

@interface MineContentView : UIView

@property (nonatomic, weak) UITableView *settingsTableView;
@property (nonatomic, weak) MineHeaderView *headerView;
@property (nonatomic, weak) id<MineContentViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
