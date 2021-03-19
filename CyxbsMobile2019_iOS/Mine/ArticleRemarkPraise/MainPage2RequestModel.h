//
//  MainPage2RequestModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/9.
//  Copyright © 2021 Redrock. All rights reserved.
//评论回复页面和点赞页面 用来网络请求获取数据的model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    //没有更多数据
    MainPage2RequestModelStateNoMoreDate,
    //停止刷新(加载成功)
    MainPage2RequestModelStateEndRefresh,
    //加载失败
    MainPage2RequestModelStateFailure,
    //获赞以及评论页是分两次网络请求的，如果其中一个加载失败，一个成功，那就是这种state
    MainPage2RequestModelStateFailureAndSuccess,
} MainPage2RequestModelState;

//加载数据完成时调用
@protocol MainPage2RequestModelDelegate <NSObject>
- (void)MainPage2RequestModelLoadDataFinishWithState:(MainPage2RequestModelState) state;
@end


@interface MainPage2RequestModel : NSObject

/// 数据数组
@property(nonatomic,strong)NSMutableArray <NSDictionary*> *dataArr;

@property(nonatomic,assign)long page1;
@property(nonatomic,assign)MainPage2RequestModelState type1State;
@property(nonatomic,assign)long page2;
@property(nonatomic,assign)MainPage2RequestModelState type2State;

@property(nonatomic,strong)HttpClient *client;
@property(nonatomic,weak)id<MainPage2RequestModelDelegate>delegate;
- (void)loadMoreData;
- (instancetype)initWithUrl:(NSString*)url;
@end

NS_ASSUME_NONNULL_END
