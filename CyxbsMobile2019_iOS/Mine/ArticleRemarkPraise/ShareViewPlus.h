//
//  ShareViewPlus.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/2/22.
//  Copyright © 2021 Redrock. All rights reserved.


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// shareView的进一步封装版本
@protocol ShareViewPlusDelegate <NSObject>
- (void)ClickedQQZone;
- (void)ClickedVXGroup;
- (void)ClickedQQ;
- (void)ClickedVXFriend;
- (void)ClickedUrl;
@end
@interface ShareViewPlus : UIView
@property (nonatomic,weak)id <ShareViewPlusDelegate> delegate;
- (void)disMiss;
@end

NS_ASSUME_NONNULL_END
