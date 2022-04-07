//
//  SchoolBusPresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/3/23.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "SchoolBusPresenter.h"
#import "SchoolBusModel.h"
#import "SchoolBusItem.h"

@implementation SchoolBusPresenter

- (void)requestSchoolBusLocation {
    [self.model requestSchoolBusLocation:SCHOOLBUSAPI success:^(NSDictionary * _Nonnull responseObject) {
        NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:10];
        NSArray *array = responseObject[@"data"][@"data"];
//        for (NSDictionary *dict in responseObject[@"data"]) {
//            SchoolBusItem *item = [[SchoolBusItem alloc] initWithDict:dict];
//            [arr addObject:item];
//        }
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    SchoolBusItem *item = [[SchoolBusItem alloc]initWithDict:obj];
                    [mArray addObject:item];
        }];
        
        [self.view schoolBusLocationRequestsSuccess:[mArray copy]];
    } failure:^(NSError * _Nonnull error) {
        [self.view schoolBusLocationRequestsFailure];
    }];
}

- (void)attachView:(UIViewController<SchoolBusProtocol> *)view {
    self.model = [[SchoolBusModel alloc] init];
    self.view = view;
}

- (void)dettachView {
    _view = nil;
}

@end
