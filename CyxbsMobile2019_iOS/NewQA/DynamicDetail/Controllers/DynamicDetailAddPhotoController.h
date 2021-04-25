//
//  DynamicDetailAddPhotoController.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/4/19.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 概述：添加图片的conttroller
 
 根据几级评论标识来确定要不要添加图片
 */
@interface DynamicDetailAddPhotoController : UIViewController
/// 几级评论的标识
@property (nonatomic, assign) int commentLevel;
///动态id
@property (nonatomic,assign) int post_id;
///评论id
@property (nonatomic,assign) int reply_id;

/// 是否是一级评论
@property (nonatomic, assign) BOOL isFirstCommentLevel;

///当前的输入内容
@property (nonatomic,copy) NSString *tampComment;
@end

NS_ASSUME_NONNULL_END
