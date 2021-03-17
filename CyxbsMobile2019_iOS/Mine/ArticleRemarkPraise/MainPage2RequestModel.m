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
@property(nonatomic,strong)NSMutableArray *tmpArr;
@end

/// 评论回复页面和点赞页面 用来网络请求获取数据的model
@implementation MainPage2RequestModel
- (instancetype)initWithUrl:(NSString*)url
{
    self = [super init];
    if (self) {
        self.url = url;
        self.type1State = MainPage2RequestModelStateEndRefresh;
        self.type2State = MainPage2RequestModelStateEndRefresh;
        self.page1 = 1;
        self.page2 = 1;
        self.dataArr = [[NSMutableArray alloc] init];
        self.tmpArr = [[NSMutableArray alloc] init];
        self.client = [HttpClient defaultClient];
    }
    return self;
}
- (void)loadMoreData {
    dispatch_queue_t que = dispatch_queue_create(self.url.UTF8String, DISPATCH_QUEUE_CONCURRENT);
    [self loadMoreDataWithType:@"1" page:&_page1 state:&_type1State concurrentQue:que];
    [self loadMoreDataWithType:@"2" page:&_page2 state:&_type2State concurrentQue:que];
    
    dispatch_barrier_async(que, ^{
        [self.dataArr addObjectsFromArray:[self.tmpArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1[@"comment"][@"publish_time"] longValue] < [obj2[@"comment"][@"publish_time"] longValue];
        }]];
        [self.tmpArr removeAllObjects];
        
        if (self.type1State==MainPage2RequestModelStateFailure&&self.type2State==MainPage2RequestModelStateFailure) {
            //全部失败
            [self.delegate MainPage2RequestModelLoadDataFinishWithState:MainPage2RequestModelStateFailure];
        }else if (self.type1State==MainPage2RequestModelStateNoMoreDate&&self.type2State==MainPage2RequestModelStateNoMoreDate) {
            //全部加载完毕
            [self.delegate MainPage2RequestModelLoadDataFinishWithState:MainPage2RequestModelStateNoMoreDate];
        }else if ((self.type1State==MainPage2RequestModelStateEndRefresh&&self.type2State!=MainPage2RequestModelStateFailure)||(self.type1State!=MainPage2RequestModelStateFailure&&self.type2State==MainPage2RequestModelStateEndRefresh)) {
            //全部成功（没有更多数据也视为成功）
            [self.delegate MainPage2RequestModelLoadDataFinishWithState:MainPage2RequestModelStateEndRefresh];
        }else {
            //部分成功
            [self.delegate MainPage2RequestModelLoadDataFinishWithState:MainPage2RequestModelStateFailureAndSuccess];
        }
    });
    
}

- (void)loadMoreDataWithType:(NSString*)type page:(long*)page state:(MainPage2RequestModelState*)state concurrentQue:(dispatch_queue_t)que{
    if (*state==MainPage2RequestModelStateNoMoreDate) {
        return;
    }
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_async(que, ^{
        NSDictionary *paramDict = @{
            @"page":@(*page),
            @"size":@"10",
            @"type":type,
        };
        [self.client requestWithPath:self.url method:HttpRequestPost parameters:paramDict prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"data"] count] < 7) {
                *state = MainPage2RequestModelStateNoMoreDate;
            }else {
                (*page)++;
                *state = MainPage2RequestModelStateEndRefresh;
            }
            CCLog(@"cnt=%ld",[responseObject[@"data"] count]);
            CCLog(@"res=%@",responseObject);
            
            [self.tmpArr addObjectsFromArray:responseObject[@"data"]];
            
            dispatch_semaphore_signal(sema);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            *state = MainPage2RequestModelStateFailure;
            dispatch_semaphore_signal(sema);
        }];
        
        dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 17 * NSEC_PER_SEC));
    });
    
}
@end
