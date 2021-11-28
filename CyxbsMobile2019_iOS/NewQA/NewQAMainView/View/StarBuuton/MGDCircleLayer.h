//
//  MGDCircleLayer.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/7/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MGDClickParams.h"
#import "MGDClickLayer.h"
#import "MGDClickCoreLayer.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^endAnimation)(void);
@interface MGDCircleLayer : CALayer

@property(nonatomic, strong)MGDClickParams *params;
@property (nonatomic, copy)endAnimation endAnim;
-(void)startAnimation;

@end

NS_ASSUME_NONNULL_END
