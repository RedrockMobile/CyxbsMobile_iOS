//
//  IntegralStoreCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/19.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class IntegralStoreDataItem;
@interface IntegralStoreCell : UICollectionViewCell

@property (nonatomic, strong) IntegralStoreDataItem *item;

@property (nonatomic, weak) UIButton *buyButton;

@end

NS_ASSUME_NONNULL_END
