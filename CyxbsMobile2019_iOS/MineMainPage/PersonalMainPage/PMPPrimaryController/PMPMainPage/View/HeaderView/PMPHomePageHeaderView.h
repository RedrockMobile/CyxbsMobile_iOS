//
//  PMPHomePageHeaderView.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/8.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
// subviews
#import "PMPTextButton.h"
#import "PMPAvatarImgView.h"
#import "PMPEditingButton.h"
#import "PMPBasicActionView.h"

NS_ASSUME_NONNULL_BEGIN

@class PMPHomePageHeaderView;
@protocol PMPHomePageHeaderViewDelegate <NSObject>

- (void)textButtonClickedWithIndex:(NSUInteger)index;
- (void)editingButtonClicked;
- (void)backgroundViewClicked;
- (void)followButtonClicked:(UIButton *)sender;

@end

@interface PMPHomePageHeaderView : UIView

@property (nonatomic, weak) id <PMPHomePageHeaderViewDelegate> delegate;

- (void)refreshDataWithNickname:(NSString *)nickname
                          grade:(NSString *)grade
                  constellation:(NSString *)constellation
                         gender:(NSString *)gender
                   introduction:(NSString *)introduction
                            uid:(NSInteger)uid
                      photo_src:(NSString *)photo_src
                         isSelf:(BOOL)isSelf
                    identityies:(NSArray <NSString *> *)identityies
                        isFocus:(BOOL)isFocus;

- (void)refreshDataWithFans:(NSInteger)fans
                    follows:(NSInteger)follows
                     praise:(NSInteger)praise;

- (void)changeFollowStateSelected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
