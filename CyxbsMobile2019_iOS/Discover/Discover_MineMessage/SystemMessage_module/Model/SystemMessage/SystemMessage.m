//
//  SystemMessage.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/19.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SystemMessage.h"

#pragma mark - SystemMessage

@implementation SystemMessage

#pragma mark - Life cycle

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        // -- 等待接口，测试数据 --
        self.title = @"古谓冬至一阳始生，因以冬至至立春以前的一段时间为初阳";
        self.content = @"芜湖！芜湖！芜湖！芜湖！芜湖！芜湖！芜湖！芜湖！芜湖！芜湖！";
        self.date = @"2022-1-6";
        BOOL a = arc4random() % 6 < 3;
        self.hadRead = a;
    }
    return self;
}

@end
