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

NS_ASSUME_NONNULL_BEGIN
/// 纯展示数据的 cell，无交互
@interface IDCardTableViewCell : UITableViewCell

@property (nonatomic, strong)IDMsgDisplayView *idMsgView;

/// 数据model
@property (nonatomic, strong)IDModel *model;

@end

NS_ASSUME_NONNULL_END
