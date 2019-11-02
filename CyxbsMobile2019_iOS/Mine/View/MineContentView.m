//
//  MineContentView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/30.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "MineContentView.h"
#import "MineContentViewProtocol.h"

@interface MineContentView ()

@property (nonatomic, weak) id<MineContentViewProtocol> delegate;

@end

@implementation MineContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
        
        MineHeaderView *headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, 291)];
        [self addSubview:headerView];
        self.headerView = headerView;
    }
    return self;
}

@end
