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
#import "MineQAMyAnswerItem.h"
#import "MineQAMyAnswerDraftItem.h"
#import "MineQACommentItem.h"
#import "MineQARecommentItem.h"

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
    [self.model requestAnswerListWithPageNum:pageNum andPageSize:size succeeded:^(NSDictionary * _Nonnull responseObject) {
        NSMutableArray *itemsArray = [NSMutableArray arrayWithCapacity:6];
        for (NSDictionary *dict in responseObject[@"data"]) {
            MineQAMyAnswerItem *item = [[MineQAMyAnswerItem alloc] initWithDict:dict];
            [itemsArray addObject:item];
        }
        [self.view answerListRequestSucceeded:itemsArray];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

- (void)requestAnswerDraftListWithPageNum:(NSNumber *)pageNum andSize:(NSNumber *)size {
    [self.model requestAnswerDraftListWithPageNum:pageNum andPageSize:size succeeded:^(NSDictionary * _Nonnull responseObject) {
        NSMutableArray *itemsArray = [NSMutableArray arrayWithCapacity:6];
        for (NSDictionary *dict in responseObject[@"data"]) {
            MineQAMyAnswerDraftItem *item = [[MineQAMyAnswerDraftItem alloc] initWithDict:dict];
            [itemsArray addObject:item];
        }
        [self.view answerDraftListRequestSucceeded:itemsArray];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

- (void)requestCommentListWithPageNum:(NSNumber *)pageNum andSize:(NSNumber *)size {
    [self.model requestCommentListWithPageNum:pageNum andPageSize:size succeeded:^(NSDictionary * _Nonnull responseObject) {
        NSMutableArray *itemsArray = [NSMutableArray arrayWithCapacity:6];
        for (NSDictionary *dict in responseObject[@"data"]) {
            MineQACommentItem *item = [[MineQACommentItem alloc] initWithDict:dict];
            [itemsArray addObject:item];
        }
        [self.view commentListRequestSucceeded:itemsArray];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

- (void)requestReCommentListWithPageNum:(NSNumber *)pageNum andSize:(NSNumber *)size {
    [self.model requestReCommentListWithPageNum:pageNum andPageSize:size succeeded:^(NSDictionary * _Nonnull responseObject) {
        NSMutableArray *itemsArray = [NSMutableArray arrayWithCapacity:6];
        for (NSDictionary *dict in responseObject[@"data"]) {
            MineQARecommentItem *item = [[MineQARecommentItem alloc] initWithDict:dict];
            [itemsArray addObject:item];
        }
        [self.view reCommentListRequestSucceeded:itemsArray];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

@end
