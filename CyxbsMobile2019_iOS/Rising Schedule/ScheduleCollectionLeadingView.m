//
//  ScheduleCollectionLeadingView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/6.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCollectionLeadingView.h"

NSString *ScheduleCollectionLeadingViewReuseIdentifier = @"ScheduleCollectionLeadingView";

@implementation ScheduleCollectionLeadingView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.blueColor;
    }
    return self;
}


@end
