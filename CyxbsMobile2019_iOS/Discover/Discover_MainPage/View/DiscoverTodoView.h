//
//  DiscoverTodoView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/6.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol DiscoverTodoViewDelegate <NSObject>

- (void)addBtnClicked;

@end

@interface DiscoverTodoView : UIView
@property(nonatomic, weak)id <DiscoverTodoViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
