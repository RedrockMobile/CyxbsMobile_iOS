//
//  GYYSendCommentImageChooseViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 郭蕴尧 on 2021/1/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYYSendCommentImageChooseViewController : UIViewController
@property (nonatomic,assign) int post_id;//动态id
@property (nonatomic,assign) int reply_id;//评论id
//当前的输入内容
@property (nonatomic,copy) NSString *tampComment;

@end

NS_ASSUME_NONNULL_END
