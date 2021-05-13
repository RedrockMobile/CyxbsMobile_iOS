//
//  SZHHotSearchButton.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/26.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SZHHotSearchButton.h"
#import "UIControl+MGD.h"
@interface SZHHotSearchButton()<UITraitEnvironment>

@end
@implementation SZHHotSearchButton
- (instancetype)init{
    self = [super init];
    if (self) {
        self.ignoreEvent = NO;
        self.canTapEventInterval = 0.5; //0.5秒内重复点击无效
        self.titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:13];
        
        //设置title颜色
        if (@available(iOS 11.0, *)) {
            [self setTitleColor:[UIColor colorNamed:@"SZHSearchBtnTextColor"] forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
        }
        
        //设置button宽度随title文本长度自适应
//        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        
//        /**约束会报警告，但是不影响显示*/
//        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).offset(MAIN_SCREEN_W * 0.03467);
//            make.right.equalTo(self).offset(-MAIN_SCREEN_W * 0.04267);
//        }];
        
        //圆角
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = MAIN_SCREEN_H * 0.0382 * 0.5;
        
        //边框宽度，不设置边框宽度就无法看到边框，以及边框颜色
        self.layer.borderWidth = 1;
        //设置边框颜色。边框颜深色模式需要手动调。见下方的代理方法
        self.layer.borderColor = [UIColor colorNamed:@"SZHSearchBtnTextColor"].CGColor;
    }
    return self;
}
//监听系统的颜色模式来配置的白天、深色模式下的样式
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [super traitCollectionDidChange: previousTraitCollection];
    if (@available(iOS 13.0, *)) {
        if([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]){
              UIUserInterfaceStyle  mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
                if (mode == UIUserInterfaceStyleDark) {
                    NSLog(@"深色模式");
                    self.layer.borderColor =  [UIColor colorNamed:@"SZHSearchBtnTextColor"].CGColor;
                } else if (mode == UIUserInterfaceStyleLight) {
                    NSLog(@"浅色模式");
                    self.layer.borderColor = [UIColor colorNamed:@"SZHSearchBtnTextColor"].CGColor;
                } else {
                    NSLog(@"未知模式");
                }
            
        }
    } else {
        // Fallback on earlier versions
    }
}
@end
