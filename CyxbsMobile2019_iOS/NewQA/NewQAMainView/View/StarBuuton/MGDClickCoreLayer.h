//
//  MGDClickCoreLayer.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/7/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MGDClickParams.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGDClickCoreLayer : CALayer

@property(nonatomic,strong)MGDClickParams *params;
-(instancetype)initFrame:(CGRect )frame params:(MGDClickParams *)params;
-(void)startAnimation;


@end

NS_ASSUME_NONNULL_END
