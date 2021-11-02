//
//  ShareBtn.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface ShareBtn : UIButton

///图标
@property (nonatomic, strong) UIImageView *iconImage;
///标题
@property (nonatomic, strong) UILabel *title;

- (instancetype)initWithImage:(UIImage *)image AndName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
