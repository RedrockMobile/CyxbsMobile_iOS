//
//  TypeButton.h
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/24.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TypeButton;
NS_ASSUME_NONNULL_BEGIN
@protocol TypeButtonDelegate  <NSObject>

- (void)selected:(TypeButton *)sender;

@end
@interface TypeButton : UIButton

@property (nonatomic,weak) id<TypeButtonDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame AndTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
