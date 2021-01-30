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
    [hud hide:YES afterDelay:1.2];
    hud.margin = 11;
    [hud setYOffset:-SCREEN_HEIGHT * 0.26];
    hud.labelFont = [UIFont fontWithName:@"PingFangSC-Medium" size: 11];
    [hud setColor:[UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1.0]];
    hud.cornerRadius = SCREEN_HEIGHT * 0.0435 * 1/2;
}

@end
