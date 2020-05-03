//
//  MyGoodsPresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/5/1.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MyGoodsPresenter.h"
#import "MyGoodsModel.h"
#import "MyGoodsItem.h"

@implementation MyGoodsPresenter

- (void)requestMyGoodsDataWithPage:(NSString *)page andSize:(NSString *)size {
    NSDictionary *params = @{
        @"stunum": [UserDefaultTool getStuNum],
        @"idnum": [UserDefaultTool getIdNum],
        @"page": page,
        @"size": size
    };
    
    [MyGoodsModel requestMyGoodsWithParams:params success:^(NSDictionary * _Nonnull responseObject) {
        NSMutableArray *recieved = [NSMutableArray array];
        NSMutableArray *didNotRecieved = [NSMutableArray array];
        
        for (NSDictionary *itemDict in responseObject[@"data"]) {
            MyGoodsItem *item = [[MyGoodsItem alloc] initWithDict:itemDict];
            if ([itemDict[@"isReceived"] intValue] == 0) {
                [didNotRecieved addObject:item];
            } else {
                [recieved addObject:item];
            }
        }
        [self.view myGoodsDataRequestsSuccessWithRecievedArray:recieved andDidNotRecievedArray:didNotRecieved];
        
    } failure:^(NSError * _Nonnull error) {
        [self.view myGoodsDataRequestsFailure:error];
    }];
}


- (void)attatchView:(UIViewController<MyGoodsProtocol> *)view {
    self.view = view;
}

- (void)dettatchView {
    _view = nil;
}

@end
