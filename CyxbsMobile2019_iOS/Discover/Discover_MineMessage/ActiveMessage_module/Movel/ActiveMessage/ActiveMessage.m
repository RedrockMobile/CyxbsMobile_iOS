//
//  ActiveMessage.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/20.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ActiveMessage.h"

@implementation ActiveMessage

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.title = @"ByteDance & SSR % ByteDance & SSR % ByteDance & SSR % ByteDance & SSR %";
        NSString *a;
        switch (arc4random() % 4) {
            case 0:a = @"1行"; break;
            case 1:a = @"1行\n2行"; break;
            case 2:a = @"1行\n2行\n3行"; break;
            case 3:a = @"1行\n2行\n3行\n4行"; break;
        }
        self.content = a;
        self.userHeadURL = @"https://su.bcebos.com/shitu-query-nj/2022-04-20/11/64db8abd9ac624ea?authorization=bce-auth-v1%2F7e22d8caf5af46cc9310f1e3021709f3%2F2022-04-20T03%3A30%3A42Z%2F300%2F%2Fab611608ba67dc09950a683c98d214c3c29c712f2b17e2f036aae0593b1b2c3a";
        self.author = @"诶嘿！诶嘿！诶嘿！诶嘿！诶嘿！诶嘿！诶嘿！诶嘿！诶嘿！";
        self.date = @"2022-4-1";
        self.imgURL = @"https://su.bcebos.com/shitu-query-nj/2022-04-20/11/c49602c32ae37e87?authorization=bce-auth-v1%2F7e22d8caf5af46cc9310f1e3021709f3%2F2022-04-20T03%3A36%3A17Z%2F300%2F%2F58b46b4b717fd50311fd80f14e77ff19352e2577436c5c87160c4cd0e2284bdd";
        BOOL h = arc4random() % 6 < 3;
        self.hadRead = h;
    }
    return self;
}

@end
