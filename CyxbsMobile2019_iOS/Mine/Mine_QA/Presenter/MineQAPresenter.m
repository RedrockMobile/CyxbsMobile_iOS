//
//  MineQAPresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/14.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineQAPresenter.h"
#import "MineQAModel.h"
#import "MineQAMyQuestionItem.h"
#import "MineQAMyQuestionDraftItem.h"

@implementation MineQAPresenter

- (void)attachView:(UIViewController<MineQAProtocol> *)view {
    self.model = [[MineQAModel alloc] init];
    self.view = view;
}

- (void)dettachView {
    _view = nil;
}

- (void)requestQuestionsListWithPageNum:(NSNumber *)pageNum andSize:(NSNumber *)size {
    [self.model requestQuestionListWithPageNum:pageNum andPageSize:size succeeded:^(NSDictionary * _Nonnull responseObject) {
        NSMutableArray *itemsArray = [NSMutableArray arrayWithCapacity:6];
        for (NSDictionary *dict in responseObject[@"data"]) {
            MineQAMyQuestionItem *item = [[MineQAMyQuestionItem alloc] initWithDict:dict];
            [itemsArray addObject:item];
        }
        [self.view questionListRequestSucceeded:itemsArray];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

- (void)requestQuestionsDraftListWithPageNum:(NSNumber *)pageNum andSize:(NSNumber *)size {
    [self.model requestQuestionDraftListWithPageNum:pageNum andPageSize:size succeeded:^(NSDictionary * _Nonnull responseObject) {
        NSMutableArray *itemsArray = [NSMutableArray arrayWithCapacity:6];
        for (NSDictionary *dict in responseObject[@"data"]) {
            MineQAMyQuestionDraftItem *item = [[MineQAMyQuestionDraftItem alloc] initWithDict:dict];
            [itemsArray addObject:item];
        }
        [self.view questionDraftListRequestSucceeded:itemsArray];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

- (void)requestAnswerListWithPageNum:(NSNumber *)pageNum andSize:(NSNumber *)size {
    
}

- (void)requestAnswerDraftListWithPageNum:(NSNumber *)pageNum andSize:(NSNumber *)size {
    
}

- (void)requestCommentListWithPageNum:(NSNumber *)pageNum andSize:(NSNumber *)size {
    
}

- (void)requestReCommentListWithPageNum:(NSNumber *)pageNum andSize:(NSNumber *)size {
    
}

@end
