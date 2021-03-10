//
//  MainPageModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/3.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    //没有更多数据
    StateNoMoreDate,
    //停止刷新(加载成功)
    StateEndRefresh,
    //加载失败
    StateFailure,
    //获赞以及评论页是分两次网络请求的，如果其中一个加载失败，一个成功，那就是这种state
    StateFailureAndSuccess,
} MainPageModelDataState;

@protocol MainPageModelDelegate <NSObject>
- (void)mainPageModelLoadDataFinishWithState:(MainPageModelDataState) state;
@end


@interface MainPageModel : NSObject
@property(nonatomic,strong)NSMutableArray <NSDictionary*> *dataArr;
@property(nonatomic,assign)long page;
@property(nonatomic,strong)HttpClient *client;
- (void)loadMoreData;
@end

NS_ASSUME_NONNULL_END
