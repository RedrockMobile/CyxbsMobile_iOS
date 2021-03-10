//
//  MainMsgCntModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/4.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MainMsgCntModelDelegate <NSObject>
- (void)loadUncheckedDataSuccess;
- (void)loadUncheckedDataFailure;

- (void)loadUserCountDataSuccess;
- (void)loadUserCountDataFailure;
@end

@interface MainMsgCntModel : NSObject
@property(nonatomic,copy)NSString *uncheckedCommentCnt;
@property(nonatomic,copy)NSString *uncheckedPraiseCnt;
@property(nonatomic,copy)NSString *commentCnt;
@property(nonatomic,copy)NSString *dynamicCnt;
@property(nonatomic,copy)NSString *praiseCnt;
@property(nonatomic,weak)id <MainMsgCntModelDelegate> delegate;
- (void)loadData;
@end

NS_ASSUME_NONNULL_END
