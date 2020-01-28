//
//  NotSetElectriceFeeButton.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/28.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotSetElectriceFeeButton : UIButton
@property (nonatomic, weak)UILabel *electricFeeTitle;//”电费查询“
@property (nonatomic, weak)UILabel *hintLabel;//“还未绑定账号哦～”
@end

NS_ASSUME_NONNULL_END
