//
//  NewQAFollowTableView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/9/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NewQAFollowTableView.h"

@implementation NewQAFollowTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorNamed:@"TableViewBackColor"];
//        self.estimatedRowHeight = 130;
    }
    return self;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
}



- (void)setContentOffset:(CGPoint)contentOffset {
    if (self.window) {
        [super setContentOffset:contentOffset];
    }
}

@end
