//
//  IDCardTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/10/1.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDModel.h"
#import "IDMsgDisplayView.h"

#import "PMPGestureScrollView.h"


NS_ASSUME_NONNULL_BEGIN

@class PMPIDCardTableViewCell;
@protocol PMPIDCardTableViewCellDelegate <NSObject>

- (void)settingButtonDidClicked:(UIButton *)button;
- (void)deleteButtonDidClicked:(UIButton *)button cell:(PMPIDCardTableViewCell *)cell;

@end

@interface PMPIDCardTableViewCell : UITableViewCell

@property (nonatomic, strong) PMPGestureScrollView * containerScrollView;

@property (nonatomic, weak) id <PMPIDCardTableViewCellDelegate> delegate;

@property (nonatomic, strong)IDMsgDisplayView *idMsgView;
/// 数据model
@property (nonatomic, strong)IDModel *model;

@end

NS_ASSUME_NONNULL_END
