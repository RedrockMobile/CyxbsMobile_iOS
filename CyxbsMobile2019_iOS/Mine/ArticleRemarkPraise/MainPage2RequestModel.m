//
//  MainPage2RequestModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/9.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "MainPage2RequestModel.h"

@interface MainPage2RequestModel ()
@property(nonatomic,copy)NSString *url;
@property(nonatomic,assign)MainPage2RequestModelState state;
@end

/// 评论回复页面和点赞页面 用来网络请求获取数据的model
@implementation MainPage2RequestModel
- (instancetype)initWithUrl:(NSString*)url
{
    self = [super init];
    if (self) {
        self.url = url;
        self.state = MainPage2RequestModelStateEndRefresh;
        self.page = 1;
        self.dataArr = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)loadMoreData {
    NSDictionary *paramDict = @{
        @"page":@(_page),
        @"size":@"10",
    };
    [[HttpClient defaultClient] requestWithPath:_url method:HttpRequestPost parameters:paramDict prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *dataArr = responseObject[@"data"];
        if (dataArr.count < 10) {
            self.state = MainPage2RequestModelStateNoMoreDate;
            [self.delegate MainPage2RequestModelLoadDataFinishWithState:MainPage2RequestModelStateNoMoreDate];
        }else {
            self.state = MainPage2RequestModelStateEndRefresh;
            [self.delegate MainPage2RequestModelLoadDataFinishWithState:MainPage2RequestModelStateEndRefresh];
        }
        
        [self.dataArr addObjectsFromArray:dataArr];
        self.page++;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.state = MainPage2RequestModelStateFailure;
        [self.delegate MainPage2RequestModelLoadDataFinishWithState:(MainPage2RequestModelStateFailure)];
    }];
}

@end
