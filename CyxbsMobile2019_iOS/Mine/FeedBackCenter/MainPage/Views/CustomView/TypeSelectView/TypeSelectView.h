//
//  TypeSelectView.h
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/25.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeButton.h"


NS_ASSUME_NONNULL_BEGIN

@interface TypeSelectView : UIView <TypeButtonDelegate>

@property (nonatomic,strong) TypeButton *recommendBtn;
@property (nonatomic,strong) TypeButton *systemProblemBtn;
@property (nonatomic,strong) TypeButton *profileProblemBtn;
@property (nonatomic,strong) TypeButton *otherBtn;

@property (nonatomic,copy) void(^select)(TypeButton *sender);

@end

NS_ASSUME_NONNULL_END
