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
    StateNoMoreDate,
    StateEndRefresh,
} MainPageModelDataState;

@protocol MainPageModelDelegate <NSObject>
- (void)mainPageModelLoadDataSuccessWithState:(MainPageModelDataState) state;

- (void)mainPageModelLoadDataFailue;
@end


@interface MainPageModel : NSObject
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,assign)long page;
@property(nonatomic,strong)HttpClient *client;
@property(nonatomic,weak)id <MainPageModelDelegate> delegate;
- (void)loadMoreData;
@end

NS_ASSUME_NONNULL_END
