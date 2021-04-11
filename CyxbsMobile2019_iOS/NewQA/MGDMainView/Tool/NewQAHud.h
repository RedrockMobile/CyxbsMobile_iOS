//
//  NewQAHud.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewQAHud : NSObject

+ (void)showHudWith:(NSString *)title AddView:(UIView *)view;

+ (void)showHudWith:(NSString *)title AddView:(UIView *)view AndToDo:(void(^)(void))block;

@end

NS_ASSUME_NONNULL_END
