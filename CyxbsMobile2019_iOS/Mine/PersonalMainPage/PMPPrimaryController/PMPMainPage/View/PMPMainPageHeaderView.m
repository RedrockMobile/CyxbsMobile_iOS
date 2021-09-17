//
//  PMPMainPageHeaderView.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPMainPageHeaderView.h"

@interface PMPMainPageHeaderView ()

/**
 大约占 2/5 和3/5
 */

/// 透明层
@property (nonatomic, strong) UIView * transparentMaskView;
/// 半透明层
@property (nonatomic, strong) UIView * translucentMaskView;


@end

@implementation PMPMainPageHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

@end
