//
//  GYYShareView.h
//  CyxbsMobile2019_iOS
//
//  Created by 郭蕴尧 on 2021/1/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GYYShareViewDelegate <NSObject>
- (void)shareViewAction;
@end

NS_ASSUME_NONNULL_BEGIN

@interface GYYShareView : UIView
@property (nonatomic,weak) id<GYYShareViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
