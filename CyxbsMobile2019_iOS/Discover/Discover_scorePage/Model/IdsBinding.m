//
//  IdsBinding.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "IdsBinding.h"
#import "UserItem.h"
@implementation IdsBinding
- (instancetype)initWithIdsNum:(NSString *)idsNum isPassword:(NSString *)idsPassword {
    if(self = [super init]) {
        self.idsNum = idsNum;
        self.idsPassword = idsPassword;
    }
    return self;
}

- (void)fetchData {
    
    NSDictionary *paramters = @{@"idsNum":self.idsNum, @"idsPassword":self.idsPassword};
    
    [HttpTool.shareTool
     request:Discover_POST_idsBinding_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerJSON
     bodyParameters:paramters
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        if ([object[@"status"] isEqual:@"10000"]) {
            //ids绑定成功
            [NSUserDefaults.standardUserDefaults setObject:self.idsNum forKey:@"idsAccount"];
            [NSUserDefaults.standardUserDefaults setObject:self.idsPassword forKey:@"idsPasswd"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"IdsBinding_Success" object:nil];
            NSLog(@"ids绑定成功");
            [UserItem defaultItem].idsBindingSuccess = YES;
        }
    }
     failure:nil];
}

@end
