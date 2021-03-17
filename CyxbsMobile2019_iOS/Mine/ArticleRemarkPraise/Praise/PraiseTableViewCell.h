//
//  PraiseTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/1/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "MainPageTableViewCell.h"
#import "PraiseParseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 获赞页面的cell
@interface PraiseTableViewCell : MainPageTableViewCell
@property (nonatomic, strong)PraiseParseModel *model;
@end

NS_ASSUME_NONNULL_END
