//
//  DiscoverTodoTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/7.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoDataModel.h"
NS_ASSUME_NONNULL_BEGIN

/// 发现页todo的cell
@interface DiscoverTodoTableViewCell : UITableViewCell
@property (nonatomic, strong)TodoDataModel* dataModel;
@end

NS_ASSUME_NONNULL_END
