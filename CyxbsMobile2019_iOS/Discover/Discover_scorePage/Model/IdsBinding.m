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
-(void)fetchData {
    
    NSDictionary *paramters =@{@"idsNum":self.idsNum, @"idsPassword":self.idsPassword};

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:paramters options:NSJSONWritingPrettyPrinted error: nil];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:IDSBINDINGAPI parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [req setValue:[NSString stringWithFormat:@"Bearer %@",[UserItem defaultItem].token] forHTTPHeaderField:@"Authorization"];
    [req setHTTPBody:data];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if ([responseObject[@"status"] isEqual:@"10000"]) {
                //ids绑定成功
                [[NSUserDefaults standardUserDefaults] setObject:self.idsNum forKey:@"idsAccount"];
                [[NSUserDefaults standardUserDefaults]setObject:self.idsPassword forKey:@"idsPasswd"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"IdsBinding_Success" object:nil];
                NSLog(@"ids绑定成功");
                [UserItem defaultItem].idsBindingSuccess = YES;
            }
            
    } else {
//        NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        if ([responseObject[@"errcode"]  isEqual: @"10010"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"IdsBinding_passwordError" object:nil];
            //密码错误
        }else {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"IdsBindingUnknownError" object:nil];
            //出现了其他的错误
        }
        
    } }] resume];
    

}


@end
