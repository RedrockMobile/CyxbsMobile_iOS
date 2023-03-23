//
//  SearchPersonModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SearchPersonModel.h"

#import "HttpTool.h"

@implementation SearchPersonModel {
    NSMutableArray <SearchPerson *> *_personAry;
    NSMutableSet <NSString *> *_snoSet;
    NSMutableDictionary <NSString *, SearchPerson *> *_map;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _personAry = NSMutableArray.array;
        _snoSet = NSMutableSet.set;
    }
    return self;
}

- (void)reqestWithInfo:(NSString *)info
               success:(void (^)(void))success
               failure:(void (^)(NSError * _Nonnull))failure {
    
    [HttpTool.shareTool
     request:@"https://be-dev.redrock.cqupt.edu.cn/magipoke-text/search/people"
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:@{
        @"stu" : info
    }
     progress:nil
     success:^(NSURLSessionDataTask *task, id object) {
        if (![object[@"data"] isKindOfClass:NSArray.class]) {
            return;
        }
        self->_personAry = NSMutableArray.array;
        
        NSArray *ary = object[@"data"];
        for (NSDictionary *dictionary in ary) {
            NSString *stuNum = dictionary[@"stunum"];
            if ([self->_snoSet containsObject:stuNum]) {
                continue;
            }
            SearchPerson *person = [[SearchPerson alloc] initWithDictionary:dictionary];
            [self->_personAry addObject:person];
        }
        
        if (success) {
            success();
        }
    }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)removeSno:(NSString *)sno {
    
}

- (void)setSnoSet:(NSSet<NSString *> *)snoSet {
    _snoSet = snoSet.mutableCopy;
}

@end
