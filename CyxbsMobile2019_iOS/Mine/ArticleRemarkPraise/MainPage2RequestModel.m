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

@implementation MainPage2RequestModel
- (instancetype)initWithUrl:(NSString*)url
{
    self = [super init];
    if (self) {
        self.url = url;
        self.type1State = StateEndRefresh;
        self.type2State = StateEndRefresh;
        self.page1 = 1;
        self.page2 = 1;
        self.dataArr = [[NSMutableArray alloc] init];
        self.tmpArr = [[NSMutableArray alloc] init];
        self.client = [HttpClient defaultClient];
        self.que = dispatch_queue_create(url.UTF8String, DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}
- (void)loadMoreData {
    [self loadMoreDataWithType:@"1" page:&_page1 state:&_type1State];
    [self loadMoreDataWithType:@"2" page:&_page2 state:&_type2State];
    dispatch_barrier_async(self.que, ^{
        [self.dataArr addObjectsFromArray:[self.tmpArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//            CCLog(@"size:%ld,%ld",[obj1[@"publish_time"] longValue],[obj2[@"publish_time"] longValue]);
            return [obj1[@"comment"][@"publish_time"] longValue] < [obj2[@"comment"][@"publish_time"] longValue];
        }]];
        [self.tmpArr removeAllObjects];
        
        if (self.type1State==StateFailure&&self.type2State==StateFailure) {
            //全部失败
            [self.delegate MainPage2RequestModelLoadDataFinishWithState:StateFailure];
        }else if (self.type1State==StateNoMoreDate&&self.type2State==StateNoMoreDate) {
            //全部加载完毕
            [self.delegate MainPage2RequestModelLoadDataFinishWithState:StateNoMoreDate];
        }else if ((self.type1State==StateEndRefresh&&self.type2State!=StateFailure)||(self.type1State!=StateFailure&&self.type2State==StateEndRefresh)) {
            //全部成功（没有更多数据也视为成功）
            [self.delegate MainPage2RequestModelLoadDataFinishWithState:StateEndRefresh];
        }else {
            //部分成功
            [self.delegate MainPage2RequestModelLoadDataFinishWithState:StateFailureAndSuccess];
        }
        
    });
}

- (void)loadMoreDataWithType:(NSString*)type page:(long*)page state:(MainPage2RequestModelState*)state{
    if (*state==StateNoMoreDate) {
        return;
    }
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_async(self.que, ^{
        NSDictionary *paramDict = @{
            @"page":@(*page),
            @"size":@"10",
            @"type":type,
        };
        [self.client requestWithPath:self.url method:HttpRequestPost parameters:paramDict prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"data"] count] < 7) {
                *state = StateNoMoreDate;
            }else {
                (*page)++;
                *state = StateEndRefresh;
            }
            CCLog(@"cnt=%ld",[responseObject[@"data"] count]);
            CCLog(@"res=%@",responseObject);
            
            [self.tmpArr addObjectsFromArray:responseObject[@"data"]];
            
            dispatch_semaphore_signal(sema);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            *state = StateFailure;
            dispatch_semaphore_signal(sema);
        }];
        
        dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 17 * NSEC_PER_SEC));
    });
    
}
@end
