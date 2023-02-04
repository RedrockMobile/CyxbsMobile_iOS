//
//  DiscoverTodoTableViewAnimationView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/5.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiscoverTodoTableViewAnimationView : UIView
- (instancetype)initWithCellFrame:(CGRect)cellRect labelFrame:(CGRect)labelFrame;
- (void)begainAnimationWithCompletionBlock:(void(^)(void))completion;
@end

NS_ASSUME_NONNULL_END
