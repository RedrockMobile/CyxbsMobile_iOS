//
//  HeaderGifRefresh.m
//  MoblieCQUPT_iOS
//
//  Created by MaggieTang on 22/10/2017.
//  Copyright © 2017 Orange-W. All rights reserved.
//

#import "HeaderGifRefresh.h"

@implementation HeaderGifRefresh
- (void)prepare{
    
    [super prepare];
    NSMutableArray *normalImages = [NSMutableArray array];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"1"]];
        [normalImages addObject:image];
    
    
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=7; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", i]];
        [refreshingImages addObject:image];
    }
    
    [self setImages:normalImages forState:MJRefreshStateIdle];
    [self setImages:normalImages forState:MJRefreshStatePulling];
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
}
@end
