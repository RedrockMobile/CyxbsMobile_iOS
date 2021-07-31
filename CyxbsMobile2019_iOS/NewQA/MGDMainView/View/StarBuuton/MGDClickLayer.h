//
//  MGDClickLayer.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/7/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGDClickLayer : CALayer

@property(nonatomic, assign)double animationDuration;
@property(nonatomic, assign)BOOL clicked;

-(void)startAnimation;

@end

NS_ASSUME_NONNULL_END
