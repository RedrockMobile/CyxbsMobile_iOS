//
//  UILabel+Adapter.m
//  MoblieCQUPT_iOS
//
//  Created by 李展 on 2017/3/4.
//  Copyright © 2017年 Orange-W. All rights reserved.
//

#import "UILabel+Adapter.h"
#import <objc/runtime.h>
#import "UIFont+AdaptiveFont.h"
@implementation UILabel (Adapter)
-  (instancetype)adapterInitWithCoder:(NSCoder *)aDecoder{
    [self adapterInitWithCoder:aDecoder];
    if(self){
        self.font = [UIFont adaptFontSize:self.font.pointSize];
    }
    return self;
}


+ (void)load{
    Method method1 = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method method2 = class_getInstanceMethod([self class], @selector(adapterInitWithCoder:));
    method_exchangeImplementations(method1, method2);
}
@end
