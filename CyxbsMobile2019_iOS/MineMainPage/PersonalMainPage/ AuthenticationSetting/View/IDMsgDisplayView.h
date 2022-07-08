//
//  IDMsgDisplayView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/11/8.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDModel.h"

NS_ASSUME_NONNULL_BEGIN
// 纯展示身份数据的 View
@interface IDMsgDisplayView : UIView
/// 背景图片
@property (nonatomic, strong)UIImageView *backImgView;

/// 身份所属组织的label
@property (nonatomic, strong)UILabel *departmentLabel;

/// 身份的职位label
@property (nonatomic, strong)UILabel *positionLabel;

/// 身份有效期label
@property (nonatomic, strong)UILabel *validTimeLabel;

/// 数据model
@property (nonatomic, strong, nullable)IDModel *model;
@end

NS_ASSUME_NONNULL_END
