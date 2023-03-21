//
//  AttitudeMainDefaultView.h
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/3/8.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AttitudeMainDefaultView : UIView
@property (nonatomic, strong) UIImageView *defaultView;
@property (nonatomic, strong) UILabel *defaultLabel;

- (instancetype)initWithDefaultPage;
@end

NS_ASSUME_NONNULL_END
