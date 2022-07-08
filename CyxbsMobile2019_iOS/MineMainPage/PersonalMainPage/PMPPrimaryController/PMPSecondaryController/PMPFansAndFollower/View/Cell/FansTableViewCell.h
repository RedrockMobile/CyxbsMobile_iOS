//
//  FansTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/9/26.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "BaseTableViewCell.h"
// model
#import "FansAndFollowersModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 继承自 "BaseTableViewCell.h"
 * 隐藏 titleImgVie, rightIndicator
 */

@interface FansTableViewCell : BaseTableViewCell

@property (nonatomic, strong) FansAndFollowersModel * cellModel;

@end

NS_ASSUME_NONNULL_END
