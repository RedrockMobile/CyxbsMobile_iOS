//
//  SelfFuncView.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/4/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SelfFuncViewProtocol <NSObject>
- (void)ClickedDeletePostBtn:(UIButton *)sender;

@end

@interface SelfFuncView : UIView

@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) NSNumber *postID;

@property (nonatomic, weak) id<SelfFuncViewProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
