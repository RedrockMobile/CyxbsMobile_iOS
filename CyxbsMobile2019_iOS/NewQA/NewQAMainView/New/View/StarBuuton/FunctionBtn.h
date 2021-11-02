//
//  FunctionBtn.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGDClickParams.h"
#import "MGDClickLayer.h"
#import "MGDClickCoreLayer.h"
#import "MGDCircleLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface FunctionBtn : UIButton

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *countLabel;

// 按钮特效的设置
@property(nonatomic, strong)MGDClickParams *params;
@property(nonatomic, assign)BOOL isChoose;
@property (nonatomic, assign) BOOL isFirst;

//-(void)setClicked:(BOOL)clicked animated:(BOOL)animated;

- (void)setIconViewSelectedImage:(UIImage *)selectedImage AndUnSelectedImage:(UIImage *)unSelectedImnage;

@end

NS_ASSUME_NONNULL_END
