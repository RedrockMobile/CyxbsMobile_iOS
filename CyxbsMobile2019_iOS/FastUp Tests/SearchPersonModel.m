//
//  SearchPersonModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SearchPersonModel.h"

@implementation SearchPersonModel {
    NSMutableArray <SearchPerson *> *_personAry;
    NSMutableSet <NSString *> *_snoSet;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _personAry = NSMutableArray.array;
    }
    return self;
}

- (void)reqestWithInfo:(NSString *)info
               success:(void (^)(void))success
               failure:(void (^)(NSError * _Nonnull))failure {
    
    [HttpTool.shareTool
     request:STRS(NetURL.base.bedev, NetURL.search.stu)
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerJSON
     bodyParameters:@{
        @"stu" : info
    }
     progress:nil
     success:^(NSURLSessionDataTask *task, id object) {
        
    }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
