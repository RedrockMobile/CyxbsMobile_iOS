//
//  JHMenuItem.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/9.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMenuItem : UIButton


@property (nonatomic, assign) NSUInteger index;


- (instancetype)initWithIndex:(NSUInteger)index;

- (void)setTitleColorforStateNormal:(UIColor *)normalColor
                   forStateSelected:(UIColor *)SelectedColor;

@end

NS_ASSUME_NONNULL_END
