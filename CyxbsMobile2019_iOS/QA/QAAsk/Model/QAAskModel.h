//
//  QAAskModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAAskModel : NSObject
@property(strong,nonatomic)NSString *questionId;
//提交问题
- (void)commitAsk:(NSString *)title content:(NSString *)content kind:(NSString *)kind reward:(NSString *)reward disappearTime:(NSString *)disappearTime imageArray:(NSArray *)imageArray;
//保存到草稿箱
- (void)addItemInDraft:(NSString *)title description:(NSString *)description kind:(NSString *)kind;
//更新草稿箱
- (void)updateItemInDraft:(NSString *)title description:(NSString *)description kind:(NSString *)kind;
@end

NS_ASSUME_NONNULL_END
