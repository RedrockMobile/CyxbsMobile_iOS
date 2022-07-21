//
//  JHMenuItem.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/9.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "JHMenuItem.h"

@implementation JHMenuItem

- (instancetype)initWithIndex:(NSUInteger)index{
    self = [super init];
    if (self) {
        _index = index;
        // 通用的一些配置
        [self configureView];
    }
    return self;
}

- (void)configureView {
    
}


#pragma mark - public method

- (void)setTitleColorforStateNormal:(UIColor *)normalColor
                   forStateSelected:(UIColor *)SelectedColor
{
    [self setTitleColor:normalColor
               forState:UIControlStateNormal];
    [self setTitleColor:SelectedColor
               forState:UIControlStateSelected];
}

@end
