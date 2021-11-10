//
//  NewQAHud.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "NewQAHud.h"

@implementation NewQAHud

+ (void)showHudWith:(NSString *)title AddView:(UIView *)view{
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    [hud hide:YES afterDelay:1.4];
    hud.margin = 8;
    [hud setYOffset:-SCREEN_HEIGHT * 0.26];
    hud.labelFont = [UIFont fontWithName:@"PingFangSC-Medium" size: 11];
    [hud setColor:[UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1.0]];
    hud.height = SCREEN_WIDTH * 0.3147 * 29/118;
    hud.cornerRadius = hud.frame.size.height * 0.5;
}

+ (void)showHudWith:(NSString *)title AddView:(UIView *)view AndToDo:(void(^)(void))block {
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    [hud hide:YES afterDelay:1.4];
    hud.margin = 8;
    [hud setYOffset:-SCREEN_HEIGHT * 0.26];
    hud.labelFont = [UIFont fontWithName:@"PingFangSC-Medium" size: 11];
    [hud setColor:[UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1.0]];
    hud.height = SCREEN_WIDTH * 0.3147 * 29/118;
    hud.cornerRadius = hud.frame.size.height * 0.5;
    hud.completionBlock = block;
}

+ (void)showHudAtWindowWithStr:(NSString *)title enableInteract:(BOOL)is {
    [self _showHudAt:UIApplication.sharedApplication.windows.firstObject withStr:title enableInteract:is completion:nil];
}

+ (void)showHudAt:(nullable UIView *)view withStr:(NSString *)title enableInteract:(BOOL)is completion:(void(^)(void))block {
    [self _showHudAt:view withStr:title enableInteract:is completion:block];
}

///MARK: - 供内部使用的方法
+ (void)_showHudAt:(nullable UIView * )view withStr:(NSString *)title enableInteract:(BOOL)is completion:(nullable void(^)(void))block {
    if (title==nil) {
        return;
    }
    if (view==nil) {
        view = UIApplication.sharedApplication.windows.firstObject;
    }
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    [hud hide:YES afterDelay:1.4];
    hud.margin = 8;
    hud.userInteractionEnabled = !is;
    [hud setYOffset:-SCREEN_HEIGHT * 0.26];
    hud.labelFont = [UIFont fontWithName:PingFangSCMedium size: 11];
    [hud setColor:[UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1.0]];
    hud.height = SCREEN_WIDTH * 0.07734152542;
    hud.cornerRadius = hud.frame.size.height * 0.5;
    if (block!=nil) {
        hud.completionBlock = block;
    }
}

@end
