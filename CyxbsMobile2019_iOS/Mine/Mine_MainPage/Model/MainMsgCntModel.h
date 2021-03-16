//
//  MainMsgCntModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/4.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MainMsgCntModelLoadDataStateSuccess_comment,
    MainMsgCntModelLoadDataStateFailure_comment,
    MainMsgCntModelLoadDataStateSuccess_praise,
    MainMsgCntModelLoadDataStateFailure_praise,
    MainMsgCntModelLoadDataStateSuccess_userCnt,
    MainMsgCntModelLoadDataStateFailure_userCnt,
} MainMsgCntModelLoadDataState;

#define praiseLastClickTimeKey @"praiseLastClickTimeKey"
#define remarkLastClickTimeKey @"remarkLastClickTimeKey"


NS_ASSUME_NONNULL_BEGIN

@protocol MainMsgCntModelDelegate <NSObject>
- (void)mainMsgCntModelLoadDataFinishWithState:(MainMsgCntModelLoadDataState)state;
@end

@interface MainMsgCntModel : NSObject
@property(nonatomic,copy)NSString *uncheckedCommentCnt;
@property(nonatomic,copy)NSString *uncheckedPraiseCnt;
@property(nonatomic,copy)NSString *commentCnt;
@property(nonatomic,copy)NSString *dynamicCnt;
@property(nonatomic,copy)NSString *praiseCnt;
@property(nonatomic,weak)id <MainMsgCntModelDelegate> delegate;
- (void)mainMsgCntModelLoadMoreData;
@end

NS_ASSUME_NONNULL_END
