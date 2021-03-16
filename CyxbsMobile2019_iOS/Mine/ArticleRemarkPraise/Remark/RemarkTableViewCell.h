//
//  RemarkTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/2/21.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "MainPageTableViewCell.h"
#import "RemarkParseModel.h"
NS_ASSUME_NONNULL_BEGIN

/// 评论页面的cell
@interface RemarkTableViewCell : MainPageTableViewCell
@property (nonatomic, strong)RemarkParseModel *model;


@end

NS_ASSUME_NONNULL_END
