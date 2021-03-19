//
//  CYSearchEndKnowledgeDetailView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/3/18.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYSearchEndKnowledgeDetailModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol CYSearchEndKnowledgeDetailViewDelegate <NSObject>

- (void)deleteKnowledgeDetaileview:(UIView *)view;

@end
/// 重邮知识库详情页
@interface CYSearchEndKnowledgeDetailView : UIView

@property (nonatomic, weak) id <CYSearchEndKnowledgeDetailViewDelegate>delegate;

/// 数据model
@property (nonatomic, strong) CYSearchEndKnowledgeDetailModel *model;
@end

NS_ASSUME_NONNULL_END
