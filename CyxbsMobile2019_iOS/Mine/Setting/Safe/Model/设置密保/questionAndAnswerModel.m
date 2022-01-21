//
//  questionAndAnswerModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/10/31.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "questionAndAnswerModel.h"

@implementation questionAndAnswerModel

- (void)sendQuestionAndAnswerWithId:(NSNumber *) questionid AndContent:(NSString *)content {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = .8f;
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    [responseSerializer setRemovesKeysWithNullValues:YES];
    [responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml",nil]];
    
    manager.responseSerializer = responseSerializer;
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [UserItemTool defaultItem].token]  forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *param = @{@"id":questionid,@"content":content};
    [manager POST:SENDQUESTION parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        self->_Block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
    }];
}

@end
