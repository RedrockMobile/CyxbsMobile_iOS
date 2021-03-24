//
//  RecommentLabel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/3/22.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "RecommentLabel.h"

@implementation RecommentLabel

- (void)drawRect:(CGRect)rect {
    CGRect frame = CGRectMake(rect.origin.x + SCREEN_WIDTH * 0.0427, rect.origin.y + SCREEN_WIDTH * 0.0427 * 10/16, rect.size.width , rect.size.height);
   [super drawTextInRect:frame];
}

@end
