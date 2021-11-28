//
//  MGDClickParams.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/7/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "MGDClickParams.h"

@implementation MGDClickParams

-(instancetype)init {
    if ([super init]) {
        self.animationDuration = 1.2;
        self.enableFlashing = YES;
        self.circleCount = 7;
        self.circleTurnAngle = 180;
        self.circleDistanceMultiple = 2;
        self.smallCircleOffsetAngle = 0;
        self.smallCircleColor = [UIColor lightGrayColor];
        self.circleSize = 5;
        self.colorRandom = @[
                             [UIColor colorWithRed:255/255.0 green:255/255.0 blue:153/255.0 alpha:1],
                             [UIColor colorWithRed:255/255.0 green:204/255.0 blue:204/255.0 alpha:1],
                             [UIColor colorWithRed:153/255.0 green:102/255.0 blue:153/255.0 alpha:1],
                              [UIColor colorWithRed:153/255.0 green:102/255.0 blue:102/255.0 alpha:1],
                              [UIColor colorWithRed:255/255.0 green:255/255.0 blue:102/255.0 alpha:1],
                              [UIColor colorWithRed:244/255.0 green:67/255.0 blue:54/255.0 alpha:1],
                              [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1],
                             [UIColor colorWithRed:204/255.0 green:204/255.0 blue:0/255.0 alpha:1],
                             [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1],
                             [UIColor colorWithRed:153/255.0 green:153/255.0 blue:51/255.0 alpha:1]
                             ];
    }
    return self;
}
@end
