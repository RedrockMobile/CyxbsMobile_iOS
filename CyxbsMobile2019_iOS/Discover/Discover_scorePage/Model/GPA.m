//
//  GPA.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "GPA.h"
@implementation GPA
- (void)fetchData {
   
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:GPAAPI parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [req setValue:[NSString stringWithFormat:@"Bearer %@",[UserItem defaultItem].token] forHTTPHeaderField:@"Authorization"];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error) {
        if ([responseObject[@"status"] intValue] == 10000) {

            GPAItem *item = [[GPAItem alloc]initWithDictionary:responseObject];
            self.gpaItem = item;
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"GPASucceed" object:nil];
    } else {
      
        
    } }] resume];
}
@end
